namespace ContractManagementService.Repositories
{
    using System.IO;
    using System.IO.Compression;
    using System.Linq;
    using System.Runtime.Serialization.Formatters.Binary;
    using System.Threading.Tasks;
    using DTOs;
    using Extensions;
    using SFA.FCS.Worker.Common;

    public class PagedStorageQueryRepository<T> : IPagedStorageQueryRepository<T>
    {
        private readonly IAzureTableStorageRepository _azureTableStorageRepository;
        private readonly IFcsConfiguration _configuration;
        private const string TableName = "DeliverableSettingConfiguration";
        public const string LatestPagePartitionKey = "Latest";

        public PagedStorageQueryRepository(IAzureTableStorageRepository azureTableStorageRepository, IFcsConfiguration configuration)
        {
            _azureTableStorageRepository = azureTableStorageRepository;
            _configuration = configuration;
        }

        public async Task<StoragePage<T>> GetEntitiesForPage(int page)
        {
            return await GetEntitiesForPartition(page.ToString());
        }

        public async Task<StoragePage<T>> GetEntitiesForLatestPage()
        {
            return await GetEntitiesForPartition(LatestPagePartitionKey);
        }

        private async Task<StoragePage<T>> GetEntitiesForPartition(string partitionKey)
        {
            StoragePage<T> page = new StoragePage<T>();
            var entities = await _azureTableStorageRepository.GetRows<PagedStorageEntity>(TableNameWithEnv(), partitionKey: partitionKey);
            page.Rows = entities.Select(ac => Deserialize<T>(ac.ContentBytes)).ToList();

            if (entities.Any())
            {
                page.PageNumber = entities.First().PageNumberOnceCommitted;
            }

            return page;
        }

        private string TableNameWithEnv()
        {
            var storageTableSuffix = _configuration["StorageTableSuffix"];
            if (storageTableSuffix.HasValue())
            {
                return $"{TableName}{storageTableSuffix}";
            }

            return TableName;
        }

        private static T1 Deserialize<T1>(byte[] bytes)
        {
            var memoryStream = new MemoryStream(bytes);
            using var decompressor = new GZipStream(memoryStream, CompressionMode.Decompress);
            BinaryFormatter binaryFormatter = new BinaryFormatter();

            return (T1)binaryFormatter.Deserialize(decompressor);
        }
    }
}
