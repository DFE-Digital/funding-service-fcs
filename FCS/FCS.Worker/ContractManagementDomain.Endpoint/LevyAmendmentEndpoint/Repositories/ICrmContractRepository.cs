namespace ContractManagementDomain.Endpoint.LevyAmendmentEndpoint.Repositories
{
    using System.Collections.Generic;
    using SFA.FCT.ContractManagementDomain.Integration.Dtos;
    using SFA.FCT.CrossDomain.Integration.Entities;

    public interface ICrmContractRepository
    {
        ContractStatusInfo GetContractStatusIfContractIsLatest(string contractNumber, int version, int subVersion);
        IReadOnlyCollection<SimpleAllocationInfo> GetAllocationsForContract(string contractNumber, int version, int subVersion);
    }
}