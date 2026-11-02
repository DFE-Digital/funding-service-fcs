namespace AllocationDeliveryDomain.Endpoint.Tests.Integration
{
    using System.Linq;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;

    public class ReportedActualStubRepository : IReportedActualStubRepository
    {
        private const string ReportedActualTableName = "ReportedActualStub";
        private const string ReportedActualGroupStorageTableName = "ReportedActualGroupStub";
        
        private readonly IAzureTableStore _azureTableStore;
        private readonly string _reportedActualTableName;
        private readonly string _reportedActualGroupTableName;

        public ReportedActualStubRepository(IAzureTableStore azureTableStore, IEnvironmentContext context)
        {
            _azureTableStore = azureTableStore;
            _reportedActualTableName = ReportedActualTableName + context.StorageTableSuffix;
            _reportedActualGroupTableName = ReportedActualGroupStorageTableName + context.StorageTableSuffix;
            CreateTableStorage();
        }

        public void AddRow(ReportedActual reportedActual, int rowKey)
        {
            reportedActual.PartitionKey = GetReportedActualTablePartitionKey(reportedActual);
            reportedActual.RowKey = rowKey.ToString("D8");
            _azureTableStore.CreateRow(_reportedActualTableName, reportedActual);

            var groupRecord =
                _azureTableStore.GetRow<ReportedActualGroup>(
                    _reportedActualGroupTableName, reportedActual.CollectionType, reportedActual.CollectionReturnCode) ??
                new ReportedActualGroup
                {
                    PartitionKey = reportedActual.CollectionType,
                    RowKey = reportedActual.CollectionReturnCode,
                    RowCount = 0
                };

            groupRecord.RowCount++;
            _azureTableStore.InsertOrReplace(_reportedActualGroupTableName, groupRecord);
        }

        public void RemoveRows()
        {
            var storedActuals = _azureTableStore.GetRows<ReportedActual>(_reportedActualTableName).ToList();

            storedActuals.ForEach(ra =>
            {
                _azureTableStore.DeleteRows(_reportedActualTableName, GetReportedActualTablePartitionKey(ra));
                _azureTableStore.DeleteRows(_reportedActualGroupTableName, GetReportedActualGroupTableRowKey(ra));
            });
        }

        private void CreateTableStorage()
        {
            _azureTableStore.CreateTableIfNotExists(_reportedActualTableName);
            _azureTableStore.CreateTableIfNotExists(_reportedActualGroupTableName);
        }

        private static string GetReportedActualTablePartitionKey(ReportedActual reportedActual)
        {
            return reportedActual.CollectionType + reportedActual.CollectionReturnCode;
        }

        private static string GetReportedActualGroupTableRowKey(ReportedActual reportedActual)
        {
            return reportedActual.CollectionType;
        }
    }
}
