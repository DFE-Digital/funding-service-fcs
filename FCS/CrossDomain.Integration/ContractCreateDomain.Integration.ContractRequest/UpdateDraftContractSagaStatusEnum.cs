namespace ContractCreateDomain.Integration.ContractRequest
{
    public enum UpdateDraftContractSagaStatusEnum
    {
        UpdateRequestReceived,
        FirstLevelValidationSuccess,
        OrganisationEnrichmentComplete,
        GetContractComplete,
        MashContractComplete,
        ContractNumberAdditionComplete,
        TransformContractComplete,
        DeliverableEnrichmentComplete,
        ContractValueAggregationComplete,
        GetUpdateDraftContractValidationReferenceDataComplete,
        SecondLevelValidationSuccess,
        DocumentGenerationComplete,
        DraftContractUpdated,
        UpdateDraftContractUnsuccessful
    }
}
