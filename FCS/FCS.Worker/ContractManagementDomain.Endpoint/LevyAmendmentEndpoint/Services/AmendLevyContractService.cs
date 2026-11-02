namespace ContractManagementDomain.Endpoint.LevyAmendmentEndpoint.Services
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using DTOs;
    using Extensions;
    using Repositories;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.ContractManagementDomain.Integration.Dtos;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using ContractInformation = SFA.FCT.CrossDomain.Integration.Entities.ContractInformation;

    public class AmendLevyContractService : IAmendLevyContractService
    {
        private readonly IRoatpProviderRepository _roatpProviderRepository;
        private readonly ICrmContractRepository _crmContractRepository;
        private readonly ILogger _logger;

        private const string ClosureNotificationText = "contract closure has been initiated";
        private const string TerminationOrModificationTextRoot = "contract is awaiting approval of";

        private static readonly IReadOnlyCollection<ContractSubStatus> ClosureSubStatusesRequiringNotification = new List<ContractSubStatus>
        {
            ContractSubStatus.AwaitingClosureApproval,
            ContractSubStatus.ClosureInitiationinProgress
        };

        public AmendLevyContractService(IRoatpProviderRepository roatpProviderRepository, ICrmContractRepository crmContractRepository, ILogger logger)
        {
            _roatpProviderRepository = roatpProviderRepository;
            _crmContractRepository = crmContractRepository;
            _logger = logger;
        }

        public AmendBulkComponentLevyContractResult AmendSingleLevyContract(
            ContractInformation contractInformation,
            AmendmentType amendmentType,
            bool shouldAddPayableNonLevyAllocation,
            bool allowUnderTermination)
        {
            string noActionTakenLogMessage;

            var goodToContinueResult = GoodToContinue(contractInformation, amendmentType, "Single");

            if (goodToContinueResult.IsGood)
            {
                ContractStatusInfo latestContractStatusFromCrm = _crmContractRepository.GetContractStatusIfContractIsLatest(
                    contractInformation.ContractNumber, contractInformation.ContractVersionNumber, contractInformation.SubVersionNumber);

                if (latestContractStatusFromCrm != null)
                {
                    contractInformation.ContractStatus = latestContractStatusFromCrm.ContractStatus;
                    contractInformation.ContractSubStatus = latestContractStatusFromCrm.ContractSubStatus;

                    if (ClosureStatusAndSubStatusRequiresNotification(contractInformation.ContractStatus, contractInformation.ContractSubStatus))
                    {
                        return new AmendBulkComponentLevyContractResult(
                            notificationInformationInfo: new NotificationInformationDto(
                                contractInformation, ClosureNotificationText,
                                NotificationInformationDto.NotificationReason.ContractClosureFound));
                    }

                    var terminationOrModificationResult = GetTerminationOrModificationResult(contractInformation.ContractStatus,
                        contractInformation.ContractSubStatus);

                    if (terminationOrModificationResult.IsAwaiting)
                    {
                        return new AmendBulkComponentLevyContractResult(
                            notificationInformationInfo: new NotificationInformationDto(
                                contractInformation, terminationOrModificationResult.NotificationText,
                                terminationOrModificationResult.NotificationReason));
                    }

                    if (contractInformation.IsStatusValidForAmendment(allowUnderTermination))
                    {
                        return new AmendBulkComponentLevyContractResult(
                            incrementContractVersionInfo: contractInformation,
                            preIncrementContractVersionInfo: null,
                            notificationInformationInfo: null);
                    }

                    if (IsContractPublishedToProvider(contractInformation.ContractStatus, contractInformation.ContractSubStatus))
                    {
                        return new AmendBulkComponentLevyContractResult(
                            incrementContractVersionInfo: null,
                            preIncrementContractVersionInfo: contractInformation,
                            notificationInformationInfo: null);
                    }
                    noActionTakenLogMessage = $"AmendLevyContract - Single: No action taken - {contractInformation}";
                }
                else
                {
                    noActionTakenLogMessage = $"AmendLevyContract - Single: Contract is not latest. No action taken - {contractInformation}";
                }
            }
            else
            {
                noActionTakenLogMessage = goodToContinueResult.FailResultText;
            }
            _logger.LogInformation(ContractManagementLoggingEvents.AmendLevyContractNoActionTaken, noActionTakenLogMessage);
            return AmendBulkComponentLevyContractResult.Empty();
        }

        public AmendBulkComponentLevyContractResult AmendBulkComponentLevyContract(
            ContractInformation contractInformation, 
            AmendmentType amendmentType,
            bool shouldAddPayableNonLevyAllocation,
            bool allowUnderTermination,
            ConnectionInfo connectionInfo)
        {
            string noActionTakenLogMessage;

            var goodToContinueResult = GoodToContinue(contractInformation, amendmentType, "Bulk");

            if (goodToContinueResult.IsGood)
            {
                if (ClosureStatusAndSubStatusRequiresNotification(contractInformation.ContractStatus, contractInformation.ContractSubStatus))
                {
                    return new AmendBulkComponentLevyContractResult(
                        notificationInformationInfo: new NotificationInformationDto(
                            contractInformation, ClosureNotificationText,
                            NotificationInformationDto.NotificationReason.ContractClosureFound));
                }

                var terminationOrModificationResult = GetTerminationOrModificationResult(contractInformation.ContractStatus,
                    contractInformation.ContractSubStatus);

                if (terminationOrModificationResult.IsAwaiting)
                {
                    return new AmendBulkComponentLevyContractResult(
                        notificationInformationInfo: new NotificationInformationDto(
                            contractInformation, terminationOrModificationResult.NotificationText,
                            terminationOrModificationResult.NotificationReason));
                }

                if (contractInformation.IsStatusValidForAmendment(allowUnderTermination))
                {
                    return new AmendBulkComponentLevyContractResult(
                        incrementContractVersionInfo: CheckForRoatpPresence(
                            contractInformation,
                            logMessage: $"AmendLevyContract - Bulk component: Approved contract was not on Roatp. No action taken - {contractInformation}",
                            connectionInfo: connectionInfo),
                        preIncrementContractVersionInfo: null,
                        notificationInformationInfo: null);
                }

                if (IsContractPublishedToProvider(contractInformation.ContractStatus, contractInformation.ContractSubStatus))
                {
                    return new AmendBulkComponentLevyContractResult(
                        incrementContractVersionInfo: null,
                        preIncrementContractVersionInfo: CheckForRoatpPresence(
                            contractInformation,
                            logMessage: $"AmendLevyContract: Draft PublishedtoProvider contract was not on Roatp. No action taken - {contractInformation}",
                            connectionInfo: connectionInfo),
                        notificationInformationInfo: null);
                }
                noActionTakenLogMessage = $"AmendLevyContract - Bulk component: No action taken - {contractInformation}";
            }
            else
            {
                noActionTakenLogMessage = goodToContinueResult.FailResultText;
            }

            _logger.LogInformation(ContractManagementLoggingEvents.AmendLevyContractNoActionTaken, noActionTakenLogMessage);
            return AmendBulkComponentLevyContractResult.Empty();
        }

        private ContractInformation CheckForRoatpPresence(ContractInformation contractInformation, string logMessage, ConnectionInfo connectionInfo)
        {
            if (_roatpProviderRepository.IsProviderOnRoatp(contractInformation.Ukprn, connectionInfo).Result)
            {
                return contractInformation;
            }

            _logger.LogInformation(ContractManagementLoggingEvents.AmendLevyContractNotOnRoatp, logMessage);
            return null;
        }

        private static Func<ContractStatus, ContractSubStatus, bool> IsContractPublishedToProvider =>
            (cs, css) => cs == ContractStatus.Draft && css == ContractSubStatus.PublishedtoProvider;

        private static Func<ContractStatus, ContractSubStatus, bool> ClosureStatusAndSubStatusRequiresNotification =>
            (cs, css) => cs == ContractStatus.Approved && ClosureSubStatusesRequiringNotification.Contains(css);

        private static Func<ContractStatus, AmendmentType, bool> IsNotificationAmendmentAndStatusNotApproved =>
            (cs, at) => cs != ContractStatus.Approved && at == AmendmentType.Notification;

        private static GoodToContinueResult GoodToContinue(ContractInformation contractInformation, AmendmentType amendmentType, string levyAmendmentSource)
        {
            if (IsNotificationAmendmentAndStatusNotApproved(contractInformation.ContractStatus, amendmentType))
            {
                return new GoodToContinueResult(false, $"AmendLevyContract - {levyAmendmentSource}: AmendmentType Notification & Status not approved. No action taken - {contractInformation}");
            }

            return new GoodToContinueResult(true, string.Empty);
        }

        private AwaitingTerminationOrModificationResult GetTerminationOrModificationResult(ContractStatus contractStatus,
            ContractSubStatus contractSubStatus)
        {
            return new AwaitingTerminationOrModificationResult(contractStatus, contractSubStatus);
        }

        private class AwaitingTerminationOrModificationResult
        {
            private static readonly Dictionary<ContractSubStatus, (string notificationText, NotificationInformationDto.NotificationReason reason)> SubStatusNotificationTextDictionary =
                new Dictionary<ContractSubStatus, (string notificationText, NotificationInformationDto.NotificationReason reason)>
                {
                    {ContractSubStatus.AwaitingTerminationInitiationApproval, ("termination initiation", NotificationInformationDto.NotificationReason.InitiateContractTerminationFound)},
                    {ContractSubStatus.AwaitingModificationApproval, ("modification", NotificationInformationDto.NotificationReason.AwaitingModificationApprovalFound)}
                };

            public AwaitingTerminationOrModificationResult(ContractStatus status, ContractSubStatus subStatus)
            {
                SubStatus = subStatus;
                Status = status;
            }

            private ContractSubStatus SubStatus { get; }
            private ContractStatus Status { get; }

            public bool IsAwaiting => Status == ContractStatus.Approved && SubStatusNotificationTextDictionary.ContainsKey(SubStatus);

            public string NotificationText => $"{TerminationOrModificationTextRoot} {SubStatusNotificationTextDictionary[SubStatus].notificationText}";

            public NotificationInformationDto.NotificationReason NotificationReason => SubStatusNotificationTextDictionary[SubStatus].reason;
        }
    }

    public class GoodToContinueResult
    {
        public GoodToContinueResult(bool isGood, string failResultText)
        {
            IsGood = isGood;
            FailResultText = failResultText;
        }

        public bool IsGood { get; }

        public string FailResultText { get; }
    }
}