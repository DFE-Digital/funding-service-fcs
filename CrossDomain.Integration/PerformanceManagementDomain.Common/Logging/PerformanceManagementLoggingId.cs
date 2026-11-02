namespace SFA.FCT.PerformanceManagementDomain.Common.Logging
{
    using CrossDomain.Integration.Common;

    public static class PerformanceManagementLoggingId
    {
        public const int StartProcessingFundingClaims = LoggingEventId.PerformanceManagementDomain + 1;
        public const int FinishProcessingFundingClaims = LoggingEventId.PerformanceManagementDomain + 2;
        public const int FundingClaimPollingPollClosedCollectionsCommandArrived = LoggingEventId.PerformanceManagementDomain + 3;
        public const int ClosedFundingClaimCollectionRetrievedFromDeds = LoggingEventId.PerformanceManagementDomain + 4;
        public const int FundingClaimPollingRetrievedCountForCollection = LoggingEventId.PerformanceManagementDomain + 5;
        public const int FundingClaimPollingFundingClaimPageRequestCommandArrived = LoggingEventId.PerformanceManagementDomain + 6;
        public const int FundingClaimPollingRetrievedFundingClaims = LoggingEventId.PerformanceManagementDomain + 7;
        public const int FundingClaimPollingLastPageStoredForCollection = LoggingEventId.PerformanceManagementDomain + 8;
        public const int FundingClaimPollingFundingClaimsLoadedCommandArrived = LoggingEventId.PerformanceManagementDomain + 9;
        public const int FundingClaimPollingUsingLastClosedCollectionTime = LoggingEventId.PerformanceManagementDomain + 10;
        public const int FundingClaimPollingUpdatingClaimCollectionImportInfoTable = LoggingEventId.PerformanceManagementDomain + 11;
        public const int StartProcessingContractApprovedEvent = LoggingEventId.PerformanceManagementDomain + 12;
        public const int StopProcessingContractApprovedEvent = LoggingEventId.PerformanceManagementDomain + 13;
        public const int StartInitiatePublishFundingClaimReconciliation = LoggingEventId.PerformanceManagementDomain + 14;
        public const int FinishInitiatePublishFundingClaimReconciliation = LoggingEventId.PerformanceManagementDomain + 15;
        public const int InitiatePublishFundingClaimReconciliationError = LoggingEventId.PerformanceManagementDomain + 16;
        public const int TotalFundingClaimsExpectedIsLessThanRowsInTable = LoggingEventId.PerformanceManagementDomain + 17;
        public const int InitiatePublishOfFundingClaimHasOccurredAfterCloseDate = LoggingEventId.PerformanceManagementDomain + 18;
        public const int StartRecalculationOfFundingClaimReconciliation = LoggingEventId.PerformanceManagementDomain + 19;
        public const int FinishRecalculationOfFundingClaimReconciliation = LoggingEventId.PerformanceManagementDomain + 20;
        public const int StartFundingClaimReconcilationCalculation = LoggingEventId.PerformanceManagementDomain + 21;
        public const int FinishFundingClaimReconcilationCalculation = LoggingEventId.PerformanceManagementDomain + 22;
        public const int FundingClaimAllocationRejected = LoggingEventId.PerformanceManagementDomain + 23;
        public const int StartInitiateReCalculationForFcrCommand = LoggingEventId.PerformanceManagementDomain + 24;
        public const int FinishInitiateReCalculationForFcrCommand = LoggingEventId.PerformanceManagementDomain + 25;
        public const int FundingClaimPollingPollClosedCollectionsCommandProcessed = LoggingEventId.PerformanceManagementDomain + 26;
        public const int BeginPullOfFundingClaimsForClosedCollectionCommandArrived = LoggingEventId.PerformanceManagementDomain + 27;
        public const int BeginPullOfFundingClaimsForClosedCollectionCommandProcessed = LoggingEventId.PerformanceManagementDomain + 28;
        public const int FundingClaimsForCollectionCount = LoggingEventId.PerformanceManagementDomain + 29;
        public const int PullPageForPeriodClaimTypeCommandArrived = LoggingEventId.PerformanceManagementDomain + 30;
        public const int PullPageForPeriodClaimTypeCommandProcessed = LoggingEventId.PerformanceManagementDomain + 31;
        public const int PullPageForPeriodClaimTypeLastPageStoredForCollection = LoggingEventId.PerformanceManagementDomain + 32;
        public const int TotalFundingClaimsImportedExceedsExpected = LoggingEventId.PerformanceManagementDomain + 33;
        public const int UpdateExistingPeriodClaimTypeCommandReceived = LoggingEventId.PerformanceManagementDomain + 34;
        public const int UpdateExistingPeriodClaimTypeCommandProcessed = LoggingEventId.PerformanceManagementDomain + 35;
    }
}