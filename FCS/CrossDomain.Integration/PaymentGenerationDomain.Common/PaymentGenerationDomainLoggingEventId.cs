namespace PaymentGenerationDomain.Common
{
    using SFA.FCT.CrossDomain.Integration.Common;

    public class PaymentGenerationDomainLoggingEventId
    {
        public const int PaymentGenerationStart = LoggingEventId.PaymentGenerationDomain;
        public const int PaymentGenerationEnd = LoggingEventId.PaymentGenerationDomain + 1;
        public const int PaymentGenerationError = LoggingEventId.PaymentGenerationDomain + 2;
        public const int InitiatePaymentBatchStart = LoggingEventId.PaymentGenerationDomain + 3;
        public const int InitiatePaymentBatchEnd = LoggingEventId.PaymentGenerationDomain + 4;
        public const int InitiatePaymentRunStart = LoggingEventId.PaymentGenerationDomain + 5;
        public const int InitiatePaymentRunEnd = LoggingEventId.PaymentGenerationDomain + 6;
        public const int PaymentAggregatedHandleStarted = LoggingEventId.PaymentGenerationDomain + 7;
        public const int PaymentAggregatedHandleEnded = LoggingEventId.PaymentGenerationDomain + 8;
        public const int ProcessPaymentHandleStarted = LoggingEventId.PaymentGenerationDomain + 9;
        public const int ProcessPaymentHandleEnded = LoggingEventId.PaymentGenerationDomain + 10;
        public const int ProcessPaymentRunCompleted = LoggingEventId.PaymentGenerationDomain + 11;
        public const int UpdateTransmissionStatusStarted = LoggingEventId.PaymentGenerationDomain + 12;
        public const int UpdateTransmissionStatusCompleted = LoggingEventId.PaymentGenerationDomain + 13;
        public const int UpdateTransmissionStatusError = LoggingEventId.PaymentGenerationDomain + 14;
        public const int PaymentBatchStart = LoggingEventId.PaymentGenerationDomain + 15;
        public const int PaymentBatchEnd = LoggingEventId.PaymentGenerationDomain + 16;
        public const int InitiatePaymentBatchError = LoggingEventId.PaymentGenerationDomain + 17;
        public const int SendingProcessCorporatePaymentRunCommand = LoggingEventId.PaymentGenerationDomain + 18;
        public const int SendingProcessPaymentRunCompleteCommand = LoggingEventId.PaymentGenerationDomain + 19;
        public const int SendingProcessPaymentRunErrorCommand = LoggingEventId.PaymentGenerationDomain + 20;
        public const int TransformingPaymentsToCorporateSchema = LoggingEventId.PaymentGenerationDomain + 21;
        public const int DiagnosticInfo = LoggingEventId.PaymentGenerationDomain + 22;
        public const int DataAccessManagerDiagnosticInfo = LoggingEventId.PaymentGenerationDomain + 23;
        public const int PublishedPaymentToAtomFeed = LoggingEventId.PaymentGenerationDomain + 24;
    }
}
