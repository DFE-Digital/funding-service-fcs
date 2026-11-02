namespace SFA.FCT.ContractRequestDomain.Integration.BulkUpload
{
    using System;
    using System.Transactions;
    using Common;
    using Common.Utils;
    using CrossDomain.Integration.Common.Storage;
    using Microsoft.WindowsAzure.Storage;

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
            _azureTableStore.CreateRow(_processingTable, _fileWatcherProcessingEntity);
            preparingEnlistment.Prepared();
        }

        public void Rollback(Enlistment enlistment)
        {
            try
            {
                _azureTableStore.DeleteRow(_processingTable, _fileWatcherProcessingEntity.PartitionKey, _fileWatcherProcessingEntity.RowKey);
            }
            catch (StorageException)
            {
                // suppress all storage exception as Rollback throwing something is a really bad idea.
            }
        
            enlistment.Done();
        }
    }
}
