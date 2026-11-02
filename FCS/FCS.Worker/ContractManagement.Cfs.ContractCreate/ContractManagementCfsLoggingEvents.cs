namespace ContractManagement.Cfs
{
    using SFA.FCT.CrossDomain.Integration.Common;

    public static class ContractManagementCfsLoggingEvents
    {
        public const int DocumentGenerationCompleteReceived = LoggingEventId.ContractManagementDomainCfs + 1;
        public const int DocumentGenerationCompleteProcessed = LoggingEventId.ContractManagementDomainCfs + 2;
        public const int NewContractCreatedReceived = LoggingEventId.ContractManagementDomainCfs + 3;
        public const int NewContractCreatedProcessed = LoggingEventId.ContractManagementDomainCfs + 4;
    }
}
