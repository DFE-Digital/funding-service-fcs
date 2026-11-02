namespace SFA.FCT.Operations.Common
{
    public class LoggingEventId
    {
        public const int Integrity = 100;

        public const int MessageReplay = 400;
        public const int MessageReplayFailure = MessageReplay + 1;

        public const int Maintenance = 500;
        public const int MaintainAuditQueueStart = Maintenance + 1;
        public const int MaintainAuditQueueFinish = Maintenance + 2;
        public const int MaintainAuditQueueDesiredSizeExceeded = Maintenance + 3;
        public const int DeleteCrmReplicationFailuresStart = Maintenance + 4;
        public const int DeleteCrmReplicationFailuresFinish = Maintenance + 5;
        public const int DeletingCrmReplicationFailure = Maintenance + 6;
        public const int HousekeepProcessedMessageTablesStart = Maintenance + 7;
        public const int HousekeepProcessedMessageTablesFinish = Maintenance + 8;
        public const int HousekeepProcessedMessageTableAction = Maintenance + 9;
        public const int HousekeepAuditMessageTableStart = Maintenance + 10;
        public const int HousekeepAuditMessageTableFinish = Maintenance + 11;

        public const int PaymentSummaryReport = 550;
        public const int BeginCreatePaymentSummaryReport = PaymentSummaryReport + 1;
        public const int EndCreatePaymentSummaryReport = PaymentSummaryReport + 2;
        public const int GeneratingPaymentSummaryReport = PaymentSummaryReport + 3;
        public const int GeneratedPaymentSummaryReport = PaymentSummaryReport + 4;
        public const int BeginUploadPaymentSummaryReportToSharePoint = PaymentSummaryReport + 5;
        public const int EndUploadPaymentSummaryReportToSharePoint = PaymentSummaryReport + 6;

        public const int Reports = 570;
        public const int CreateFundingAllocationExtractReceived = Reports + 1;
        public const int CreateFundingAllocationExtractProcessed = Reports + 2;
        public const int CreateFundingConfirmationReportForPeriodReceived = Reports + 3;
        public const int CreateFundingConfirmationReportForPeriodProcessed = Reports + 4;
        public const int CreateFundingConfirmationReportReceived = Reports + 5;
        public const int CreateFundingConfirmationReportProcessed = Reports + 6;

        public const int Connectivity = 590;
        public const int CheckConnectivityReplyReceived = Connectivity + 1;
        public const int CheckConnectivityReplyProcessed = Connectivity + 2;
    }
}
