namespace SFA.FCT.AllocationDeliveryDomain.Common
{
    using CrossDomain.Integration.Common;

    public static class AllocationDeliverDomainEventLoggingId
    {
        public const int ActualPollingPollClosedCollectionsCommandArrived = LoggingEventId.AllocationDeliveryDomain;
        public const int ActualPollingLastPageStoredForCollectionType = LoggingEventId.AllocationDeliveryDomain + 1;

        public const int ContractApprovedReceived = LoggingEventId.AllocationDeliveryDomain + 2;
        public const int TransformingAllocation = LoggingEventId.AllocationDeliveryDomain + 3;

        public const int DeletingAllocationDeliverables = LoggingEventId.AllocationDeliveryDomain + 4;
        public const int InsertingAllocationDeliverables = LoggingEventId.AllocationDeliveryDomain + 5;
        public const int AllocationDeliveryCommencedReceived = LoggingEventId.AllocationDeliveryDomain + 6;
        public const int UpdatingCrmWithMonitoringDeliverables = LoggingEventId.AllocationDeliveryDomain + 7;
        public const int AllocationDeliveryCommencedEnd = LoggingEventId.AllocationDeliveryDomain + 8;
        public const int AllocationDeliveryCommencedError = LoggingEventId.AllocationDeliveryDomain + 9;
        public const int AllocationDeliverableInsertError = LoggingEventId.AllocationDeliveryDomain + 10;
        public const int ClosedCollectionEventRetrievedFromDeds = LoggingEventId.AllocationDeliveryDomain + 11;

        public const int SentReportedActualsRoutingCommands = LoggingEventId.AllocationDeliveryDomain + 12;
        public const int ActualPollingUsingLastClosedCollectionTime = LoggingEventId.AllocationDeliveryDomain + 13;
        public const int ActualPollingClosedCollectionHistoryRetrieved = LoggingEventId.AllocationDeliveryDomain + 14;
        public const int ActualPollingClosedCollectionEventCommandArrived = LoggingEventId.AllocationDeliveryDomain + 15;
        public const int ActualPollingCollectionHasBeenProcessedByAnotherMessage = LoggingEventId.AllocationDeliveryDomain + 16;
        public const int ActualPollingStoringCollectionHistory = LoggingEventId.AllocationDeliveryDomain + 17;
        public const int ActualPollingClosedCollectionHistoryStorageExceptionCaught = LoggingEventId.AllocationDeliveryDomain + 18;
        public const int ActualPollingActualsPageRequestCommandArrived = LoggingEventId.AllocationDeliveryDomain + 19;
        public const int ActualPollingRetrievedCountForCollectionType = LoggingEventId.AllocationDeliveryDomain + 20;
        public const int ActualPollingUpdatedActualsCollectionTypeSummary = LoggingEventId.AllocationDeliveryDomain + 21;
        public const int ActualPollingRetrievedActuals = LoggingEventId.AllocationDeliveryDomain + 22;
        public const int ActualPollingAddingAllocationGroupKeyEntity = LoggingEventId.AllocationDeliveryDomain + 23;
        public const int ActualPollingUpdatingCollectionTypeSummaryTable = LoggingEventId.AllocationDeliveryDomain + 24;
        public const int ActualPollingCollectionTypeSummaryStorageExceptionCaught = LoggingEventId.AllocationDeliveryDomain + 25;
        public const int ActualPollingSendReportedActualsLoadedCommandArrived = LoggingEventId.AllocationDeliveryDomain + 26;

        public const int AllocationActualVerificationStarted = LoggingEventId.AllocationDeliveryDomain + 30;
        public const int ActualVerificationFailed = LoggingEventId.AllocationDeliveryDomain + 31;
        public const int AllocationActualVerificationCompleted = LoggingEventId.AllocationDeliveryDomain + 32;
        public const int ReportedActualsRouting = LoggingEventId.AllocationDeliveryDomain + 33;
        public const int ReportActualsGivenFSPActivityCloseDateBeforeCalculationDate = LoggingEventId.AllocationDeliveryDomain + 34;

        public const int StoringActualsCurrentViewError = LoggingEventId.AllocationDeliveryDomain + 35;
        public const int StoredActualsCurrentView = LoggingEventId.AllocationDeliveryDomain + 36;

        public const int StartCheckingForMonthEndCompletion = LoggingEventId.AllocationDeliveryDomain + 40;
        public const int FinishCheckingForMonthEndCompletion = LoggingEventId.AllocationDeliveryDomain + 41;
        public const int DeferCheckForMonthEndCompletion = LoggingEventId.AllocationDeliveryDomain + 42;
        public const int MarkMonthEndAsCompleted = LoggingEventId.AllocationDeliveryDomain + 43;

