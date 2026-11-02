namespace ContractManagementDomain.Endpoint.LevyAmendmentEndpoint
{
    using System.Threading.Tasks;
    using NServiceBus;
    using Services;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using DTOs;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using System;
    using Infrastructure;
    using Repositories;

    public class AmendLevyContractHandler : IHandleMessages<AmendLevyContractCommand>
    {
        private readonly ILogger _logger;
        private readonly IAmendLevyContractService _amendLevyContractService;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;
        private readonly ICrmContractRepository _crmContractRepository;

        public AmendLevyContractHandler(
            ILogger logger,
            IAmendLevyContractService amendLevyContractService,
            ISessionConnectionFactory sessionConnectionFactory,
            ICrmContractRepository crmContractRepository)
        {
            _logger = logger;
            _amendLevyContractService = amendLevyContractService;
            _sessionConnectionFactory = sessionConnectionFactory;
            _crmContractRepository = crmContractRepository;
        }

        public async Task Handle(AmendLevyContractCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(ContractManagementLoggingEvents.AmendLevyContractCommandArrived, $"AmendLevyContractCommand arrived {message}");
            message.ContractInformation.SimpleAllocationInfos = _crmContractRepository.GetAllocationsForContract(
                contractNumber: message.ContractInformation.ContractNumber,
                version: message.ContractInformation.ContractVersionNumber,
                subVersion: message.ContractInformation.SubVersionNumber);

            if (message.AmendmentSource == AmendLevyContractCommand.LevyAmendmentSource.Bulk)
            {
                var connectionInfo = _sessionConnectionFactory.GetConnection(context);

                var amendBulkComponentLevyContractBulkResult = _amendLevyContractService.AmendBulkComponentLevyContract(
                    message.ContractInformation,
                    message.AmendmentType,
                    message.ShouldAddPayableNonLevyAllocation,
                    message.AllowUnderTermination,
                    connectionInfo);
                await ProcessResult(context, amendBulkComponentLevyContractBulkResult, message).ConfigureAwait(continueOnCapturedContext: false);
            }
            else if (message.AmendmentSource == AmendLevyContractCommand.LevyAmendmentSource.Single)
            {
                var amendBulkComponentLevyContractSingleResult = _amendLevyContractService.AmendSingleLevyContract(
                    message.ContractInformation,
                    message.AmendmentType,
                    message.ShouldAddPayableNonLevyAllocation,
                    message.AllowUnderTermination);
                await ProcessResult(context, amendBulkComponentLevyContractSingleResult, message).ConfigureAwait(continueOnCapturedContext: false);
            }
            else
                throw new ArgumentException($"Unexpected LevyAmendmentSource with a value of {message.AmendmentSource} was passed in");

            _logger.LogInformation(ContractManagementLoggingEvents.AmendLevyContractCommandCompleted, $"AmendLevyContractCommand completed {message}");
        }

        private async Task ProcessResult(IPipelineContext context, AmendBulkComponentLevyContractResult amendBulkComponentLevyContractResult,
            AmendLevyContractCommand message)
        {
            if (amendBulkComponentLevyContractResult.IncrementContractVersionInfo != null)
            {
                await SendIncrementContractVersionCommand(
                        context,
                        amendBulkComponentLevyContractResult.IncrementContractVersionInfo,
                        message.AmendmentType,
                        message.ShouldAddPayableNonLevyAllocation,
                        shouldMergeAmendmentTemplate:message.ShouldMergeAmendmentTemplate,
                        message.OverrideAmendmentTemplate,
                        message.OverrideTemplateName)
                    .ConfigureAwait(continueOnCapturedContext: false);
            }
            if (amendBulkComponentLevyContractResult.PreIncrementContractVersionInfo != null)
            {
                await SendPreIncrementWithdrawalCommand(
                        context,
                        amendBulkComponentLevyContractResult.PreIncrementContractVersionInfo,
                        message.ShouldAddPayableNonLevyAllocation,
                        shouldMergeAmendmentTemplate: message.ShouldMergeAmendmentTemplate, 
                        message.OverrideAmendmentTemplate,
                        message.OverrideTemplateName)
                    .ConfigureAwait(continueOnCapturedContext: false);
            }
            if (amendBulkComponentLevyContractResult.NotificationInformationInfo != null)
            {
                await SendNotificationCommand(context, amendBulkComponentLevyContractResult.NotificationInformationInfo)
                    .ConfigureAwait(continueOnCapturedContext: false);
            }
            if (amendBulkComponentLevyContractResult.IsEmpty())
            {
                _logger.LogInformation(ContractManagementLoggingEvents.AmendLevyContractCommandNoMessageSent, $"AmendLevyContractCommand - No message sent - {message}");
            }
        }

        private static async Task SendIncrementContractVersionCommand(
            IPipelineContext context,
            SFA.FCT.CrossDomain.Integration.Entities.ContractInformation contractInformation,
            AmendmentType amendmentType, bool shouldAddPayableNonLevyAllocation,
            bool shouldMergeAmendmentTemplate, string overrideAmendmentTemplate,
            string overrideTemplateName)
        {
            await context.Send(new IncrementContractVersionCommand
            {
                ContractNumber = contractInformation.ContractNumber,
                VersionNumber = contractInformation.ContractVersionNumber,
                SubVersionNumber = contractInformation.SubVersionNumber,
                AmendmentType = amendmentType,
                ShouldAddPayableNonLevyAllocation = shouldAddPayableNonLevyAllocation,
                ShouldMergeAmendmentTemplate = shouldMergeAmendmentTemplate,
                IsNonFinancialAmendment = false,
                OverrideAmendmentTemplate = overrideAmendmentTemplate,
                OverrideTemplateName = overrideTemplateName
            }).ConfigureAwait(continueOnCapturedContext: false);
        }

        private static async Task SendPreIncrementWithdrawalCommand(
            IPipelineContext context,
            SFA.FCT.CrossDomain.Integration.Entities.ContractInformation contractInformation,
            bool shouldAddPayableNonLevyAllocationToPostWithdrawalAmendment,
            bool shouldMergeAmendmentTemplate, string overrideAmendmentTemplate,
            string overrideTemplateName)
        {
            await context.Send(new PreIncrementWithdrawalCommand
            {
                ContractNumber = contractInformation.ContractNumber,
                MasterContractNumber = contractInformation.MasterContractNumber,
                Ukprn = contractInformation.Ukprn,
                VersionNumber = contractInformation.ContractVersionNumber,
                ShouldAddPayableNonLevyAllocationToPostWithdrawalAmendment = shouldAddPayableNonLevyAllocationToPostWithdrawalAmendment,
                ShouldMergeAmendmentTemplate = shouldMergeAmendmentTemplate,
                OverrideAmendmentTemplate = overrideAmendmentTemplate,
                OverrideTemplateName = overrideTemplateName
            }).ConfigureAwait(continueOnCapturedContext: false);
        }

        private static async Task SendNotificationCommand(IPipelineContext context, NotificationInformationDto notificationInfo)
        {
            NotificationType notificationType = notificationInfo.ReasonForNotification.ToNotificationType();

            await context.Send(new IssueCrmNotificationCommand
            {
                ContractNumber = notificationInfo.ContractInformation.ContractNumber,
                VersionNumber = notificationInfo.ContractInformation.ContractVersionNumber,
                SubVersionNumber = notificationInfo.ContractInformation.SubVersionNumber,
                NotificationText = notificationInfo.NotificationText,
                NotificationType = notificationType
            }).ConfigureAwait(continueOnCapturedContext: false);
        }
    }

    internal static class NotificationReasonExtensions
    {
        public static NotificationType ToNotificationType(this NotificationInformationDto.NotificationReason reason)
        {
            if (reason == NotificationInformationDto.NotificationReason.ContractClosureFound)
            {
                return NotificationType.ContractAmendmentFailedForContractClosureReason;
            }

            if (reason == NotificationInformationDto.NotificationReason.InitiateContractTerminationFound)
            {
                return NotificationType.ContractAmendmentFailedForInitiatedTerminationReason;
            }

            if (reason == NotificationInformationDto.NotificationReason.AwaitingModificationApprovalFound)
            {
                return NotificationType.ContractAmendmentFailedForModificationApprovalFoundReason;
            }

            throw new ArgumentException($"ToNotificationType does not support - {reason}");
        }
    }
}