namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentSaver
{
    using Common;
    using Framework.Logging.NullObjects;
    using Common.Commands;
    using Framework.Logging.Interfaces;
    using CrossDomain.Integration.Common.Storage;

    public class DocumentSaver : IDocumentSaver
    {
        private readonly IOffice365Adapter _officeAdapter;
        
        public DocumentSaver(IOffice365Adapter office365Adapter)
        {
            _officeAdapter = office365Adapter;
            Logger = new LoggerNullObject();
        }

        public ILogger Logger { get; set; }

        public void SaveDocument(DocumentSaveCommand message)
        {
            Logger.LogInformation(DocumentsDomainLoggingEventId.DocumentSaverSaving, "DocumentSaver saving document for correlationId:{0} filename:{1} in document list {2}", message.CorrelationId, message.TargetFileName, message.DocumentLocation);

            string listName = message.DocumentLocation;

            Logger.LogInformation(DocumentsDomainLoggingEventId.DocumentSaverUploading, "DocumentSaver uploading file {0} in {1}", message, listName);

            _officeAdapter.UpsertFile(message.TargetFileName, message.FCTDocumentDatabus, listName);

            Logger.LogInformation(DocumentsDomainLoggingEventId.DocumentSaverUploaded, "DocumentSaver uploaded file {0} in {1}", message, listName);
        }
    }
}