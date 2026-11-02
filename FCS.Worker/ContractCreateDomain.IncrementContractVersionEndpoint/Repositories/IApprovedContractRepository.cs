namespace ContractCreateDomain.IncrementContractVersionEndpoint.Repositories
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using ContractManagement.DataStore.Model;
    using Optional;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IApprovedContractRepository
    {
        Task<IReadOnlyCollection<ApprovedContract>> FindByMasterContractNumber(string masterContractNumber, ConnectionInfo connectionInfo);

        Task<Option<string>> FindAllocationNumberByUkprnAndFspCodeForLatestApproval(int ukprn, string fspCode,
            ConnectionInfo connectionInfo);
    }
}