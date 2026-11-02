namespace ContractManagementDomain.Endpoint.LevyAmendmentEndpoint.Repositories
{
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Linq;
    using System.Threading.Tasks;
    using ContractManagement.DataStore;
    using MoreLinq;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class RoatpProviderRepository : IRoatpProviderRepository
    {
        public async Task ReplaceRoatpCache(IEnumerable<string> providersOnRoatp, ConnectionInfo connectionInfo)
        {
            using (var context = new ContractManagementDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                const string deleteSqlCommand = "DELETE FROM [ContractManagement].[RoatpProvider]";

                await context.ExecuteSqlAsync(deleteSqlCommand).ConfigureAwait(continueOnCapturedContext: false);

                IEnumerable<IEnumerable<string>> batchedUkprns = providersOnRoatp.Batch(100);

                foreach (var batch in batchedUkprns)
                {
                    await InsertProviderBatch(batch, connectionInfo);
                }
            }
        }

        public async Task<bool> IsProviderOnRoatp(string ukprn, ConnectionInfo connectionInfo)
        {
            using (var context = new ContractManagementDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                return await context.RoatpProviders.AnyAsync(r => r.Ukprn == ukprn)
                    .ConfigureAwait(continueOnCapturedContext: false);
            }
        }

        private async Task<int> InsertProviderBatch(IEnumerable<string> ukprnBatch, ConnectionInfo connectionInfo)
        {
            using (var context = new ContractManagementDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                string formattedUkprnSqlValues = string.Join(",", ukprnBatch.Select(ukprn => $"('{ukprn}')"));

                string insertSqlCommand = $"INSERT INTO [ContractManagement].[RoatpProvider] ([Ukprn]) VALUES {formattedUkprnSqlValues}";

                return await context.ExecuteSqlAsync(insertSqlCommand).ConfigureAwait(continueOnCapturedContext: false);
            }
        }
    }
}