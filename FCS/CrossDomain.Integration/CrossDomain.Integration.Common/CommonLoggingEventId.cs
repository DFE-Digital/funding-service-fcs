namespace SFA.FCT.CrossDomain.Integration.Common
{
    public class CommonLoggingEventId
    {
        public const int RunReportBatchStart = LoggingEventId.Common;

        public const int RunReportBatchEnd = LoggingEventId.Common + 1;

        public const int RenderReportStart = LoggingEventId.Common + 2;

        public const int UploadToO365Start = LoggingEventId.Common + 3;

        public const int UploadReportToO365End = LoggingEventId.Common + 4;

        public const int InitiateCdaReportBatchStart = LoggingEventId.Common + 5;

        public const int InitiateCdaReportBatchSuccess = LoggingEventId.Common + 6;

        public const int InitiateCdaReportBatchFailure = LoggingEventId.Common + 7;

        public const int RenderReportFailed = LoggingEventId.Common + 8;

        public const int ReportAsyncCallFailed = LoggingEventId.Common + 9;

        public const int InitiateAllocationDeliverySuccess = LoggingEventId.Common + 10;

        public const int AllocationDelivery = LoggingEventId.Common + 11;

        public const int AllocationDeliveryFailure = LoggingEventId.Common + 12;

        public const int FCSOperationsErrorCode = LoggingEventId.Common + 15;

        public const int FileNotFound = LoggingEventId.Common + 16;

        public const int RunReportsAndArchiveExistingBatchStart = LoggingEventId.Common + 17;

        public const int RunReportsAndArchiveExistingBatchEnd = LoggingEventId.Common + 18;

        public const int AboutToArchiveReport = LoggingEventId.Common + 19;

        public const int ArchiveReportComplete = LoggingEventId.Common + 20;

        public const int StartReceivedMonthEndCompletedEventForReporting = LoggingEventId.Common + 21;

        public const int FinishReceivedMonthEndCompletedEventForReporting = LoggingEventId.Common + 22;
    }
}
