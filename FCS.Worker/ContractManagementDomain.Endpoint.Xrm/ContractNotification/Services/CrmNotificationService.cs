namespace ContractManagementDomain.Endpoint.Xrm.ContractNotification.Services
{
    using System;
    using System.Collections.Generic;
    using Dtos;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    public class CrmNotificationService : ICrmNotificationService
    {
        private const string InitiateContractClosureTransitionName = "Initiate Contract Closure";
        private const string InitiateContractTerminationTransitionName = "Initiate Contract Termination";
        private const string NonFinancialContractAmendmentFailedNotificationName = "Non-Financial Contract Amendment Failed";

        private readonly ICrmContractRepository _crmContractRepository;
        private readonly ICrmNotificationRepository _crmNotificationRepository;

        public CrmNotificationService(ICrmContractRepository crmContractRepository,
            ICrmNotificationRepository crmNotificationRepository)
        {
            _crmContractRepository = crmContractRepository;
            _crmNotificationRepository = crmNotificationRepository;
        }

        public void CreateInitiateClosureFailedNotificationForContract(NotificationInfo notificationInfo)
        {
            const string closureInitiateFailedNotificationName = "Contract Closure Initiation Failed";

            CreateNotification(
                notificationInfo.ContractNumber,
                notificationInfo.VersionNumber,
                notificationInfo.SubVersionNumber,
                notificationInfo.NotificationText,
                InitiateContractClosureTransitionName,
                closureInitiateFailedNotificationName,
                sfa_notificationtype.ContractClosureInitiationFailed);
        }

        public void CreateApproveClosureFailedNotificationForContract(NotificationInfo notificationInfo)
        {
            const string closureApproveFailedNotificationName = "Contract Closure Failed";
            const string approveContractClosureTransitionName = "Approve Closure";

            CreateNotification(
                notificationInfo.ContractNumber,
                notificationInfo.VersionNumber,
                notificationInfo.SubVersionNumber,
                notificationInfo.NotificationText,
                approveContractClosureTransitionName,
                closureApproveFailedNotificationName,
                sfa_notificationtype.ContractClosureFailed);
        }

        public void CreateContractAmendmentFailedNotificationForContract(NotificationInfo notificationInfo)
        {
            const string contractAmendmentFailedNotificationName = "Contract Amendment Failed";

            string transitionName = GetTransitionNameForNotificationReason(notificationInfo.ReasonForNotification);

            CreateNotification(
                notificationInfo.ContractNumber,
                notificationInfo.VersionNumber,
                notificationInfo.SubVersionNumber,
                notificationInfo.NotificationText,
                transitionName,
                contractAmendmentFailedNotificationName,
                sfa_notificationtype.ContractAmendmentFailed);
        }

        public void CreateContractVariationNonFinancialAmendmentFailedNotificationForContract(NotificationInfo notificationInfo)
        {
            const string initiateNonFinancialAmendmentVariationTransistionName =
                "Initiate Non-Financial Amendment (Vary)";

            CreateNotification(
                notificationInfo.ContractNumber,
                notificationInfo.VersionNumber,
                notificationInfo.SubVersionNumber,
                notificationInfo.NotificationText,
                initiateNonFinancialAmendmentVariationTransistionName,
                NonFinancialContractAmendmentFailedNotificationName,
                sfa_notificationtype.NonFinancialContractAmendmentFailed);
        }

        public void CreateContractNotificationNonFinancialAmendmentFailedNotificationForContract(NotificationInfo notificationInfo)
        {
            const string initiateNonFinancialAmendmentNotificationTransistionName =
                "Initiate Non-Financial Amendment (Notify)";

            CreateNotification(
                notificationInfo.ContractNumber,
                notificationInfo.VersionNumber,
                notificationInfo.SubVersionNumber,
                notificationInfo.NotificationText,
                initiateNonFinancialAmendmentNotificationTransistionName,
                NonFinancialContractAmendmentFailedNotificationName,
                sfa_notificationtype.NonFinancialContractAmendmentFailed);
        }

        public void CreateDeleteDraftContractFailedNotificationForContract(NotificationInfo notificationInfo)
        {
            const string deleteInProgressSubStatus = "Delete In Progress";
            const sfa_notificationtype deleteFailedNotificationType = sfa_notificationtype.ContractDeletionFailed;
            string notificationName = $"Draft Contract Deletion Failed - {notificationInfo.ContractNumber}";

            Guid userId =
                _crmContractRepository.GetSpecialTaskOwnerUserForContractWithSubStatus(notificationInfo.ContractNumber,
                    notificationInfo.VersionNumber, deleteInProgressSubStatus);

            ProviderInfo providerInfo =
                _crmContractRepository.GetProviderInfoForContract(notificationInfo.ContractNumber,
                    notificationInfo.VersionNumber);

            string notificationText = CreateNotificationText(
                notificationInfo.ContractNumber,
                notificationInfo.VersionNumber,
                providerInfo,
                deleteFailedNotificationType,
                notificationInfo.NotificationText);

            _crmNotificationRepository.CreateNotificationForUser(
                deleteFailedNotificationType,
                notificationName,
                notificationText,
                userId);
        }

        public void CreateNotificationForContract(NotificationInfo notificationInfo)
        {
            CreateNotification(
                notificationInfo.ContractNumber,
                notificationInfo.VersionNumber,
                notificationInfo.SubVersionNumber,
                notificationInfo.NotificationText,
                notificationInfo.TransitionName,
                notificationInfo.NotificationName,
                GetNotificationtypeForNotificationReason(notificationInfo.ReasonForNotification));
        }

        private void CreateNotification(
            string contractNumber,
            int version,
            int subVersion,
            string notificationText,
            string transitionName,
            string notificationNamePrefix,
            sfa_notificationtype notificationType)
        {
            Guid userId = _crmContractRepository.GetLatestUserIdAssociatedWithWorkflowItemForContract(contractNumber,
                version, subVersion, transitionName);

            ProviderInfo providerInfo = _crmContractRepository.GetProviderInfoForContract(contractNumber, version,
                subVersion);

            _crmNotificationRepository.CreateNotificationForUser(
                notificationType: notificationType,
                notificationName: $"{notificationNamePrefix} - {contractNumber}",
                notificationText: CreateNotificationText(contractNumber, version, providerInfo, notificationType, notificationText),
                userId: userId);
        }

        private string CreateNotificationText(string contractNumber, int version, ProviderInfo providerInfo,
            sfa_notificationtype notificationType, string notificationReasonText)
        {
            return
                $"Contract {contractNumber} v{version} for provider {providerInfo.Ukprn} ({providerInfo.ProviderName}) cannot be {notificationType.GetNotificationCategory()} - {notificationReasonText}";
        }

        private static string GetTransitionNameForNotificationReason(
            NotificationInfo.NotificationReason notificationReason)
        {
            if (notificationReason == NotificationInfo.NotificationReason.ContractClosureFound)
            {
                return InitiateContractClosureTransitionName;
            }

            if (notificationReason == NotificationInfo.NotificationReason.InitiateContractTerminationFound)
            {
                return InitiateContractTerminationTransitionName;
            }

            throw new ArgumentException($"NotificationInfo.NotificationReason {notificationReason} not mapped to transition");
        }

        private static sfa_notificationtype GetNotificationtypeForNotificationReason(NotificationInfo.NotificationReason notificationReason)
        {
            if (notificationReason == NotificationInfo.NotificationReason.ContractTerminationValidationFailed)
            {
                return sfa_notificationtype.ContractTerminationFailed;
            }
           
            return sfa_notificationtype.ContractAmendmentFailed;
        }
    }

    public static class CrmNotificationTypeExtensions
    {
        private static readonly Dictionary<sfa_notificationtype, string> test = new Dictionary<sfa_notificationtype, string>
        {
            { sfa_notificationtype.ContractClosureFailed, "closed" },
            { sfa_notificationtype.ContractClosureInitiationFailed, "closed" },
            { sfa_notificationtype.ContractAmendmentFailed, "amended" },
            { sfa_notificationtype.NonFinancialContractAmendmentFailed, "amended" },
            { sfa_notificationtype.ContractDeletionFailed, "deleted" },
            { sfa_notificationtype.ContractTerminationFailed, "terminated" }
        };

        public static string GetNotificationCategory(this sfa_notificationtype notificationType)
        {
            if (test.ContainsKey(notificationType))
            {
                return test[notificationType];
            }

            throw new ArgumentException($"This notification type is not supported {notificationType}");
        }
    }
}