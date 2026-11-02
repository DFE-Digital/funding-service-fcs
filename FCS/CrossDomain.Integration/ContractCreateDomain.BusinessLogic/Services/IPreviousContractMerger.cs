namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Services
{
    using CrossDomain.Integration.Entities.ContractRequest;

    public interface IPreviousContractMerger
    {
        PreviousContractMergeResult MergeOptionalFieldsFromPreviousContract(contractRequestType contractRequest);
    }
}