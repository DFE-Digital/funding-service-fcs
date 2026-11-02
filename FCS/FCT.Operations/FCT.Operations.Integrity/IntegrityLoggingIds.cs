namespace SFA.FCT.Operations.Integrity
{
    using Common;

    public static class IntegrityLoggingIds
    {
        public const int StartInitiateCheckersCommand = LoggingEventId.Integrity + 1;
        public const int FinishInitiateCheckersCommand = LoggingEventId.Integrity + 2;
        public const int CheckerStarted = LoggingEventId.Integrity + 4;
        public const int CheckerFinished = LoggingEventId.Integrity + 5;
        public const int Error = LoggingEventId.Integrity + 6;
        public const int StartingSqlQuery = LoggingEventId.Integrity + 7;
        public const int FinishedSqlQuery = LoggingEventId.Integrity + 8;
        public const int StartReceivedMonthEndCompletedEvent = LoggingEventId.Integrity + 9;
        public const int FinishReceivedMonthEndCompletedEvent = LoggingEventId.Integrity + 10;
        public const int CheckForDuplicateContractsCommandReceived = LoggingEventId.Integrity + 11;
        public const int CheckForDuplicateContractsCommandProcessed = LoggingEventId.Integrity + 12;
        public const int GettingCrmDeliverablePaymentData = LoggingEventId.Integrity + 13;
        public const int GotCrmDeliverablePaymentData = LoggingEventId.Integrity + 14;
        public const int CrmDeliverablePaymentDataDictionaryCreated = LoggingEventId.Integrity + 15;
        public const int CrmDeliverablePaymentDataAboutToGetChanges = LoggingEventId.Integrity + 16;
        public const int CrmDeliverablePaymentDataGotChanges = LoggingEventId.Integrity + 17;
        public const int TrackingCurrentVersion = LoggingEventId.Integrity + 18;
        public const int OperationalCheckShortIntervalCommandReceived = LoggingEventId.Integrity + 19;
        public const int OperationalCheckShortIntervalCommandProcessed = LoggingEventId.Integrity + 20;
        public const int CheckForDuplicateContractsCommandSent = LoggingEventId.Integrity + 21;
        public const int CheckConnectivityCommandSent = LoggingEventId.Integrity + 22;
    }
}
