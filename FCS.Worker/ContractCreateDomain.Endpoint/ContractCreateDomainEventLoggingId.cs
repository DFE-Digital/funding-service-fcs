namespace ContractCreateDomain.Endpoint
{
    public static class ContractCreateDomainEventLoggingId
    {
        private const int ContractCreateStart = 300;
        private const int Common = 1200;

        public const int NewContractRequestCommandReceived = ContractCreateStart;        
        public const int ValidationSuccessful = ContractCreateStart + 2;
        public const int ValidationFailed = ContractCreateStart + 3;
        public const int ContractTransformed = ContractCreateStart + 5;
        public const int DocumentGenerationComplete = ContractCreateStart + 6;
        public const int ContractCreated = ContractCreateStart + 7;
        public const int NewAmendmentRequestCommandReceived = ContractCreateStart + 8;
        public const int RevisedNewContractRequestCommandReceived = ContractCreateStart + 11;
        // do not use ContractCreateStart + 12, clashes with Org Domain logging

        public const int AllocationDeliveryCommencedReceived = ContractCreateStart + 20;
        public const int AllocationDeliveryCommencedError = ContractCreateStart + 21;
        public const int AllocationDeliveryCommencedEnd = ContractCreateStart + 22;        
        public const int AllocationDeliveryDuplicateDetected = ContractCreateStart + 24;

        public const int DasRequestIgnored = ContractCreateStart + 64;
        public const int DasRequestReplyMissingEventId = ContractCreateStart + 65;
        public const int DasRequestNowInCrm = ContractCreateStart + 66;
        public const int DasRequestRejectedByRule = ContractCreateStart + 67;
        public const int DasRequestProviderNotFound = ContractCreateStart + 68;

        public const int AttemptingToCreateInCRM = ContractCreateStart + 70;
        public const int ContractCreatedInCRM = ContractCreateStart + 71;
        public const int ContractCreateException = ContractCreateStart + 72;
        public const int UpdatingContractInCrm = ContractCreateStart + 73;
        public const int UpdatedContractInCrm = ContractCreateStart + 74;
        public const int UpdateDuplicate = ContractCreateStart + 75;
        public const int ContractAlreadyCreatedInCRM = ContractCreateStart + 76;
        public const int RetrievingContractFromCRM = ContractCreateStart + 80;
        public const int RetrievedContractFromCRM = ContractCreateStart + 80;
        public const int ContractNumbersAdded = ContractCreateStart + 83;
        public const int ContractAmendmentRequestCommandReceived = ContractCreateStart + 84;
        public const int ContractAmendmentSagaTimeout = ContractCreateStart + 85;
        public const int AmendingContract = ContractCreateStart + 86;
        public const int AmendedContract = ContractCreateStart + 87;
        public const int AmendmentFailed = ContractCreateStart + 88;
        public const int AmendmentDuplicate = ContractCreateStart + 89;
        public const int ContractAmendedReceived = ContractCreateStart + 90;
        public const int AmendContractUnsuccessfulReceived = ContractCreateStart + 91;
        public const int NewAmendmentDuplicate = ContractCreateStart + 92;
        public const int AllocationDeliveryEnhanceCommandReceived = ContractCreateStart + 94;
        public const int AllocationDeliveryEnhanceCommandInvalidMessage = ContractCreateStart + 95;
        public const int AttemptingToCreateANewAmendmentForAContract = ContractCreateStart + 96;
        public const int NewContractWithExistingNumberRequestCommandReceived = ContractCreateStart + 97;
        public const int ContractAllocationNumbersAdded = ContractCreateStart + 98;
        public const int ModifyContractRequestCommandHandlerComplete = ContractCreateStart + 100;
        public const int ModifyContractRequestCommandHandlerAlreadyProcessedThisMessage = ContractCreateStart + 101;
        public const int AllocationDeliveryEnhanceCommandEnd = ContractCreateStart + 105;
        public const int EnrichContractForDocumentationCommandReceived = ContractCreateStart + 106;
        public const int EnrichContractForDocumentationCommandProcessed = ContractCreateStart + 107;
        public const int ContractEnrichmentServiceLegalNameAdded = ContractCreateStart + 108;
        public const int ContractCreatedInCrmEventReceived = ContractCreateStart + 109;
        public const int ContractCreatedInCrmEventProcessed = ContractCreateStart + 110;
        public const int UpdateDraftContractFromFundingCommandReceived = ContractCreateStart + 111;
        public const int UpdateDraftContractFromFundingCommandProcessed = ContractCreateStart + 112;
        public const int CreateProvidersIfNecessaryCommandReceived = ContractCreateStart + 113;
        public const int CreateProvidersIfNecessaryCommandProcessed = ContractCreateStart + 114;

        public const int FCSOperationsErrorCode = Common + 15;
    }
}
