namespace ContractCreateDomain.IncrementContractVersionEndpoint.Repositories
{
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Linq;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore;
    using System.Threading.Tasks;
    using Dapper;
    using Optional;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class ApprovedContractRepository : IApprovedContractRepository
    {
        public async Task<IReadOnlyCollection<ApprovedContract>> FindByMasterContractNumber(string masterContractNumber, ConnectionInfo connectionInfo)
        {
            using (ContractManagementDbContext context = new ContractManagementDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                var contractsWithThisMaster = await context.ApprovedContracts
                    .Include(ac => ac.ApprovedContractAllocations.Select(a => a.ApprovedContractDeliverables))
                    .Where(ac => ac.MasterContractNumber == masterContractNumber)
                    .AsNoTracking()
                    .ToListAsync()
                    .ConfigureAwait(false);

                return contractsWithThisMaster.GroupBy(c => c.ContractNumber)
                    .Select(grp => grp.OrderByDescending(c => c.ContractVersionNumber).First())
                    .ToList();
            }
        }

        public async Task<Option<string>> FindAllocationNumberByUkprnAndFspCodeForLatestApproval(int ukprn, string fspCode, ConnectionInfo connectionInfo)
        {       

            string allocationNumber = await connectionInfo.Connection.ExecuteScalarAsync<string>("sp_Worker_FindAllocationNumberByUkprnAndFspCode @ukprn,@fspcode", new { ukprn, fspCode }, transaction: connectionInfo.Transaction);

            return allocationNumber.SomeWhen(n => n != null);
        }
    }
}