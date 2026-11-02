namespace FctServices.Deds
{
    using System.Collections.Generic;
    using System.Linq;
    using Entities;
    using Microsoft.WindowsAzure.Storage.Table;
    using Storage;

    public class FundingClaimRepository :  IFundingClaimRepository
    {
        private const string StorageTableName = "FundingClaimStub";
        private readonly IAzureTableStore _azureTableStore;
        private readonly string _tableName;

        public FundingClaimRepository(IAzureTableStore azureTableStore, IEnvironmentContext context)
        {
            _azureTableStore = azureTableStore;
            _tableName = StorageTableName + context.StorageTableSuffix;
            CreateTableStorage();
        }

        private void CreateTableStorage()
        {
            _azureTableStore.CreateTable(_tableName);
        }

        public List<string> GetCompletedClaimTypePeriods()
        {
            return _azureTableStore.GetRows<TableEntity>(_tableName, null)
                .Select(x => x.PartitionKey).Distinct().ToList();
        }

        public int GetTotal(string period, string claimType)
        {
            var table = _azureTableStore.GetTable(_tableName);
            var query = new TableQuery<FundingClaim>();
            query.Where(
                    TableQuery.GenerateFilterCondition("PartitionKey", QueryComparisons.Equal,
                        FundingClaim.CreatePartitionKey(period, claimType)));

            return table.ExecuteQuery(query)
                .Select(x => x.RowKey)
                .ToList()
                .Count;
        }

        public List<FundingClaim> GetRows(int pageNumber, int pageSize, string period, string claimType)
        {
            string startRowKey = (((pageNumber - 1) * pageSize) + 1).ToString("D8");
            string endRowKey = (pageNumber * pageSize).ToString("D8");

            var table = _azureTableStore.GetTable(_tableName);
            var query = new TableQuery<FundingClaim>();

            query.Where(
                    TableQuery.CombineFilters(
                        TableQuery.GenerateFilterCondition("PartitionKey", QueryComparisons.Equal, FundingClaim.CreatePartitionKey(period, claimType)),
                        TableOperators.And,
                        TableQuery.CombineFilters(
                            TableQuery.GenerateFilterCondition("RowKey", QueryComparisons.GreaterThanOrEqual, startRowKey),
                            TableOperators.And,
                            TableQuery.GenerateFilterCondition("RowKey", QueryComparisons.LessThanOrEqual, endRowKey))));

            var queryResults = table.ExecuteQuery(query);

            return queryResults.ToList();
        }
    }
}