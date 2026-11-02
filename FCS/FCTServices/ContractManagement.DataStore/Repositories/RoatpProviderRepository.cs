namespace ContractManagement.DataStore.Repositories
{
    using System.Collections.Generic;
    using System.Linq;
    using MoreLinq;

    public class RoatpProviderRepository : IRoatpProviderRepository
    {
        private readonly IContractManagementDbContext _contractManagementDbContext;
        
        public RoatpProviderRepository(IContractManagementDbContext contractManagementDbContext)
        {
            _contractManagementDbContext = contractManagementDbContext;
        }

        public void ReplaceRoatpCache(IEnumerable<string> ukprns)
        {
            const string deleteSqlCommand = "DELETE FROM [ContractManagement].[RoatpProvider]";

            _contractManagementDbContext.ExecuteSql(deleteSqlCommand);

            IEnumerable<IEnumerable<string>> batchedUkprns = ukprns.Batch(100);

            batchedUkprns.ForEach(InsertProviderBatch);
        }

        public bool IsProviderOnRoatp(string ukprn)
        {
            return _contractManagementDbContext.RoatpProviders.Find(ukprn) != null;
        }

        private void InsertProviderBatch(IEnumerable<string> ukprnBatch)
        {
            string formattedUkprnSqlValues = string.Join(",", ukprnBatch.Select(ukprn => $"('{ukprn}')"));

            string insertSqlCommand = $"INSERT INTO [ContractManagement].[RoatpProvider] ([Ukprn]) VALUES {formattedUkprnSqlValues}";

            _contractManagementDbContext.ExecuteSql(insertSqlCommand);
        }
    }
}