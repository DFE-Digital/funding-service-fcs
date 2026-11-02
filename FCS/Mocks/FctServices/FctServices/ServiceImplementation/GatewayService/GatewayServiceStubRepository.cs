namespace FctServices.ServiceImplementation.GatewayService
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using Microsoft.WindowsAzure.Storage.Table;
    using Storage;

    public class GatewayServiceStubRepository
    {
        private const string UnSuffixedTableName = "GatewayServiceStub";
        private const string PartitionKey = "GatewayServiceStubPartitionKey";
        private readonly IAzureTableStore _tableStore;
        private readonly string _environmentSuffixedTableName;

        public GatewayServiceStubRepository(IAzureTableStore tableStore)
        {
            _tableStore = tableStore;
            _environmentSuffixedTableName = $"{UnSuffixedTableName}{ConfigurationManager.AppSettings["StorageTableSuffix"]}";

            _tableStore.CreateTable(_environmentSuffixedTableName);
        }

        public void Add(GatewayServiceStubEntity entity)
        {
            _tableStore.CreateRow(_environmentSuffixedTableName, new GatewayServiceStubEntity
            {
                PartitionKey = PartitionKey,
                RowKey = entity.Ukprn,
                Ukprn = entity.Ukprn,
                Status = entity.Status
            });
        }

        public void Update(GatewayServiceStubEntity entity)
        {
            _tableStore.ReplaceRow(_environmentSuffixedTableName, entity);
        }

        public GatewayServiceStubEntity FindByUkprn(string ukprn)
        {
            return _tableStore.GetRow<GatewayServiceStubEntity>(_environmentSuffixedTableName, PartitionKey, ukprn);
        }

        public void Clear()
        {
            _tableStore.DeleteRows(_environmentSuffixedTableName, PartitionKey);
        }

        public IReadOnlyCollection<GatewayServiceStubEntity> GetAll()
        {
            return
                _tableStore.GetRows<GatewayServiceStubEntity>(_environmentSuffixedTableName, PartitionKey)
                .OrderBy(a => int.Parse(a.RowKey))
                .ToList();
        }
    }

    public class GatewayServiceStubEntity : TableEntity
    {
        public string Ukprn { get; set; }

        public string Status { get; set; }
    }
}