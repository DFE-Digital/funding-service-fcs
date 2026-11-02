namespace SFA.FCT.ContractCreateDomain.Implementation.Persistence
{
    using Entities;
    using ContractRequest = CrossDomain.Integration.Entities.ContractRequest;

    public interface IContractValidationLookupDataCreator
    {
        ContractValidationLookupData CreateLookupDataAndSetContractPresence(ContractRequest.contractRequestType contract);

        ContractValidationLookupData GetUpdateDraftContractData();
    }
}