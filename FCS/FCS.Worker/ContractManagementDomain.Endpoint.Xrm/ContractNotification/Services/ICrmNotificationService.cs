namespace ContractManagementDomain.Endpoint.Xrm.ContractNotification.Services
{
    using Dtos;

    public interface ICrmNotificationService
    {
        void CreateInitiateClosureFailedNotificationForContract(NotificationInfo notificationInfo);

        void CreateApproveClosureFailedNotificationForContract(NotificationInfo notificationInfo);

        void CreateContractAmendmentFailedNotificationForContract(NotificationInfo notificationInfo);

        void CreateContractVariationNonFinancialAmendmentFailedNotificationForContract(NotificationInfo notificationInfo);

        void CreateContractNotificationNonFinancialAmendmentFailedNotificationForContract(NotificationInfo notificationInfo);

        void CreateDeleteDraftContractFailedNotificationForContract(NotificationInfo notificationInfo);

        void CreateNotificationForContract(NotificationInfo notificationInfo);
    }
}