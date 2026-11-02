namespace FCT.Operations.Cda
{
    public static class LoggingIds
    {
        private const int CdaLoggingId = 1900;

        public static int StartingCreateReportFromCrmForGroupHandler = CdaLoggingId + 1;
        public static int FinishedCreateReportFromCrmForGroupHandler = CdaLoggingId + 2;
        public static int CreateReportFromCrmForGroupHandlerFailed = CdaLoggingId + 3;
        public static int CreateReportFromCrmForGroupHandlerGotRows = CdaLoggingId + 4;

        public static int StartingUploadReportToSharePoint = CdaLoggingId + 5;
        public static int FinishedUploadReportToSharePoint = CdaLoggingId + 6;

        public static int StartingRunReportsCommandHandler = CdaLoggingId + 7;
        public static int FinishedRunReportsCommandHandler = CdaLoggingId + 8;
        public static int StartingToArchive = CdaLoggingId + 9;
        public static int FinishedArchive = CdaLoggingId + 10;
        public static int StartingRunReportsAndArchiveCommandHandler = CdaLoggingId + 11;
        public static int FinishedRunReportsAndArchiveCommandHandler = CdaLoggingId + 12;
        public static int StartingUploadClosedReportToSharePoint = CdaLoggingId + 13;
        public static int FinishedUploadClosedReportToSharePoint = CdaLoggingId + 14;
    }
}
