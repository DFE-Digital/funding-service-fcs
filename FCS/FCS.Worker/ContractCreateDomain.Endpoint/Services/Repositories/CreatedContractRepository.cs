namespace ContractCreateDomain.Endpoint.Services.Repositories
{
    using System.Threading.Tasks;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class CreatedContractRepository : ICreatedContractRepository
    {
        public async Task Add(CreatedContract createdContract, ConnectionInfo connectionInfo)
        {
            using (var context = new ContractManagementDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                context.CreatedContracts.Add(createdContract);

                await context.SaveChangesAsync()
                    .ConfigureAwait(false);
            }
        }
    }
}