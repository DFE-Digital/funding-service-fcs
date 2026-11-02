namespace ContractManagementDomain.Endpoint.Xrm.ContractNotification
{
    using System;
    using System.Collections.Generic;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using NServiceBus;
    using Services;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Dtos;
    using System.Threading.Tasks;

    public class IssueCrmNotificationHandler : IHandleMessages<IssueCrmNotificationCommand>
    {
        private readonly ICrmNotificationService _crmNotificationService;
        private readonly ILogger _logger;

        public IssueCrmNotificationHandler(ICrmNotificationService crmNotificationService, ILogger logger)
        {
            _crmNotificationService = crmNotificationService;
            _logger = logger;
        }

        public Task Handle(IssueCrmNotificationCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(ContractManagementLoggingEvents.IssueCrmNotificationCommandReceived,
                $"Issuing CRM notification for contract {message.ContractNumber} v{message.VersionNumber}");

            Dictionary<NotificationType, Action<NotificationInfo>> notificationActionDictionary = new Dictionary<NotificationType, Action<NotificationInfo>>
            {
                { NotificationType.ApproveContractClosureFailed, _crmNotificationService.CreateApproveClosureFailedNotificationForContract },
                { NotificationType.InitiateContractClosureFailed, _crmNotificationService.CreateInitiateClosureFailedNotificationForContract },
                { NotificationType.ContractAmendmentFailedForContractClosureReason, _crmNotificationService.CreateContractAmendmentFailedNotificationForContract},
                { NotificationType.ContractAmendmentFailedForInitiatedTerminationReason, _crmNotificationService.CreateContractAmendmentFailedNotificationForContract},
                { NotificationType.ContractAmendmentVariationNonFinancialAmendmentFailed, _crmNotificationService.CreateContractVariationNonFinancialAmendmentFailedNotificationForContract },
                { NotificationType.ContractAmendmentNotificationNonFinancialAmendmentFailed, _crmNotificationService.CreateContractNotificationNonFinancialAmendmentFailedNotificationForContract },
                { NotificationType.DeleteDraftContractFailed, _crmNotificationService.CreateDeleteDraftContractFailedNotificationForContract },
                { NotificationType.ContractTerminationFailed, _crmNotificationService.CreateNotificationForContract },
                { NotificationType.ContractAmendmentFailedForModificationApprovalFoundReason, _crmNotificationService.CreateNotificationForContract },
            };

            if (!notificationActionDictionary.ContainsKey(message.NotificationType))
            {
                throw new ArgumentException(
                    $"CRM Notification for contract {message.ContractNumber} v{message.VersionNumber} failed - Notification type {message.NotificationType} is not supported",
                    nameof(message.NotificationType));
            }

            var createNotificationMethod = notificationActionDictionary[message.NotificationType];

            NotificationInfo notificationInfo = GetNotificationInfoFromCommand(message);

            createNotificationMethod(notificationInfo);

            _logger.LogInformation(ContractManagementLoggingEvents.IssueCrmNotificationCommandCompleted,
                $"Finished issuing CRM notification for contract {message.ContractNumber} v{message.VersionNumber}");

            return Task.CompletedTask;
        }

        private static NotificationInfo GetNotificationInfoFromCommand(IssueCrmNotificationCommand command)
        {
            NotificationInfo.NotificationReason reason = command.NotificationType.ToNotificationReason();

            return new NotificationInfo(
                command.ContractNumber,
                command.VersionNumber,
                command.SubVersionNumber,
                command.NotificationText,
                reason,
                command.NotificationType.GetTransitionName(),
                command.NotificationType.GetNotificationName());
        }
    }

    internal static class NotificationTypeExtensions
    {
        public static NotificationInfo.NotificationReason ToNotificationReason(this NotificationType notificationType)
        {
            NotificationInfo.NotificationReason reason = NotificationInfo.NotificationReason.NotSet;
            if (notificationType == NotificationType.ContractAmendmentFailedForInitiatedTerminationReason)
            {
                reason = NotificationInfo.NotificationReason.InitiateContractTerminationFound;
            }
            else if (notificationType == NotificationType.ContractAmendmentFailedForContractClosureReason)
            {
                reason = NotificationInfo.NotificationReason.ContractClosureFound;
            }
            else if (notificationType == NotificationType.ContractTerminationFailed)
            {
                reason = NotificationInfo.NotificationReason.ContractTerminationValidationFailed;
            }

            return reason;
        }

        public static string GetNotificationName(this NotificationType notificationType)
        {
            if (notificationType == NotificationType.ContractTerminationFailed)
            {
                return "Contract Termination Failed";
            }

            if (notificationType == NotificationType.ContractAmendmentFailedForModificationApprovalFoundReason)
            {
                return "Contract Amendment Failed";
            }

            return string.Empty;
        }

        public static string GetTransitionName(this NotificationType notificationType)
        {
            if (notificationType == NotificationType.ContractTerminationFailed)
            {
                // we want the transition that started the process so we get the right user
                return "Terminate Contract";
            }
            else if (notificationType == NotificationType.ContractAmendmentFailedForModificationApprovalFoundReason)
            {
                return "Initiate Contract Modification";
            }

            return string.Empty;
        }
    }
}