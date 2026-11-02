namespace PerformanceManagementDomain.XrmEndpoint.Logging
{
    using SFA.FCT.CrossDomain.Integration.Common;

    public static class PerformanceManagementLoggingId
    {
        public const int StartFCRXrmEndPointContractApprovedEvent = LoggingEventId.PerformanceManagementDomain + 50;
        public const int StopFCRXrmEndPointContractApprovedEvent = LoggingEventId.PerformanceManagementDomain + 51;
        public const int StartPersistFundingClaimReconciliation = LoggingEventId.PerformanceManagementDomain + 52;
        public const int FinishPersistFundingClaimReconciliation = LoggingEventId.PerformanceManagementDomain + 53;
        public const int StartPublishFundingClaimReconciliation = LoggingEventId.PerformanceManagementDomain + 54;
        public const int FinishPublishFundingClaimReconciliation = LoggingEventId.PerformanceManagementDomain + 55;
        public const int StartPublicationOfFundingClaimReconciliationFailed = LoggingEventId.PerformanceManagementDomain + 56;
        public const int FinishedPublicationOfFundingClaimReconciliationFailed = LoggingEventId.PerformanceManagementDomain + 57;
    }
}