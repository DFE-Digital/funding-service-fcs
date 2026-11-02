namespace ContractManagementDomain.Endpoint.LevyAmendmentEndpoint.DTOs
{
    using SFA.FCT.CrossDomain.Integration.Entities;

    public class AmendBulkComponentLevyContractResult
    {
        private AmendBulkComponentLevyContractResult() { }

        public AmendBulkComponentLevyContractResult(ContractInformation incrementContractVersionInfo,
            ContractInformation preIncrementContractVersionInfo,
            NotificationInformationDto notificationInformationInfo)
        {
            IncrementContractVersionInfo = incrementContractVersionInfo;
            PreIncrementContractVersionInfo = preIncrementContractVersionInfo;
            NotificationInformationInfo = notificationInformationInfo;
        }

        public AmendBulkComponentLevyContractResult(NotificationInformationDto notificationInformationInfo)
        {
            NotificationInformationInfo = notificationInformationInfo;
        }

        public static AmendBulkComponentLevyContractResult Empty()
        {
            return new AmendBulkComponentLevyContractResult();
        }

        public ContractInformation IncrementContractVersionInfo { get; }

        public ContractInformation PreIncrementContractVersionInfo { get; }

        public NotificationInformationDto NotificationInformationInfo { get; }

        public bool IsEmpty()
        {
            return (IncrementContractVersionInfo == null && PreIncrementContractVersionInfo == null && NotificationInformationInfo == null);
        }
    }
}