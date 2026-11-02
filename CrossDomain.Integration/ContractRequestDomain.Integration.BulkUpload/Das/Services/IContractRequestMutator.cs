namespace SFA.FCT.ContractRequestDomain.Integration.BulkUpload.Das.Services
{
    using CrossDomain.Integration.Entities.ContractRequest;

    public interface IContractRequestMutator
    {
        void AddNonLevyAllocationToContractRequest(contractRequestType contractRequestType);
    }
}