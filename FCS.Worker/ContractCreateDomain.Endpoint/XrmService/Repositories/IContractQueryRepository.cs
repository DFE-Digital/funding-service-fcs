namespace ContractCreateDomain.Endpoint.XrmService.Repositories
{
    using System;
    using System.Collections.Generic;
    using DTOs;
    using Optional;

    public interface IContractQueryRepository
    {
        Option<CrmContractInfo> GetContractInfo(string contractNumber, int versionNumber, int subVersionNumber);

        IReadOnlyCollection<Guid> GetAllocationIds(
            string contractNumber,
            int versionNumber,
            int subVersionNumber,
            string allocationNumber);
    }
}