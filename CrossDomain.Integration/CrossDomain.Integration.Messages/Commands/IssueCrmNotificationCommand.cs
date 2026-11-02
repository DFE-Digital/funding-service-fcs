namespace SFA.FCT.CrossDomain.Integration.Messages.Commands
{
    public class IssueCrmNotificationCommand
    {
        public string ContractNumber { get; set; }

        public int VersionNumber { get; set; }

        public int SubVersionNumber { get; set; }

        public string NotificationText { get; set; }

        public NotificationType NotificationType { get; set; }
    }

    public enum NotificationType
    {
        InitiateContractClosureFailed,
        ApproveContractClosureFailed,
        ContractAmendmentFailedForContractClosureReason,
        ContractAmendmentVariationNonFinancialAmendmentFailed,
        ContractAmendmentNotificationNonFinancialAmendmentFailed,
        DeleteDraftContractFailed,
        ContractAmendmentFailedForInitiatedTerminationReason,
        ContractTerminationFailed,
        ContractAmendmentFailedForModificationApprovalFoundReason
    }
}
