namespace ActualsPull.Adapters
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using DTOs;
    using StubInfrastructure;

    public class DcStubAdapter : IDcAdapter
    {
        private readonly IAzureTableStore _azureTableStore;
        private readonly string _tableName;

        public DcStubAdapter(IAzureTableStore azureTableStore, string tableName)
        {
            _azureTableStore = azureTableStore;
            _tableName = tableName;
        }

        public async Task<IReadOnlyCollection<ClosedCollection>> GetClosedCollectionsSince(DateTime dateFrom)
        {
            //
            // we ignore the dateFrom in the stub and get all
            // 
            var reportedActuals = await _azureTableStore.GetAllRows<ReportedActual>(_tableName);

            return reportedActuals.GroupBy(ra => new {ra.CollectionType, ra.CollectionReturnCode})
                .Select(g => new ClosedCollection(
                    collectionType: g.Key.CollectionType,
                    collectionReturnCode: g.Key.CollectionReturnCode,
                    DateTime.Now,
                    g.Count()))
                .ToList();
        }
    }
}
