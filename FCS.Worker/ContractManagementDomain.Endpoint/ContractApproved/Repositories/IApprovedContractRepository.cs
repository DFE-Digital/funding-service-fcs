namespace ContractManagementDomain.Endpoint.ContractApproved.Repositories
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using ContractManagement.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IApprovedContractRepository
    {
        Task Add(ApprovedContract approvedContract, ConnectionInfo connectionInfo);
        IReadOnlyCollection<int> GetLegalDeliverableCodesForFsp(string fspCode, ConnectionInfo connectionInfo);
    }
}
