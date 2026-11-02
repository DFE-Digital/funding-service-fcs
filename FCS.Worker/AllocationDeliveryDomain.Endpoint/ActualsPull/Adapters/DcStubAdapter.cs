namespace AllocationDeliveryDomain.Endpoint.ActualsPull.Adapters
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Extensions;
    using Microsoft.WindowsAzure.Storage.Table;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using ClosedCollection = AllocationDelivery.Messages.DTOs.ClosedCollection;

    public class DcStubAdapter : IDcAdapter
    {
        private readonly IAzureTableStore _azureTableStore;
        private readonly string _tableName;
        private readonly string _reportedActualGroupStubDataTableName;

        public DcStubAdapter(
            IAzureTableStore azureTableStore,
            IEnvironmentContext environmentContext)
        {
            _azureTableStore = azureTableStore;
            _tableName = $"ReportedActualStub{environmentContext.StorageTableSuffix}";
            _reportedActualGroupStubDataTableName = $"ReportedActualGroupStub{environmentContext.StorageTableSuffix}";
        }

        public Task<IReadOnlyCollection<ClosedCollection>> GetClosedCollectionsSince(DateTime dateFrom)
        {
            //
            // we ignore the dateFrom in the stub and get all
            // 
            var reportedActuals = _azureTableStore.GetRows<ReportedActual>(_tableName);

            var groupCollections = _azureTableStore.GetRows<ReportedActualGroup>(_reportedActualGroupStubDataTableName)
                .Select(g => new ClosedCollection
                {
                    CollectionType = g.PartitionKey,
                    CollectionReturnCode = g.RowKey,
                    ClosedTime = DateTime.Now
                }).ToList();

            var closedCollections = new HashSet<ClosedCollection>(reportedActuals
                .GroupBy(ra => new {ra.CollectionType, ra.CollectionReturnCode})
                .Select(g => new ClosedCollection
                {
                    CollectionType = g.Key.CollectionType,
                    CollectionReturnCode = g.Key.CollectionReturnCode,
                    ClosedTime = DateTime.Now,
                    TotalRowCount = g.Count()
                })
                .ToList());

            groupCollections.ForEach(gc => closedCollections.Add(gc));
            
            return Task.FromResult((IReadOnlyCollection<ClosedCollection>) closedCollections.ToList());
        }
        
        public Task<IReadOnlyCollection<SummarisedActual>> GetClosedCollectionsPage(string collectionType, string collectionReturnCode, int pageNumber, int pageSize)
        {
            var reportedActuals = _azureTableStore.GetRows<ReportedActual>(_tableName)
                .Where(ra => ra.CollectionType == collectionType && ra.CollectionReturnCode == collectionReturnCode)
                .OrderBy(ra => ra.DeliverableCode)
                .Skip((pageNumber -1) * pageSize)
                .Take(pageSize)
                .ToList();

            return Task.FromResult((IReadOnlyCollection<SummarisedActual>) reportedActuals.Select(ra => ra.ToSummarisedActual()).ToList());
        }

        private class ReportedActualGroup : TableEntity
        {
            public int RowCount { get; set; }
        }
    }
}
