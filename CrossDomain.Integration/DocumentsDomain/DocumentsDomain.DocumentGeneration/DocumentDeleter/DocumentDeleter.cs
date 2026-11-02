namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDeleter
{
    using Common;
    using Common.Models;
    using CrossDomain.Integration.Common.Storage;
    using Framework.Logging.Interfaces;
    using Framework.Logging.NullObjects;

    public class DocumentDeleter : IDocumentDeleter
    {
        private readonly IOffice365Adapter _officeAdapter;

        public DocumentDeleter(IOffice365Adapter office365Adapter)
        {
            _officeAdapter = office365Adapter;
            Logger = new LoggerNullObject();
        }
        
        public ILogger Logger { get; set; }

        public void DeleteDocument(DocumentDeleteRequest documentDeleteRequest)
        {
            // Create filename
            Logger.LogInformation(DocumentsDomainLoggingEventId.DocumentDeleterDeleting, "DocumentDeleter deleting document filename {0} in {1}/{2}", documentDeleteRequest.DocumentFilename, "Location", documentDeleteRequest.DocumentLocation);

            _officeAdapter.DeleteFile(documentDeleteRequest.DocumentFilename, documentDeleteRequest.DocumentLocation);
        }
    }
}
