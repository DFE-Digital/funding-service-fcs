namespace SFA.FCT.CrossDomain.Integration.Common.PagedStorage.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Entities;
    using Exceptions;
    using Framework.Logging.Interfaces;
    using Microsoft.WindowsAzure.Storage;
    using MoreLinq;
    using Storage;

    public abstract class AzurePagedStorageRepository<T>
    {
        public const string LatestPagePartitionKey = "Latest";
        public const string CorrelationPartitionKey = "Correlation";
        private const int PageSize = 10;
        private readonly IAzureTableStore _azureTableStore;
        private readonly IStorageObjectSerializer _storageObjectSerializer;
        private readonly ILogger _logger;
        private string _tableName;

        protected AzurePagedStorageRepository(string tableName, IAzureTableStore azureTableStore, IStorageObjectSerializer storageObjectSerializer, ILogger logger)
        {
            _tableName = tableName;
            _azureTableStore = azureTableStore;
            _storageObjectSerializer = storageObjectSerializer;
            _logger = logger;
            CreateTableStorage();
        }

        public string TableName
        {
            get
            {
                return _tableName;
            }

            set
            {
                // this is here to help testing
                if (_tableName != value)
                {
                    _tableName = value;
                    CreateTableStorage();
                }
            }
        }

        public static string FormatCorrelationTableName(string entityTableName)
        {
            return string.Format("{0}Correlation", entityTableName);
        }

        public static void AssertIsValidCorrelationId(string correlationId)
        {
            if (string.IsNullOrWhiteSpace(correlationId))
            {
                throw new ArgumentException("Must provide valid correlation ID");
            }
        }

        public bool Any()
        {
            return GetLatestRows().Any();
        }

        public StoragePage<T> GetEntitiesForPage(int page)
        {
            return GetEntitiesForPartition(page.ToString());
        }

        public StoragePage<T> GetEntitiesForLatestPage()
        {
            try
            {
                return GetEntitiesForPartition(LatestPagePartitionKey);
            }
            catch (StorageException)
            {
                _logger.LogWarning("There is an issue with the storage (the table may not have been created)");
                return new StoragePage<T>();
            }
        }

        public void Reseed(IReadOnlyList<T> entities)
        {
            if (Any())
            {
                throw new InvalidOperationException("Repository not empty, cannot reseed.");
            }

            List<PagedStorageCorrelationEntity> pagedStorageCorrelationEntities = new List<PagedStorageCorrelationEntity>();
            List<PagedStorageEntity> pagedStorageEntities = new List<PagedStorageEntity>();

            for (int i = 0; i < entities.Count; i++)
            {
                T entity = entities[i];
                int rowNumber = i + 1;
                string correlationId = Guid.NewGuid().ToString();

                pagedStorageCorrelationEntities.Add(new PagedStorageCorrelationEntity
                {
                    PartitionKey = CorrelationPartitionKey,
                    RowKey = AzureStorageKeyEncoder.Encode(correlationId)
                });

                int pageNumber = CalculateReseedingPageNumber(rowNumber);
                string partitionKey = CalculateReseedingPartitionKeyForPage(pageNumber, entities.Count);

                pagedStorageEntities.Add(new PagedStorageEntity
                {
                    PartitionKey = partitionKey,
                    RowKey = AzureStorageKeyEncoder.Encode(correlationId),
                    ContentBytes = _storageObjectSerializer.Serialize(entity),
                    PageNumberOnceCommitted = pageNumber
                });
            }

            _azureTableStore.CreateRows(FormatCorrelationTableName(_tableName), pagedStorageCorrelationEntities);
            _azureTableStore.CreateRows(TableName, pagedStorageEntities);
        }

        public static int CalculateReseedingPageNumber(int rowNumber)
        {
            return (int)Math.Ceiling(rowNumber / (decimal)PageSize);
        }

        public static string CalculateReseedingPartitionKeyForPage(int pageNumber, int entitiesCount)
        {
            int totalPagesIncludingLatestPage = (int)Math.Ceiling(entitiesCount / (decimal)PageSize);

            return pageNumber == totalPagesIncludingLatestPage ? LatestPagePartitionKey : pageNumber.ToString();
        }

        public void Clear()
        {
            _azureTableStore.DeleteAllRows<PagedStorageEntity>(_tableName);
            _azureTableStore.DeleteAllRows<PagedStorageCorrelationEntity>(FormatCorrelationTableName(_tableName));
        }

        protected void Add(T entity, string correlationId)
        {
            InsertCorrelationEntity(AzureStorageKeyEncoder.Encode(correlationId));

            var latestRows = GetLatestRows();
            var pageNumber = 1;
            if (latestRows.Any())
            {
                pageNumber = latestRows.First().PageNumberOnceCommitted;

                if (!PartitionHasSpaceForMoreRows(latestRows))
                {
                    ArchivePartition(latestRows, pageNumber.ToString());

                    // we need to start a new partition
                    pageNumber++;
                }
            }

            if (pageNumber == 1)
            {
                // this should mean that we have started a fresh table
                // however, due to the lack of atomicity in ArchivePartition
                // we need to check that we really have started a fresh table
                if (IsPartitionPresent(pageNumber.ToString()))
                {
                    // we need to wait until the partition has been archived and the new
                    // Latest partition has been added
                    pageNumber = GetLatestPageNumberWhenNewLatestPartionHasBeenAdded();
                }
            }

            AddRowToTable(entity, pageNumber, correlationId);
        }

        private static bool PartitionHasSpaceForMoreRows(IList<PagedStorageEntity> rows)
        {
            return rows.Count() < PageSize;
        }

        private int GetLatestPageNumberWhenNewLatestPartionHasBeenAdded()
        {
            const int maxNumberAttempts = 10;
            const int halfASecond = 500;
            int numAttempts = 0;
            IList<PagedStorageEntity> latestRows = null;
            do
            {
                System.Threading.Tasks.Task.Delay(halfASecond).Wait();
                latestRows = GetLatestRows();
                numAttempts++;
            } while (!latestRows.Any() && numAttempts < maxNumberAttempts);

            if (numAttempts == maxNumberAttempts)
            {
                throw new TimeoutException("Cannot find Latest Partition for Azure storage table - " + _tableName);
            }

            return latestRows.First().PageNumberOnceCommitted;
        }

        private bool IsPartitionPresent(string partitionKey)
        {
            return _azureTableStore.GetRows<PagedStorageEntity>(_tableName, partitionKey).Any();
        }

        private IList<PagedStorageEntity> GetLatestRows()
        {
            return _azureTableStore.GetRows<PagedStorageEntity>(_tableName, LatestPagePartitionKey).ToList();
        }

        private StoragePage<T> GetEntitiesForPartition(string partitionKey)
        {
            StoragePage<T> page = new StoragePage<T>();
            var entities = _azureTableStore.GetRows<PagedStorageEntity>(_tableName, partitionKey).ToList();
            page.Rows = entities.Select(ac => _storageObjectSerializer.Deserialize<T>(ac.ContentBytes)).ToList();
            if (entities.Any())
            {
                page.PageNumber = entities.First().PageNumberOnceCommitted;
            }

            return page;
        }

        private void AddRowToTable(T entity, int pageNumber, string correlationId)
        {
            var storageEntity = new PagedStorageEntity
            {
                PageNumberOnceCommitted = pageNumber,
                PartitionKey = LatestPagePartitionKey,
                RowKey = AzureStorageKeyEncoder.Encode(correlationId),
                ContentBytes = _storageObjectSerializer.Serialize(entity)
            };

            try
            {
                _azureTableStore.CreateRow(_tableName, storageEntity);
            }
            catch (StorageException storageException)
            {
                Exception exceptionToThrow = storageException;

                switch (storageException.RequestInformation.HttpStatusCode)
                {
                    case 409:
                        exceptionToThrow = new DuplicateKeyStorageException(storageException);
                        break;
                }

                throw exceptionToThrow;
            }
        }

        private void ArchivePartition(IList<PagedStorageEntity> rows, string newPartitionKey)
        {
            // delete existing partition
            _azureTableStore.DeleteRows(_tableName, LatestPagePartitionKey);

            // insert page with a new page number
            rows.ForEach(r => r.PartitionKey = newPartitionKey);
            _azureTableStore.CreateRows(_tableName, rows);
        }

        private void CreateTableStorage()
        {
            _azureTableStore.CreateTableIfNotExists(_tableName);
            _azureTableStore.CreateTableIfNotExists(FormatCorrelationTableName(_tableName));
        }

        private void InsertCorrelationEntity(string correlationId)
        {
            try
            {
                var correlationEntity = new PagedStorageCorrelationEntity
                {
                    PartitionKey = CorrelationPartitionKey,
                    RowKey = correlationId
                };

                _azureTableStore.CreateRow(FormatCorrelationTableName(_tableName), correlationEntity);
            }
            catch (StorageException storageException)
            {
                Exception exceptionToThrow = storageException;

                switch (storageException.RequestInformation.HttpStatusCode)
                {
                    case 409:
                        exceptionToThrow = new DuplicateKeyStorageException(storageException);
                        break;
                }

                throw exceptionToThrow;
            }
        }
    }
}
