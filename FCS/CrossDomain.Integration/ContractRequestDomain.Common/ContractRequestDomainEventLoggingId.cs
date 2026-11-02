namespace SFA.FCT.ContractRequestDomain.Common
{
    using System.ComponentModel;
    using CrossDomain.Integration.Common;

    public class ContractRequestDomainEventLoggingId
    {
        public const int PublishingBulkImportFile = LoggingEventId.FileWatcherStart;
        public const int CreatedSyntaxReport =      LoggingEventId.FileWatcherStart + 1;
        public const int GeneratingResultsFile = LoggingEventId.FileWatcherStart + 2;
        public const int GeneratedResultsFile = LoggingEventId.FileWatcherStart + 3;
        public const int LookingForFiles = LoggingEventId.FileWatcherStart + 4;
        public const int FoundFile = LoggingEventId.FileWatcherStart + 5;
        public const int BulkUploadFileLocked = LoggingEventId.FileWatcherStart + 6;
        public const int StartingFilewatcherSaga = LoggingEventId.FileWatcherStart + 7;
        public const int FilewatcherSagaAlreadyStarted = LoggingEventId.FileWatcherStart + 8;
        public const int FileWatcherFailed = LoggingEventId.FileWatcherStart + 10;

        public const int ContractRequestProcessedCommandReceived = LoggingEventId.BulkImportStart;
        public const int SagaComplete = LoggingEventId.BulkImportStart + 1;
        public const int BulkUploadFileProcessedEventPublished = LoggingEventId.BulkImportStart + 2;
        public const int ContractHasErrors = LoggingEventId.BulkImportStart + 3;
        public const int DraftContractUpdatePublished = LoggingEventId.BulkImportStart + 4;
        public const int NewContractRequestPublished = LoggingEventId.BulkImportStart + 5;
        public const int PublishSyntaxValidationSuccess = LoggingEventId.BulkImportStart + 6;
        public const int SettingUpSaga = LoggingEventId.BulkImportStart + 7;
        public const int PublishSyntaxValidationFailure = LoggingEventId.BulkImportStart + 8;
        public const int NewExcelUploadFileEventReceived = LoggingEventId.BulkImportStart + 9;
        public const int HandlingFileWatcherResultsFileWritten = LoggingEventId.BulkImportStart + 10;
        public const int StartingBulkImportProcessing = LoggingEventId.BulkImportStart + 11;
        public const int EnrichTransformAndPublishProcessing = LoggingEventId.BulkImportStart + 12;
        public const int ContractAmendmentRequestPublished = LoggingEventId.BulkImportStart + 13;
        public const int ContractAmendmentProcessedReceived = LoggingEventId.BulkImportStart + 14;
        public const int UpdateDraftContractAmendmentRequestPublished = LoggingEventId.BulkImportStart + 15;
        public const int EndingBulkImportProcessing = LoggingEventId.BulkImportStart + 16;
        public const int ErrorFetchingFscData = LoggingEventId.BulkImportStart + 17;
        public const int FetchingFscDataForBatch = LoggingEventId.BulkImportStart + 18;
        public const int FscQueryForBatch = LoggingEventId.BulkImportStart + 19;
        public const int NewAmendmentRequestSent = LoggingEventId.BulkImportStart + 20;
        public const int RevisedNewContractRequestSent = LoggingEventId.BulkImportStart + 21;
        public const int NewExcelUploadFileEventProcessed = LoggingEventId.BulkImportStart + 22;
        public const int NewExcelUploadFileEventFileRejected = LoggingEventId.BulkImportStart + 23;
        public const int NewExcelUploadFileEventMovedFileFromInputToProcessed = LoggingEventId.BulkImportStart + 24;
        public const int ContractRequestProcessedCommandProcessed = LoggingEventId.BulkImportStart + 25;
        public const int ContractRequestProcessedCommandDuplicate = LoggingEventId.BulkImportStart + 26;
        public const int SagaTimeout = LoggingEventId.BulkImportStart + 27;

        public const int NewDasContractRequestCommandReceived = LoggingEventId.ContractRequestDomain + 1;
        public const int NewDasContractRequestCommandProcessed = LoggingEventId.ContractRequestDomain + 2;
        public const int InitiateEngagementPollingCommandReceived = LoggingEventId.ContractRequestDomain + 3;
        public const int InitiateEngagementPollingCommandProcessed = LoggingEventId.ContractRequestDomain + 4;
        public const int InitiateEngagementPollingError = LoggingEventId.ContractRequestDomain + 5;

        public const int DasRequestTransformerValidationFailure = LoggingEventId.ContractRequestDomain + 6;
        public const int DasContractRequestProcessedEventRecieved = LoggingEventId.ContractRequestDomain + 7;
        public const int DasContractRequestProcessedEventProcessed = LoggingEventId.ContractRequestDomain + 8;

        public const int RetryNotFoundProviderEngagementsCommandRecieved = LoggingEventId.ContractRequestDomain + 9;
        public const int RetryNotFoundProviderEngagementsCommandProcessed = LoggingEventId.ContractRequestDomain + 10;

        public const int RemoveManuallyLoadedEngagementEventCommanddRecieved = LoggingEventId.ContractRequestDomain + 11;
        public const int RemoveManuallyLoadedEngagementEventCommandProcessed = LoggingEventId.ContractRequestDomain + 12;

        public const int RetryNotFoundProviderEngagementsCommandDasRequests = LoggingEventId.ContractRequestDomain + 13;
        public const int FundingAllocationReleaseInProgressEventReceived = LoggingEventId.ContractRequestDomain + 14;
        public const int FundingAllocationReleaseInProgressEventProcessed = LoggingEventId.ContractRequestDomain + 15;
        public const int FundingAllocationReleasedEventReceived = LoggingEventId.ContractRequestDomain + 16;
        public const int FundingAllocationReleasedEventProcessed = LoggingEventId.ContractRequestDomain + 17;
        public const int DasCheckConnectivityCommandReceived = LoggingEventId.ContractRequestDomain + 18;
        public const int DasCheckConnectivityCommandProcessed = LoggingEventId.ContractRequestDomain + 19;
    }
}