        public const int ReportedPaymentInstructionsLoadedProcessingStarted = LoggingEventId.AllocationDeliveryDomain + 50;
        public const int ReportedPaymentInstructionsLoadedProcessingFinished = LoggingEventId.AllocationDeliveryDomain + 51;
        public const int ReportedPaymentInstructionValidationFailed = LoggingEventId.AllocationDeliveryDomain + 52;
        public const int CreatedDedsChannelFactory = LoggingEventId.AllocationDeliveryDomain + 53;
        public const int FailedToCreateDedsChannelFactory = LoggingEventId.AllocationDeliveryDomain + 54;

        public const int ClosedHandlerStarted = LoggingEventId.AllocationDeliveryDomain + 60;
        public const int ClosedHandlerCompleted = LoggingEventId.AllocationDeliveryDomain + 61;

        public const int ReleaseHeldReportedActualsStarted = LoggingEventId.AllocationDeliveryDomain + 65;
        public const int ReleaseHeldReportedActualsEnded = LoggingEventId.AllocationDeliveryDomain + 66;
        public const int ReleaseHeldReportedActualsCommandSent = LoggingEventId.AllocationDeliveryDomain + 67;

        public const int MonitoringDeliverableAddedPostApprovalHandlerStarted = LoggingEventId.AllocationDeliveryDomain + 68;
        public const int MonitoringDeliverableAddedPostApprovalHandlerEnded = LoggingEventId.AllocationDeliveryDomain + 69;
        public const int ReportedPaymentInstructionProcessingAddingDeliverableToCrm = LoggingEventId.AllocationDeliveryDomain + 70;
        public const int ReportedPaymentInstructionProcessingAddedDeliverableToCrm = LoggingEventId.AllocationDeliveryDomain + 71;

        public const int ContractPlacedUnderTerminationForApproveInitiationHandlerStarted = LoggingEventId.AllocationDeliveryDomain + 72;
        public const int ContractPlacedUnderTerminationForApproveInitiationHandlerEnded = LoggingEventId.AllocationDeliveryDomain + 73;

        public const int ContractTerminationCancelledHandlerStarted = LoggingEventId.AllocationDeliveryDomain + 74;
        public const int ContractTerminationCancelledHandlerEnded = LoggingEventId.AllocationDeliveryDomain + 75;

        public const int ContractTerminatedHandlerStarted = LoggingEventId.AllocationDeliveryDomain + 76;
        public const int ContractTerminatedHandlerEnded = LoggingEventId.AllocationDeliveryDomain + 77;

        public const int NoActiveActuals = LoggingEventId.AllocationDeliveryDomain + 78;
        public const int NoMatchingActiveAllocationDeliverablePeriod = LoggingEventId.AllocationDeliveryDomain + 79;

        public const int ContractPlacedUnderTerminationForUpdatedDetailsHandlerStarted = LoggingEventId.AllocationDeliveryDomain + 80;
        public const int ContractPlacedUnderTerminationForUpdatedDetailsHandlerEnded = LoggingEventId.AllocationDeliveryDomain + 81;

        public const int ReportedActualsLoadedDuplicate = LoggingEventId.AllocationDeliveryDomain + 82;
        public const int ReportedActualsLoadedDetails = LoggingEventId.AllocationDeliveryDomain + 83;

        public const int BeginDcActualsPullCommandArrived = LoggingEventId.AllocationDeliveryDomain + 84;
        public const int BeginDcActualsPullLatestDate = LoggingEventId.AllocationDeliveryDomain + 85;
        public const int BeginDcActualsPullCommandProcessed = LoggingEventId.AllocationDeliveryDomain + 86;

        public const int PullClosedCollectionCommandArrived = LoggingEventId.AllocationDeliveryDomain + 87;
        public const int PullClosedCollectionCommandProcessed = LoggingEventId.AllocationDeliveryDomain + 88;

        public const int PullClosedCollectionPageArrived = LoggingEventId.AllocationDeliveryDomain + 89;
        public const int PullClosedCollectionPageProcessed = LoggingEventId.AllocationDeliveryDomain + 90;

        public const int CheckForCollectionReturnCompleteCommandArrived = LoggingEventId.AllocationDeliveryDomain + 91;
        public const int CheckForCollectionReturnCompleteNotComplete = LoggingEventId.AllocationDeliveryDomain + 92;
        public const int CheckForCollectionReturnCompleteIsComplete = LoggingEventId.AllocationDeliveryDomain + 93;
        public const int CheckForCollectionReturnCompleteCommandProcessed = LoggingEventId.AllocationDeliveryDomain + 94;
        public const int ReportedActualsRoutingFspNotSupported = LoggingEventId.AllocationDeliveryDomain + 95;
        public const int AllocationActualVerificationCompletedWithNoValidActuals = LoggingEventId.AllocationDeliveryDomain + 96;
    }
}
