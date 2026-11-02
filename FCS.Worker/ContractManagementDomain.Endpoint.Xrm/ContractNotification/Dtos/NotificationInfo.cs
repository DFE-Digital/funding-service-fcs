namespace ContractManagementDomain.Endpoint.Xrm.ContractNotification.Dtos
{
    public class NotificationInfo
    {
        public enum NotificationReason
        {
            NotSet,
            InitiateContractTerminationFound,
            ContractClosureFound,
            ContractTerminationValidationFailed,
            AwaitingModificationApprovalFound
        }

        public NotificationInfo(string contractNumber, int versionNumber, int subVersionNumber,
            string notificationText, NotificationReason notificationReason,
            string transitionName, string notificationName)
        {
            ContractNumber = contractNumber;
            VersionNumber = versionNumber;
            SubVersionNumber = subVersionNumber;
            NotificationText = notificationText;
            ReasonForNotification = notificationReason;
            TransitionName = transitionName;
            NotificationName = notificationName;
        }

        public string ContractNumber { get; }

        public int VersionNumber { get; }

        public int SubVersionNumber { get; }

        public string NotificationText { get; }

        public NotificationReason ReasonForNotification { get; }

        public string TransitionName { get; }

        public string NotificationName { get; }
    }
}
