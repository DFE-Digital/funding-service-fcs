namespace SFA.FCT.ContractCreateDomain.BusinessLogic
{
    using CrossDomain.Integration.Common;

    public class ContractCreateDomainEventLoggingId
    {
        public const int NewContractRequestCommandReceived = LoggingEventId.ContractCreateStart;
        public const int CreateSagaTimeout = LoggingEventId.ContractCreateStart + 1;
        public const int ValidationSuccessful = LoggingEventId.ContractCreateStart + 2;
        public const int ValidationFailed = LoggingEventId.ContractCreateStart + 3;
        public const int AddContractNumbersResponseReceived = LoggingEventId.ContractCreateStart + 4;
        public const int ContractTransformed = LoggingEventId.ContractCreateStart + 5;
        public const int DocumentGenerationComplete = LoggingEventId.ContractCreateStart + 6;
        public const int ContractCreated = LoggingEventId.ContractCreateStart + 7;
        public const int NewAmendmentRequestCommandReceived = LoggingEventId.ContractCreateStart + 8;

        public const int OrganisationMessageEnricher = LoggingEventId.ContractCreateStart + 11;
        public const int OrganisationService = LoggingEventId.ContractCreateStart + 12;
        public const int OrgServiceTimeoutValueIsNotAnInteger = LoggingEventId.ContractCreateStart + 13;

        public const int AllocationDeliveryCommencedReceived = LoggingEventId.ContractCreateStart + 20;
        public const int AllocationDeliveryCommencedError = LoggingEventId.ContractCreateStart + 21;
        public const int AllocationDeliveryCommencedEnd = LoggingEventId.ContractCreateStart + 22;
        public const int UpdatingCrmWithMonitoringDeliverables = LoggingEventId.ContractCreateStart + 23;
        public const int AllocationDeliveryDuplicateDetected= LoggingEventId.ContractCreateStart + 24;
        public const int AllocationDeliveryErrorUpdatingMonitoringDeliverables = LoggingEventId.ContractCreateStart + 24;

        public const int AllocationActualsVerifiedStarted = LoggingEventId.ContractCreateStart + 30;
        public const int AllocationActualsVerifiedCompleted = LoggingEventId.ContractCreateStart + 31;

        public const int IncrementContractVersionHandlerStarted = LoggingEventId.ContractCreateStart + 32;
        public const int IncrementContractVersionDocGenCompleteArrived = LoggingEventId.ContractCreateStart + 33;
        public const int IncrementContractVersionHandlerComplete = LoggingEventId.ContractCreateStart + 34;
        public const int IncrementContractVersionDocGenCompleteProcessed = LoggingEventId.ContractCreateStart + 35;
        public const int IncrementContractVersionContractAmendedArrived = LoggingEventId.ContractCreateStart + 36;
        public const int IncrementContractVersionAmendContractUnsuccessfulArrived = LoggingEventId.ContractCreateStart + 37;
        public const int ContractHasAlreadyBeenAmended = LoggingEventId.ContractCreateStart + 38;

        public const int DraftContractUpdateRequestReceived = LoggingEventId.ContractCreateStart + 50;
        public const int FirstlevelValidationSuccessRecieved = LoggingEventId.ContractCreateStart + 51;
        public const int OrganisationEnrichementCompleteReceived = LoggingEventId.ContractCreateStart + 52;
        public const int GetContractCompleteReceived = LoggingEventId.ContractCreateStart + 53;
        public const int MashContractCompleteReceived = LoggingEventId.ContractCreateStart + 54;
        public const int AddContractNumbersCompleteReceived = LoggingEventId.ContractCreateStart + 55;
        public const int TransformContractCompleteReceived = LoggingEventId.ContractCreateStart + 56;
        public const int DeliverableEnrichmentCompleteReceived = LoggingEventId.ContractCreateStart + 57;
        public const int ContractValueAggregationCompleteReceived = LoggingEventId.ContractCreateStart + 58;
        public const int GetUpdateDraftContractValidationReferenceDataCompleteReceived = LoggingEventId.ContractCreateStart + 59;
        public const int SecondLevelValidationSuccessReceived = LoggingEventId.ContractCreateStart + 60;
        public const int DraftContractUpdatedReceived = LoggingEventId.ContractCreateStart + 61;
        public const int UpdateDraftContractUnsuccessfulReceived = LoggingEventId.ContractCreateStart + 62;
        public const int UpdateSagaTimeout = LoggingEventId.ContractCreateStart + 63;

        public const int DasRequestIgnored = LoggingEventId.ContractCreateStart + 64;
        public const int DasRequestReplyMissingEventId = LoggingEventId.ContractCreateStart + 65;
        public const int DasRequestNowInCrm = LoggingEventId.ContractCreateStart + 66;
        public const int DasRequestRejectedByRule = LoggingEventId.ContractCreateStart + 67;
        public const int DasRequestProviderNotFound = LoggingEventId.ContractCreateStart + 68;

        public const int AttemptingToCreateInCRM = LoggingEventId.ContractCreateStart + 70;
        public const int ContractCreatedInCRM = LoggingEventId.ContractCreateStart + 71;
        public const int ContractCreateException = LoggingEventId.ContractCreateStart + 72;
        public const int ValidationLookupDataPopulated = LoggingEventId.ContractCreateStart + 73;
        public const int UpdatingDraftContract = LoggingEventId.ContractCreateStart + 74;
        public const int UpdatedDraftContract = LoggingEventId.ContractCreateStart + 75;
        public const int UpdateFailed = LoggingEventId.ContractCreateStart + 76;
        public const int OrgServiceFaultThrown = LoggingEventId.ContractCreateStart + 77;
        public const int ExceptionThrownHandlingDraftUpdate = LoggingEventId.ContractCreateStart + 78;
        public const int ContractRetieveFailed = LoggingEventId.ContractCreateStart + 79;
        public const int RetievingContractFromCRM = LoggingEventId.ContractCreateStart + 80;
        public const int RetrievedContractFromCRM = LoggingEventId.ContractCreateStart + 81;
        public const int ValidationReferenceDataRetrieveFailed = LoggingEventId.ContractCreateStart + 82;
        public const int ContractNumbersAdded = LoggingEventId.ContractCreateStart + 83;

        public const int ContractAmendmentRequestCommandReceived = LoggingEventId.ContractCreateStart + 84;
        public const int ContractAmendmentSagaTimeout = LoggingEventId.ContractCreateStart + 85;
        public const int AmendingContract = LoggingEventId.ContractCreateStart + 86;
        public const int AmendedContract = LoggingEventId.ContractCreateStart + 87;
        public const int AmendmentFailed = LoggingEventId.ContractCreateStart + 88;
        public const int ExceptionThrownHandlingAmendment = LoggingEventId.ContractCreateStart + 89;
        public const int ContractAmendedReceived = LoggingEventId.ContractCreateStart + 90;
        public const int AmendContractUnsuccessfulReceived = LoggingEventId.ContractCreateStart + 91;

        public const int UpdateDraftContractAmendmentRequestCommandReceived = LoggingEventId.ContractCreateStart + 92;
        public const int UpdateDraftContractAmendmentSagaTimeout = LoggingEventId.ContractCreateStart + 93;

        public const int AllocationDeliveryEnhanceCommandReceived = LoggingEventId.ContractCreateStart + 94;
        public const int AllocationDeliveryEnhanceCommandInvalidMessage = LoggingEventId.ContractCreateStart + 95;

        public const int AttemptingToCreateANewAmendmentForAContract = LoggingEventId.ContractCreateStart + 96;
        public const int NewContractWithExistingNumberRequestCommandReceived = LoggingEventId.ContractCreateStart + 97;
        public const int ContractAllocationNumbersAdded = LoggingEventId.ContractCreateStart + 98;

        public const int FundingTypePeriodNotFound = LoggingEventId.ContractCreateStart + 99;

        public const int ModifyContractRequestCommandHandlerComplete = LoggingEventId.ContractCreateStart + 100;
        public const int ModifyContractRequestCommandHandlerAlreadyProcessedThisMessage = LoggingEventId.ContractCreateStart + 101;

        public const int CreateContractRequestCommandHandlerStarted = LoggingEventId.ContractCreateStart + 102;
        public const int CreateContractRequestCommandHandlerComplete = LoggingEventId.ContractCreateStart + 103;
        public const int CreateContractRequestCommandHandlerAlreadyProcessedThisMessage = LoggingEventId.ContractCreateStart + 104;

        public const int AllocationDeliveryEnhanceCommandEnd = LoggingEventId.ContractCreateStart + 105;
    }
}
