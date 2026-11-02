namespace SFA.FCT.DocumentsDomain.Integration.DocumentGenerationEndpoint.DocumentDeleteEndpoint
{
    using System.Threading.Tasks;
    using Common;
    using Common.Commands;
    using Common.Models;
    using DocumentGeneration.DocumentDeleter;
    using Framework.Logging.Interfaces;
    using NServiceBus;

    public class DocumentDeleterHandler : IHandleMessages<DocumentDeleteCommand>
    {
        private readonly ILogger _logger;
        private readonly IDocumentDeleter _documentDeleter;

        public DocumentDeleterHandler(IDocumentDeleter documentDeleter, ILogger logger)
        {
            _documentDeleter = documentDeleter;
            _logger = logger;
        }

        public Task Handle(DocumentDeleteCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(DocumentsDomainLoggingEventId.DocumentDeleterStart, "DocumentsDomain handling DocumentDeleteCommand message START");

            // Execute a document delete for each contract found in the master contract
            foreach(var fileToDelete in message.Files)
            { 
                _documentDeleter.DeleteDocument(new DocumentDeleteRequest
                {
                    DocumentFilename = fileToDelete.Filename,
                    DocumentLocation = fileToDelete.FileContainer
                });

                _logger.LogInformation(DocumentsDomainLoggingEventId.DocumentDeleterDeleting, "DocumentsDomain Deleting contract documentation '{0}', location '{1}'", fileToDelete.Filename, fileToDelete.FileContainer);
            }

            _logger.LogInformation(DocumentsDomainLoggingEventId.DocumentDeleterEnd, "DocumentsDomain handling DocumentDeleteCommand message END");

            return Task.CompletedTask;
        }
    }
}
