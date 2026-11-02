namespace SFA.FCT.AllocationDeliveryDomain.Common.Storage
{
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Common.PagedStorage;
    using CrossDomain.Integration.Common.Storage;

    public class ReportedActualRepository : IReportedActualRepository
    {
        private const string StorageTableName = "ReportedActual";
        private readonly IAzureTableStore _azureTableStore;
   
        private readonly string _tableName;

        public ReportedActualRepository(IAzureTableStore azureTableStore, IEnvironmentContext context)
        {
            _azureTableStore = azureTableStore;
            _tableName = StorageTableName + context.StorageTableSuffix;
            CreateTableStorage();
        }

        public void AddRow(ReportedActual reportedActual, string collectionType, string collectionReturnCode)
        {
            reportedActual.PartitionKey = GetPartitionKey(collectionType, collectionReturnCode);
            reportedActual.RowKey = reportedActual.EntityRowKey;
            _azureTableStore.CreateRow(_tableName, reportedActual);
        }

        public void AddRows(IEnumerable<ReportedActual> reportedActuals, string collectionType, string collectionReturnCode)
        {
            foreach (var reportedActual in reportedActuals)
            {
                AddRow(reportedActual, collectionType, collectionReturnCode);
            }
        }

        public void RemoveRows(string collectionType, string collectionReturnCode)
        {
            _azureTableStore.DeleteRows(_tableName, GetPartitionKey(collectionType, collectionReturnCode));
        }

        private void CreateTableStorage()
        {
            _azureTableStore.CreateTable(_tableName);
        }


        public IEnumerable<ReportedActual> GetActuals(string collectionType, string collectionReturnCode)
        {
            return _azureTableStore.GetRows<ReportedActual>(_tableName, GetPartitionKey(collectionType, collectionReturnCode));
        }

        private static string GetPartitionKey(string collectionType, string collectionReturnCode)
        {
            return string.Format("{0}_{1}", collectionType, collectionReturnCode);
        }
    }
}
