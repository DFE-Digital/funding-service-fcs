namespace SFA.FCT.ContractRequestDomain.Integration.FileWatcher
{
    using System;
    using System.Collections.Generic;
    using System.Diagnostics;
    using Polly;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Interfaces;
    using SFA.FCT.ContractRequestDomain.Common;
    using SFA.FCT.ContractRequestDomain.DataStore.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;

    public static class SimpleFilePoller
    {
        public static void StartPolling(ILogger logger, IBulkUploadFileAccess bulkUploadFileAccess, IFcsBus bus, IFileWatcherLockResourceRepository fileWatcherLockResourceRepository)
        {
            logger.LogInformation("Started Polling");

            bool CanPoll(ConnectionInfo connectionInfo)
            {
                bool lockAquired = fileWatcherLockResourceRepository.CanAcquireLock(connectionInfo);
                
                return lockAquired;
            }

            RestrictedPoller.StartPolling(
                poll: () =>
            {
                LookForNewFiles(logger, bulkUploadFileAccess, bus);
            },
                canPoll: CanPoll,
                getConnection: fileWatcherLockResourceRepository.GetTransactionedConnectionInfo,
                logger: logger);
        }

        private static void LookForNewFiles(ILogger logger, IBulkUploadFileAccess bulkUploadFileAccess, IFcsBus bus)
        {
            var time = DateTime.Now;
            const string logMessage = "Looking for files";

            if (Debugger.IsAttached || (time.Minute % 5 == 0 && time.Second < 30))
            {
                logger.LogInformation(ContractRequestDomainEventLoggingId.LookingForFiles, logMessage);
            }
            else
            {
                logger.LogVerbose(ContractRequestDomainEventLoggingId.LookingForFiles, logMessage);
            }

            IList<string> files = Policy.Handle<Exception>()
                .WaitAndRetry(retryCount: 3, sleepDurationProvider: t => TimeSpan.FromSeconds(2))
                .Execute(bulkUploadFileAccess.GetNewFiles);

            if (files.Count == 0)
            {
                return;
            }

            foreach (string file in files)
            {
                logger.LogVerbose(ContractRequestDomainEventLoggingId.FoundFile, "Found file {0}", file);

                var batchId = Guid.NewGuid().ToString();

                bus.Publish<INewExcelUploadFileEvent>(e =>
                {
                    e.UploadedFilename = file;
                    e.BatchId = batchId;
                }).Wait();

                logger.LogInformation(ContractRequestDomainEventLoggingId.PublishingBulkImportFile,
                    "Publishing Bulk Upload File {0} {1}", file, batchId);
            }
        }
    }
}
