namespace SFA.FCT.DocumentsDomain.Integration.DocumentGenerationEndpoint.DocumentSaverEndpoint
{
    using System.Threading.Tasks;
    using Common;
    using Common.Commands;
    using CrossDomain.Integration.Entities.Data;
    using CrossDomain.Integration.Events;
    using CrossDomain.Integration.Messages.Messages;
    using DocumentGeneration.DocumentSaver;
    using Framework.Logging.Interfaces;
    using NServiceBus;
    using DataStore.Repositories;
    using DocumentGeneration.Infrastructure;

    public class DocumentSaverHandler : IHandleMessages<DocumentSaveCommand>
    {
        private readonly ILogger _logger;
        private readonly IDocumentSaver _documentSaver = null;
        private readonly IProcessedMessageRepository _processedMessageRepository;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;

        public DocumentSaverHandler(
            IDocumentSaver documentSaver,
            ILogger logger,
            IProcessedMessageRepository processedMessageRepository,
            ISessionConnectionFactory sessionConnectionFactory)
        {
            _documentSaver = documentSaver;
            _logger = logger;
            _processedMessageRepository = processedMessageRepository;
            _sessionConnectionFactory = sessionConnectionFactory;
        }

        public async Task Handle(DocumentSaveCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(DocumentsDomainLoggingEventId.DocumentSaverStart, $"DocumentsDomain handling DocumentSaveCommand message START - {message}");

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            string messageId = context.MessageId;

            if (_processedMessageRepository.Add(messageId, processingEndpoint: "DocumentsDomain.SaveDocument", connectionInfo))
            {
                _documentSaver.SaveDocument(message);

                var reply = new DocumentGenerationComplete
                {
                    ContractNumber = message.ContractNumber,
                    ContractVersionNumber = message.ContractVersionNumber,
                    Ukprn = int.Parse(message.UKPRN),
                    DocumentsPublished = new[] { message.TargetFileName },
                    Contract = message.Contract,
                    CorrelationId = message.CorrelationId
                };

                await context.Reply(reply)
                    .ConfigureAwait(false);

                _logger.LogInformation(DocumentsDomainLoggingEventId.DocumentSaverReplied, "DocumentsDomain DocumentSaveCommand replied to {0}", context.ReplyToAddress);

                await context.Publish<IDocumentsPublishedEvent>(e =>
                {
                    e.ContractNumber = message.ContractNumber;
                    e.ContractVersionNumber = message.ContractVersionNumber;
                    e.Ukprn = int.Parse(message.UKPRN);
                    e.DocumentsPublished = new[] { message.TargetFileName };
                }).ConfigureAwait(false);
            }
            else
            {
                _logger.LogInformation(DocumentsDomainLoggingEventId.DocumentSaverAlreadyProcessed, $"Already processed this message DocumentsDomain handling DocumentSaveCommand message END - {message}");
            }
            
            _logger.LogInformation(DocumentsDomainLoggingEventId.DocumentSaverEnd, $"DocumentsDomain handling DocumentSaveCommand message END - {message}");
        }
    }
}