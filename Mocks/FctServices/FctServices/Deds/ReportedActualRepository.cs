namespace FctServices.Deds
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Entities;
    using Microsoft.WindowsAzure.Storage.Table;
    using Storage;

    public class ReportedActualRepository : IReportedActualRepository
    {
        private const string StorageTableName = "ReportedActualStub";
        private const string CollectionGroupStorageTableNamePrefix = "ReportedActualGroupStub";
        private readonly IAzureTableStore _azureTableStore;
        private const string PartitionKey = "N";
        private readonly string _tableName;
        private readonly string _collectionGroupTableName;

        private static IList<ReportedActual> _reportedActualsForPerformance = new List<ReportedActual>(); 
      
        public ReportedActualRepository(IAzureTableStore azureTableStore, IEnvironmentContext context)
        {
            _azureTableStore = azureTableStore;
            _tableName = StorageTableName + context.StorageTableSuffix;
            _collectionGroupTableName = CollectionGroupStorageTableNamePrefix + context.StorageTableSuffix;
            CreateTableStorage();
        }

        private void CreateTableStorage()
        {
            _azureTableStore.CreateTable(_tableName);
        }

        public void Add(ReportedActual reportedActual)
        {
            reportedActual.PartitionKey = PartitionKey;
            reportedActual.RowKey = reportedActual.GetKey();
            _azureTableStore.CreateRow(_tableName, reportedActual);
        }

        public IList<CollectionGroup> GetCollectionGroups()
        {
            var collectionGroupRows = _azureTableStore.GetRows<TableEntity>(_collectionGroupTableName, null);

            return collectionGroupRows.Select(row => new CollectionGroup(row.PartitionKey, row.RowKey)).ToList();
        }

        public IEnumerable<ReportedActual> GetRows(int pageNumber, int pageSize, string collectionType, string collectionReturnCode)
        {
            string startRowKey = (((pageNumber - 1)*pageSize) + 1).ToString("D8");
            string endRowKey = (pageNumber * pageSize).ToString("D8");

            var table = _azureTableStore.GetTable(_tableName);
            var query = new TableQuery<ReportedActual>();

            query.Where(
                    TableQuery.CombineFilters(
                        TableQuery.GenerateFilterCondition("PartitionKey", QueryComparisons.Equal, collectionType + collectionReturnCode),
                        TableOperators.And,
                        TableQuery.CombineFilters(
                            TableQuery.GenerateFilterCondition("RowKey", QueryComparisons.GreaterThanOrEqual, startRowKey),
                            TableOperators.And,
                            TableQuery.GenerateFilterCondition("RowKey", QueryComparisons.LessThanOrEqual, endRowKey))));

            var queryResults = table.ExecuteQuery(query);

            return queryResults.ToList();
        }

        public int GetTotal(string collectionType, string collectionReturnCode)
        {
            var collectionGroupRow = _azureTableStore.GetRow<DynamicTableEntity>(_collectionGroupTableName, collectionType, collectionReturnCode);

            return collectionGroupRow == null ? 0 : collectionGroupRow.Properties["RowCount"].Int32Value.Value;
        }

        private List<ReportedActual> GetAllRows()
        {
            List<ReportedActual> rows = _azureTableStore.GetRows<ReportedActual>(_tableName, PartitionKey).ToList();
            return rows;
        }

        /// <summary>
        /// This method is called from GetRows when doing performance testing
        /// </summary>
        /// <param name="collectionType"></param>
        /// <param name="collectionReturnCode"></param>
        /// <returns></returns>
        private static IList<ReportedActual> GetReportedActualsForPerformance(string collectionType, string collectionReturnCode)
        {
            const int numActuals = 100;
            if (_reportedActualsForPerformance.Count == 0)
            {
                for (int i = 0; i < numActuals; i++)
                {
                    _reportedActualsForPerformance.Add(new ReportedActual
                    {
                        CollectionType = collectionType,
                        CollectionReturnCode = collectionReturnCode,
                        FundingStreamPeriodCode = "GGG",
                        OrganisationId = "123456",
                        Period = "081212"
                    });
                }
            }

            return _reportedActualsForPerformance;
        }
    }
}