namespace DocumentsDomain.Endpoint.ArchiveDocument
{
    using System;
    using System.Configuration;
    using System.Threading.Tasks;
    using Repositories;
    using NServiceBus;
    using SFA.FCT.DocumentsDomain.Common;
    using SFA.FCT.DocumentsDomain.Common.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Infrastructure;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.DocumentsDomain.DataStore.Models;
    using EventType = SFA.FCT.DocumentsDomain.DataStore.Models.EventType;
    using FctFile = SFA.FCT.DocumentsDomain.Common.Models.FctFile;

    public class ArchiveDocumentHandler : IHandleMessages<ArchiveDocumentCommand>
    {
        private readonly ILogger _logger;
        private readonly IArchivedDocumentRepository _archivedDocumentRepository;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;
        private readonly IOffice365Adapter _office365Adapter;

        public ArchiveDocumentHandler(
            ILogger logger,
            IArchivedDocumentRepository archivedDocumentRepository,
            ISessionConnectionFactory sessionConnectionFactory,
            IOffice365Adapter office365Adapter)
        {
            _logger = logger;
            _archivedDocumentRepository = archivedDocumentRepository;
            _sessionConnectionFactory = sessionConnectionFactory;
            _office365Adapter = office365Adapter;
        }

        public async Task Handle(ArchiveDocumentCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(DocumentsDomainLoggingEventId.RecordArchiveHandlerStarted,
                $"Documents ArchiveDocumentHandler - Started: {message}");

            RetrieveFileFromSharepointAndArchive(fileId: message.Key, fileName: message.FileName, folderName: message.FolderOrigin);

            var connectionInfo = _sessionConnectionFactory.GetConnection(context);

            var archivedDocument = new ArchivedDocument(message.Key,
                message.FileName,
                (EventType) message.EventType,
                message.FolderOrigin);

            await _archivedDocumentRepository.Add(archivedDocument, connectionInfo)
                .ConfigureAwait(continueOnCapturedContext: false);

            var documentDeleteCommand = new DocumentDeleteCommand();
            documentDeleteCommand.Files.Add(new FctFile(fileContainer: message.FolderOrigin, filename: message.FileName));

            await context.Send(documentDeleteCommand);

            _logger.LogInformation(DocumentsDomainLoggingEventId.RecordArchiveHandlerEnded,
                $"Documents ArchiveDocumentHandler - Ended: {message}");
        }

        private void RetrieveFileFromSharepointAndArchive(Guid fileId, string fileName, string folderName)
        {
            var fileBytes = _office365Adapter.GetFileContents(fileName: fileName, listName:folderName);
            AzureStorageWrapper.PutBlockBlob(
                CreateContainerAndFctFile(fileId.ToString()),
                fileBytes);
        }

        private static SFA.FCT.CrossDomain.Integration.Common.Storage.FctFile CreateContainerAndFctFile(string key)
        {
            string containerName = $"fcs-document-archive{GetEnvironmentSuffix()}";
            AzureStorageWrapper.CreateIfNotExists(containerName);

            return new SFA.FCT.CrossDomain.Integration.Common.Storage.FctFile(fileContainer: containerName,
                filename: key);
        }

        private static string GetEnvironmentSuffix()
        {
            string environment = ConfigurationManager.AppSettings["StorageTableSuffix"].ToLower();

            if (!string.IsNullOrEmpty(environment))
            {
                return "-" + environment;
            }

            return environment;
        }
    }
}