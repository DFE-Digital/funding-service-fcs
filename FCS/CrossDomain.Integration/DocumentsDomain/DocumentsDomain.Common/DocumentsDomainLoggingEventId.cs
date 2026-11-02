namespace SFA.FCT.DocumentsDomain.Common
{
    using CrossDomain.Integration.Common;

    public class DocumentsDomainLoggingEventId
    {
        public const int DocumentGenerationStart = LoggingEventId.DocumentsDomainStart;

        public const int DocumentGenerationEnd = LoggingEventId.DocumentsDomainStart + 1;

        public const int SendingToDocumentSaver = LoggingEventId.DocumentsDomainStart + 2;

        public const int AddingSagaHeader = LoggingEventId.DocumentsDomainStart + 3;

        public const int DocumentSaverStart = LoggingEventId.DocumentsDomainStart + 4;

        public const int DocumentSaverEnd = LoggingEventId.DocumentsDomainStart + 5;

        public const int DocumentSaverReplied = LoggingEventId.DocumentsDomainStart + 6;

        public const int DocumentDeleterStart = LoggingEventId.DocumentsDomainStart + 7;

        public const int DocumentDeleterEnd = LoggingEventId.DocumentsDomainStart + 8;

        public const int DocumentDeleterDeleting = LoggingEventId.DocumentsDomainStart + 9;

        public const int DocumentGeneratorProducing = LoggingEventId.DocumentsDomainStart + 10;

        public const int DocumentGeneratorPartsCount = LoggingEventId.DocumentsDomainStart + 11;

        public const int DocumentGeneratorUsingTemplate = LoggingEventId.DocumentsDomainStart + 12;

        public const int DocumentGenreatorTargetDecided = LoggingEventId.DocumentsDomainStart + 13;

        public const int DocumentPartAppendixOne = LoggingEventId.DocumentsDomainStart + 14;

        public const int DocumentSaverSaving = LoggingEventId.DocumentsDomainStart + 15;

        public const int DocumentSaverRenaming = LoggingEventId.DocumentsDomainStart + 16;

        public const int DocumentSaverUploading = LoggingEventId.DocumentsDomainStart + 17;

        public const int DocumentSaverReplyingToOther = LoggingEventId.DocumentsDomainStart + 18;

        public const int DocumentMergeStart = LoggingEventId.DocumentsDomainStart + 19;

        public const int DocumentMergeEnd = LoggingEventId.DocumentsDomainStart + 20;

        public const int ContractDocumentMergerMerging = LoggingEventId.DocumentsDomainStart + 21;

        public const int ContractDocumentMergeComplete = LoggingEventId.DocumentsDomainStart + 22;

        public const int ContractDocumentMergeFailedContractNull = LoggingEventId.DocumentsDomainStart + 23;

        public const int ContractDocumentMergeError = LoggingEventId.DocumentsDomainStart + 24;

        public const int ContractDocumentMergeUpdateCrmStatus = LoggingEventId.DocumentsDomainStart + 25;

        public const int GetDocumentsForDeleteHandlerMsgReceived = LoggingEventId.DocumentsDomainStart + 26;

        public const int GetDocumentsForDeleteHandlerGettingDocs = LoggingEventId.DocumentsDomainStart + 27;

        public const int GetDocumentsForDeleteHandlerSendingDeleteCmd = LoggingEventId.DocumentsDomainStart + 28;

        public const int GetDocumentsForDeleteHandlerNoDocsFound = LoggingEventId.DocumentsDomainStart + 29;

        public const int UpdateDocumentMergeStatusHandlerMsgReceived = LoggingEventId.DocumentsDomainStart + 30;

        public const int UpdateDocumentMergeStatusHandlerReplying = LoggingEventId.DocumentsDomainStart + 31;

        public const int UpdateDocumentMergeStatusHandlerUpdateSuccessful = LoggingEventId.DocumentsDomainStart + 32;

        public const int UpdateDocumentMergeStatusHandlerUpdateFailed = LoggingEventId.DocumentsDomainStart + 33;

        public const int DocumentMergeMessageTypeGoingIntoErrorQueue = LoggingEventId.DocumentsDomainStart + 34;

        public const int DocMoveStart = LoggingEventId.DocumentsDomainStart + 35;

        public const int DocMoveEnd = LoggingEventId.DocumentsDomainStart + 36;

        public const int DocMoveBadContract = LoggingEventId.DocumentsDomainStart + 37;

        public const int DocMovePublishingRtPEvent = LoggingEventId.DocumentsDomainStart + 38;

        public const int DocMoveUpdatedCorpContract = LoggingEventId.DocumentsDomainStart + 39;

        public const int DocumentUpdateStatusToPublishToProviderStart = LoggingEventId.DocumentsDomainStart + 40;

        public const int DocumentUpdateStatusToPublishToProviderEnd = LoggingEventId.DocumentsDomainStart + 41;

        public const int DocumentPublishToProviderFailureStart = LoggingEventId.DocumentsDomainStart + 42;

        public const int DocumentPublishToProviderFailureEnd = LoggingEventId.DocumentsDomainStart + 43;

        public const int DocumentMoverStart = LoggingEventId.DocumentsDomainStart + 44;

        public const int DocumentMoverEnd = LoggingEventId.DocumentsDomainStart + 45;

        public const int DocumentMoverMovingDocument = LoggingEventId.DocumentsDomainStart + 46;

        public const int DocMoveMoveError = LoggingEventId.DocumentsDomainStart + 47;

        public static int DocPublishToProviderFailureError = LoggingEventId.DocumentsDomainStart + 48;

        public static int DocumentMoverFileNotFound = LoggingEventId.DocumentsDomainStart + 49;

        public const int DocumentGenerationError = LoggingEventId.DocumentsDomainStart + 50;

        public const int DocumentMoverCheckIfContractDocumentAlreadyPublishedStart = LoggingEventId.DocumentsDomainStart + 51;
        public const int DocumentMoverCheckIfContractDocumentAlreadyPublishedEnd = LoggingEventId.DocumentsDomainStart + 52;
        public const int DocumentMoverContractDocumentAlreadyPublished = LoggingEventId.DocumentsDomainStart + 53;

        public const int DocumentSaverUploaded = LoggingEventId.DocumentsDomainStart + 54;
        public const int ContractApprovedHandlerStarted = LoggingEventId.DocumentsDomainStart + 55;
        public const int ContractApprovedHandlerEnded = LoggingEventId.DocumentsDomainStart + 56;

        public const int ContractWithdrawnHandlerStarted = LoggingEventId.DocumentsDomainStart + 57;
        public const int ContractWithdrawnHandlerEnded = LoggingEventId.DocumentsDomainStart + 58;

        public const int RecordArchiveHandlerStarted = LoggingEventId.DocumentsDomainStart + 59;
        public const int RecordArchiveHandlerEnded = LoggingEventId.DocumentsDomainStart + 60;
        public const int DocumentSaverAlreadyProcessed = LoggingEventId.DocumentsDomainStart + 61;
        public const int DocumentGenerationAlreadyProcessed = LoggingEventId.DocumentsDomainStart + 62;
    }
}
