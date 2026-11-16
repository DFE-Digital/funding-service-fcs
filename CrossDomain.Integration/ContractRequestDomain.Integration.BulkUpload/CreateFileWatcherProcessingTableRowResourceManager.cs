
namespace SFA.FCT.ContractRequestDomain.Integration.BulkUpload
{
    using System;
    using System.Transactions;
    using Common;
    using Common.Utils;
    using CrossDomain.Integration.Common.Storage;
    using Azure.Data.Tables;

    public class CreateFileWatcherProcessingTableRowResourceManager : IEnlistmentNotification
    {
        private readonly FileWatcherProcessingEntity _fileWatcherProcessingEntity;
        private readonly IAzureTableStore _azureTableStore;
        private readonly string _processingTable;

        public CreateFileWatcherProcessingTableRowResourceManager(IAzureTableStore azureTableStore, FileWatcherProcessingEntity entity)
        {
            _fileWatcherProcessingEntity = entity;
            _azureTableStore = azureTableStore;
            _processingTable = ConfigurationHelper.GetSetting(ConfigurationHelper.ProcessingTableConfigEntryKey);
        }

        public void Commit(Enlistment enlistment)
        {
            enlistment.Done();
        }

        public void InDoubt(Enlistment enlistment)
        {
            enlistment.Done();
        }

        public void Prepare(PreparingEnlistment preparingEnlistment)
        {
            _azureTableStore.CreateTableIfNotExists(_processingTable);

            // Use Azure.Data.Tables.TableEntity to satisfy the generic constraint (ITableEntity with public parameterless ctor)
            var entity = new TableEntity(_fileWatcherProcessingEntity.PartitionKey, _fileWatcherProcessingEntity.RowKey);

            _azureTableStore.CreateRow<TableEntity>(_processingTable, entity);

            preparingEnlistment.Prepared();
        }

        public void Rollback(Enlistment enlistment)
        {
            try
            {
                _azureTableStore.DeleteRow(_processingTable, _fileWatcherProcessingEntity.PartitionKey, _fileWatcherProcessingEntity.RowKey);
            }
            catch (Exception)
            {
                // suppress all storage exception as Rollback throwing something is a really bad idea.
            }
            enlistment.Done();
        }
    }
}
