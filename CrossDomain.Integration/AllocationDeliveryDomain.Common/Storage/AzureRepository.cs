namespace SFA.FCT.AllocationDeliveryDomain.Common.Storage
{
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Common.PagedStorage;
    using CrossDomain.Integration.Common.Storage;
    using Microsoft.WindowsAzure.Storage.Table;

    public class AzureRepository<T> : IAzureRepository<T> where T : TableEntity, IAzureEntity, new()
    {
        private readonly IAzureTableStore _azureTableStore;
        private readonly IEnvironmentContext _context;
        private string _tableName;

        public AzureRepository(IAzureTableStore azureTableStore, IEnvironmentContext context)
        {
            _azureTableStore = azureTableStore;
            _context = context;
        }

        public void AddRow(T entity)
        {
            UpdateKeys(entity);
            _azureTableStore.CreateRow(GetTableName(), entity);
        }

        public void AddRows(IEnumerable<T> entities)
        {
            foreach (var entity in entities)
            {
                UpdateKeys(entity);
            }

            _azureTableStore.CreateRows(GetTableName(), entities);
        }

        /// <summary>
        /// This will overwrite the record no matter what, avoiding optimistic concurrency.
        /// Use this with caution
        /// </summary>
        /// <param name="entity">The entity we want to add or update</param>
        public void AddRowOrUpdate(T entity)
        {
            UpdateKeys(entity);
            _azureTableStore.InsertOrReplace(GetTableName(), entity);
        }

        public T GetRow(string partitionKey, string rowKey)
        {
            return _azureTableStore.GetRow<T>(GetTableName(), partitionKey, rowKey);
        }

        public void ReplaceRow(T entity)
        {
            _azureTableStore.ReplaceRow(GetTableName(), entity);
        }

        public IList<T> GetRows(string partitionKey)
        {
            return _azureTableStore.GetRows<T>(GetTableName(), partitionKey).ToList();
        }

        public IList<T> GetRows()
        {
            return _azureTableStore.GetRows<T>(GetTableName()).ToList();
        }

        public void DeleteRows(string partitionKey)
        {
            _azureTableStore.DeleteRows(GetTableName(), partitionKey);
        }

        public void Clear()
        {
            _azureTableStore.DeleteTable(GetTableName());
        }

        public void Clear(string partitionKey)
        {
            _azureTableStore.DeleteRows(GetTableName(), partitionKey);
        }

        private string GetTableName()
        {
            if (string.IsNullOrEmpty(_tableName))
            {
                _tableName = new T().TableName + _context.StorageTableSuffix;
                _azureTableStore.CreateTableIfNotExists(_tableName);
            }

            return _tableName;
        }

        private void UpdateKeys(T entity)
        {
            if (string.IsNullOrEmpty(entity.PartitionKey))
            {
                entity.PartitionKey = entity.EntityPartitionKey;
            }

            if (string.IsNullOrEmpty(entity.RowKey))
            {
                entity.RowKey = entity.EntityRowKey;
            }
        }
    }
}
