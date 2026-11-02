namespace ContractManagementDomain.Endpoint.ContractApproved.Repositories
{
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Linq;
    using System.Threading.Tasks;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class ApprovedContractRepository : IApprovedContractRepository
    {
        public async Task Add(ApprovedContract approvedContract, ConnectionInfo connectionInfo)
        {
            using (ContractManagementDbContext context = new ContractManagementDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                context.ApprovedContracts.Add(approvedContract);
                await context.SaveChangesAsync()
                    .ConfigureAwait(false);
            }
        }

        public IReadOnlyCollection<int> GetLegalDeliverableCodesForFsp(string fspCode, ConnectionInfo connectionInfo)
        {
            using (ContractManagementDbContext context = new ContractManagementDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                return context.FundingStreamPeriodLegalDeliverables
                    .AsNoTracking()
                    .Where(d => d.FundingStreamPeriodCode == fspCode && d.AllowProfile)
                    .Select(d => d.DeliverableCode)
                    .ToList();
            }
        }
    }
}