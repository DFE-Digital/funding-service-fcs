namespace ContractManagementDomain.Endpoint.DeleteContract.Repositories
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.Entity;
    using System.Data.SqlClient;
    using System.Linq;
    using System.Threading.Tasks;
    using ContractManagement.DataStore;
    using Dapper;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class CreatedContractRepository : ICreatedContractRepository
    {
        public async Task RemoveAllForContractVersion(string contractNumber, int contractVersionNumber, ConnectionInfo connectionInfo)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                using (var context = new ContractManagementDbContext(connection))
                {
                    foreach (var item in context.CreatedContracts.Where(cc => cc.ContractNumber == contractNumber && cc.ContractVersionNumber == contractVersionNumber))
                    {
                        context.CreatedContracts.Remove(item);
                        
                    }
                    await context.SaveChangesAsync();

                }               
            }
        }

        public async Task<IReadOnlyCollection<ContractIdentifier>> GetAllContractsForVersion(string contractNumber, int contractVersionNumber, ConnectionInfo connectionInfo)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                using (var context = new ContractManagementDbContext(connection))
                {
                    var subVersions = await (from res in context.CreatedContracts
                                             where res.ContractNumber == contractNumber
                                             && res.ContractVersionNumber == contractVersionNumber
                                             select res.ContractSubVersionNumber).ToListAsync();

                    return subVersions.Select(subVersionNumber =>
                   new ContractIdentifier(contractNumber, contractVersionNumber, subVersionNumber))
                   .ToList();

                }               
            }
        }
    }
}