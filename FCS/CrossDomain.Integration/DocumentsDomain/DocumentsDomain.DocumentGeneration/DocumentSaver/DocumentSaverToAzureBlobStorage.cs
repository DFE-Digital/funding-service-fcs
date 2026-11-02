namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentSaver
{
    using Common;
    using Common.Models;
    using Framework.Logging.NullObjects;
    using Integration;
    using Framework.Logging.Interfaces;

    public class DocumentSaverToAzureBlobStorage : IDocumentSaver
    {
        private readonly IDocumentRepository _documentRepository;

        public DocumentSaverToAzureBlobStorage(IDocumentRepository documentRepository)
        {
            _documentRepository = documentRepository;
            Logger = new LoggerNullObject();
        }

        public ILogger Logger { get; set; }

        public void SaveDocument(Common.Commands.DocumentSaveCommand message)
        {
            string targetContainer = System.Configuration.ConfigurationManager.AppSettings["DocumentGeneration.TargetContainer"];

            FctFile saveAs = new FctFile(targetContainer, message.TargetFileName);

            // Check if target already exists
            if (_documentRepository.FileExists(saveAs))
            {
                Logger.LogInformation(DocumentsDomainLoggingEventId.DocumentSaverRenaming, "DocumentSaverToAzureBlobStorage found existing document {0} and so copying as bak file and deleting original file.", message.TargetFileName);

                // Copy the old target to .bak
                _documentRepository.CopyDocument(
                    saveAs,
                    new FctFile(targetContainer, message.TargetFileName + ".bak"));
                
                // Delete the old target file
                _documentRepository.DeleteFile(saveAs);
            }

            Logger.LogInformation(DocumentsDomainLoggingEventId.DocumentSaverSaving, "DocumentSaverToAzureBlobStorage saving document as {0}", message.TargetFileName);
            _documentRepository.SaveDocument(saveAs, message.FCTDocumentDatabus);
        }
    }
}