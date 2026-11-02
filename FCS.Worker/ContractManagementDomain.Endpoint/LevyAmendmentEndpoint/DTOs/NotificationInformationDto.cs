namespace ContractManagementDomain.Endpoint.LevyAmendmentEndpoint.DTOs
{
    using SFA.FCT.CrossDomain.Integration.Entities;

    public class NotificationInformationDto
    {
        public enum NotificationReason
        {
            NotSet,
            ContractClosureFound,
            InitiateContractTerminationFound,
            AwaitingModificationApprovalFound
        }

        public NotificationInformationDto(ContractInformation contractInformation, string notificationText, NotificationReason reasonForNotification)
        {
            ContractInformation = contractInformation;
            NotificationText = notificationText;
            ReasonForNotification = reasonForNotification;
        }

        public ContractInformation ContractInformation { get; }

        public string NotificationText { get; }

        public NotificationReason ReasonForNotification { get; }
    }
}