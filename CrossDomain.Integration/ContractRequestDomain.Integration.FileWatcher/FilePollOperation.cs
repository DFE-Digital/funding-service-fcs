namespace SFA.FCT.ContractRequestDomain.Integration.FileWatcher
{
    using System;
    using System.Collections.Generic;
    using System.Diagnostics;
    using Polly;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Interfaces;
    using SFA.FCT.ContractRequestDomain.Common;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class FilePollOperation
    {
        private readonly ILogger _logger;
        private readonly IBulkUploadFileAccess _bulkUploadFileAccess;
        private readonly IFcsBus _bus;

        public FilePollOperation(ILogger logger, IBulkUploadFileAccess bulkUploadFileAccess, IFcsBus bus)
        {
            _logger = logger;
            _bulkUploadFileAccess = bulkUploadFileAccess;
            _bus = bus;
        }

        public void Poll()
        {
            var time = DateTime.Now;
            const string logMessage = "Looking for files";

            if (Debugger.IsAttached || (time.Minute % 5 == 0 && time.Second < 30))
            {
                _logger.LogInformation(ContractRequestDomainEventLoggingId.LookingForFiles, logMessage);
            }
            else
            {
                _logger.LogVerbose(ContractRequestDomainEventLoggingId.LookingForFiles, logMessage);
            }

            IList<string> files = Policy.Handle<Exception>()
                .WaitAndRetry(retryCount: 3, sleepDurationProvider: t => TimeSpan.FromSeconds(2))
                .Execute(_bulkUploadFileAccess.GetNewFiles);

            if (files.Count == 0)
            {
                return;
            }

            foreach (string file in files)
            {
                _logger.LogVerbose(ContractRequestDomainEventLoggingId.FoundFile, "Found file {0}", file);

                var batchId = Guid.NewGuid().ToString();

                _bus.Publish<INewExcelUploadFileEvent>(e =>
                {
                    e.UploadedFilename = file;
                    e.BatchId = batchId;
                }).Wait();

                _logger.LogInformation(ContractRequestDomainEventLoggingId.PublishingBulkImportFile,
                    "Publishing Bulk Upload File {0} {1}", file, batchId);
            }
        }
    }
}
