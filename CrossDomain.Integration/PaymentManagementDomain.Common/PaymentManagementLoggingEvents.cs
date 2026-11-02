namespace SFA.FCT.PaymentManagementDomain.Common
{
    using CrossDomain.Integration.Common;

    public class PaymentManagementLoggingEvents
    {
        public const int PaymentManagementStart = LoggingEventId.PaymentManagementDomain;
        public const int PaymentManagementEnd = LoggingEventId.PaymentManagementDomain + 1;
        public const int PaymentMangementBadMessage = LoggingEventId.PaymentManagementDomain + 2;
        public const int PaymentScheduleHandlerStart = LoggingEventId.PaymentManagementDomain + 3;
        public const int PaymentScheduleWriteAllocationToCrmStart = LoggingEventId.PaymentManagementDomain + 4;
        public const int PaymentScheduleWriteAllocationToCrmEnd = LoggingEventId.PaymentManagementDomain + 5;
        public const int PaymentScheduleHandlerEnd = LoggingEventId.PaymentManagementDomain + 6;
        public const int PaymentsAggregationHandlerStart = LoggingEventId.PaymentManagementDomain + 7;
        public const int PaymentsAggregationHandlerEnd = LoggingEventId.PaymentManagementDomain + 8;
        public const int PaymentsAggregationNoSubnominalCodeFound = LoggingEventId.PaymentManagementDomain + 9;
        public const int PaymentsAggregationSubnominalCodeFound = LoggingEventId.PaymentManagementDomain + 10;
        public const int PaymentScheduleWriteTODB = LoggingEventId.PaymentManagementDomain + 11;
        public const int PaymentScheduleWritenTODB = LoggingEventId.PaymentManagementDomain + 12;
        public const int PaymentMangementProcessAllocation = LoggingEventId.PaymentManagementDomain + 13;
        public const int PaymentAggregationXrmServiceStart = LoggingEventId.PaymentManagementDomain + 14;
        public const int PaymentAggregationXrmServiceEnd = LoggingEventId.PaymentManagementDomain + 15;
        public const int PaymentsAggregationPaymentAggregationCalculated = LoggingEventId.PaymentManagementDomain + 16;
        public const int PaymentAggregationXrmServiceNoMessageToProcess = LoggingEventId.PaymentManagementDomain + 17;
        public const int PaymentAggregationXrmServiceProcessingAllocation = LoggingEventId.PaymentManagementDomain + 18;
        public const int PaymentAggregationXrmServiceSavingAllocation = LoggingEventId.PaymentManagementDomain + 19;
        public const int PaymentAggregationXrmServiceAssociatingToDeliverablePeriod = LoggingEventId.PaymentManagementDomain + 20;
        public const int PaymentAggregationXrmServiceAssociatingToContractAllocation = LoggingEventId.PaymentManagementDomain + 21;
        public const int PaymentScheduleWritenEFValidationError = LoggingEventId.PaymentManagementDomain + 22;
        public const int PaymentManagementRejectMessage = LoggingEventId.PaymentManagementDomain + 23;
        public const int PaymentScheduleHandlerError = LoggingEventId.PaymentManagementDomain + 24;
        public const int RulebaseVersion = LoggingEventId.PaymentManagementDomain + 25;
        public const int AllocationActualsVerifiedStart = LoggingEventId.PaymentManagementDomain + 26;
        public const int AllocationActualsVerifiedEnd = LoggingEventId.PaymentManagementDomain + 27;
        public const int PaymentScheduleDuplicateAllocation = LoggingEventId.PaymentManagementDomain + 28;
        public const int PaymentsAggregationNoDeliverablePolicyFound = LoggingEventId.PaymentManagementDomain + 29;
        public const int PaymentScheduleDeliverableNotLegal = LoggingEventId.PaymentManagementDomain + 30;
        public const int PaymentAggregationNonPayableAllocation = LoggingEventId.PaymentManagementDomain + 31;
        public const int OpaInformation = LoggingEventId.PaymentManagementDomain + 32;
        public const int PaymentScheduleCreateAllocationDeliverablePeriodsInCrmStart = LoggingEventId.PaymentManagementDomain + 33;
        public const int PaymentScheduleCreateAllocationDeliverablePeriodsInCrmEnd = LoggingEventId.PaymentManagementDomain + 34;
        public const int PaymentScheduleCreateDeliverablePeriodsForDeliverableInCrmStart = LoggingEventId.PaymentManagementDomain + 35;
        public const int PaymentScheduleCreateDeliverablePeriodsForDeliverableInCrmEnd = LoggingEventId.PaymentManagementDomain + 36;
        public const int FcrPublishedStart = LoggingEventId.PaymentManagementDomain + 37;
        public const int FcrPublishedEnd = LoggingEventId.PaymentManagementDomain + 38;
        public const int AllocationPaymentInstructionReceivedStart = LoggingEventId.PaymentManagementDomain + 39;
        public const int AllocationPaymentInstructionReceivedEnd = LoggingEventId.PaymentManagementDomain + 40;
        public const int PaymentScheduleXrmHandlerEnd = LoggingEventId.PaymentManagementDomain + 41;
        public const int PaymentAggregationXrmMessageDeferred = LoggingEventId.PaymentManagementDomain + 42;
        public const int OpaCalculationBeginning = LoggingEventId.PaymentManagementDomain + 43;
        public const int OpaCalculationEnded = LoggingEventId.PaymentManagementDomain + 44;
        public const int AllocationActualsVerifiedStarted = LoggingEventId.PaymentManagementDomain + 45;
        public const int AllocationActualsVerifiedCompleted = LoggingEventId.PaymentManagementDomain + 46;
        public const int AggregateDeliverablesStarted = LoggingEventId.PaymentManagementDomain + 47;
        public const int AggregateDeliverablesCompleted = LoggingEventId.PaymentManagementDomain + 48;
        public const int AddMissingDeliverablePeriodStarted = LoggingEventId.PaymentManagementDomain + 49;
        public const int AddMissingDeliverablePeriodCompleted = LoggingEventId.PaymentManagementDomain + 50;
        public const int PaymentAggregationXrmServiceAlreadyLocked = LoggingEventId.PaymentManagementDomain + 51;
        public const int CalculatingDueToApprovalWithNewCalcCode = LoggingEventId.PaymentManagementDomain + 52;
        public const int CalculatingDueToActualsWithNewCalcCode = LoggingEventId.PaymentManagementDomain + 53;
        public const int CalculatingWithBehaviour = LoggingEventId.PaymentManagementDomain + 54;
    }
}
