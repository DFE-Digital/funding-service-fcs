namespace SFA.FCT.ContractRequestDomain.Integration.FileWatcher
{
    using System;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Interfaces;
    using SFA.FCT.ContractRequestDomain.Common;
    using SFA.FCT.ContractRequestDomain.DataStore.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging.Interfaces;

    public static class SimpleFilePoller
    {
        public static void StartPolling(ILogger logger, IBulkUploadFileAccess bulkUploadFileAccess, IFcsBus bus, IFileWatcherLockResourceRepository fileWatcherLockResourceRepository)
        {
            logger.LogInformation("Started Polling");

            var filePollOperation = new FilePollOperation(logger, bulkUploadFileAccess, bus);

            bool CanPoll(ConnectionInfo connectionInfo)
            {
                bool lockAquired = fileWatcherLockResourceRepository.CanAcquireLock(connectionInfo);
                
                return lockAquired;
            }

            RestrictedPoller.StartPolling(
                poll: filePollOperation.Poll,
                canPoll: CanPoll,
                getConnection: fileWatcherLockResourceRepository.GetTransactionedConnectionInfo,
                logger: logger);
        }
    }
}
