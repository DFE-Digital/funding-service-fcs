namespace ContractCreateDomain.Endpoint.Services
{
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    public interface ICheckForContractChangeService
    {
        void UpdateAllocationsThatHaveBeenAddedOrChangedService(contractType mergedContract);

        void UpdateCorpContractAllocations(
            SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.contractType corpContract,
            contractType contractRequest);
    }
}