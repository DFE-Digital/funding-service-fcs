namespace ContractManagementDomain.Endpoint.DeleteContract.Repositories
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface ICreatedContractRepository
    {
        Task RemoveAllForContractVersion(string contractNumber, int contractVersionNumber, ConnectionInfo connectionInfo);

        Task<IReadOnlyCollection<ContractIdentifier>> GetAllContractsForVersion(string contractNumber, int contractVersionNumber, ConnectionInfo connectionInfo);
    }
}
