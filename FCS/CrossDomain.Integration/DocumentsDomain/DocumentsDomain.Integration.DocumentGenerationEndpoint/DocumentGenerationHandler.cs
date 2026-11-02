namespace SFA.FCT.DocumentsDomain.Integration.DocumentGenerationEndpoint
{
    using System;
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using Common;
    using Common.Commands;
    using CrossDomain.Integration.Entities.Data;
    using CrossDomain.Integration.Messages.Commands;
    using CrossDomain.Integration.Messages.Messages;
    using DataStore.Repositories;
    using DocumentGeneration;
    using DocumentGeneration.Infrastructure;
    using Extensions;
    using Framework.Logging.Interfaces;
    using NServiceBus;

    public class DocumentGenerationHandler : IHandleMessages<DocumentGenerationCommand>
    {
        private readonly ILogger _logger;
        private readonly IDocumentGenerator _documentGenerator = null;
        private readonly IProcessedMessageRepository _processedMessageRepository;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;

        public DocumentGenerationHandler(
            IDocumentGenerator documentGenerator,
            ILogger logger,
            IProcessedMessageRepository processedMessageRepository,
            ISessionConnectionFactory sessionConnectionFactory)
        {
            _documentGenerator = documentGenerator;
            _logger = logger;
            _processedMessageRepository = processedMessageRepository;
            _sessionConnectionFactory = sessionConnectionFactory;
        }

        public async Task Handle(DocumentGenerationCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(DocumentsDomainLoggingEventId.DocumentGenerationStart, $"DocumentsDomain handling DocumentGenerationCommand message START: {message}");

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            string messageId = context.MessageId;

            if (_processedMessageRepository.Add(messageId, processingEndpoint: "DocumentsDomain.GenerateDocument", connectionInfo))
            {
                //check if the contract's hierarchyType is CONTRACT
                if (message.CorporateContract.hierarchyType == hierarchyType.CONTRACT)
                {
                    // Flatten the deliverable hierarchy structure to keep the lights on
                    message.CorporateContract.contractAllocations.ForEach(a =>
                    {
                        a.contractDeliverables = a.FlattenDeliverables(a.contractDeliverables);
                    });

                    DocumentSaveCommand details = _documentGenerator.GenerateDocument(message.CorrelationId,
                        message.CorporateContract, message.MasterContractNumber);
                    if (details == null)
                    {
                        await context.Reply(new DocumentGenerationComplete
                            {ContractNumber = message.CorporateContract.contractNumber})
                            .ConfigureAwait(false);
                    }
                    else
                    {
                        SendOptions sendOptions = new SendOptions();
                        sendOptions.RouteReplyTo(context.MessageHeaders.GetValueOrDefault("NServiceBus.ReplyToAddress", string.Empty)); // mimic old NSB5 extension Bus.ForwardForReply
                        
                        await context.Send(details, sendOptions);
                    }

                    _logger.LogInformation(DocumentsDomainLoggingEventId.DocumentGenerationEnd,
                        $"DocumentsDomain handling DocumentGenerationCommand message END: {message}");
                }
                else
                {
                    string errorMessage =
                        "Document Domain: A contract with the wrong hierarchyType was sent to the Document Generation Handler. HierarchyType sent is MASTERCONTRACT, expected CONTRACT.";
                    _logger.LogInformation(DocumentsDomainLoggingEventId.DocumentGenerationError, errorMessage);
                    throw new ArgumentException(errorMessage);
                }
            }
            else
            {
                _logger.LogInformation(DocumentsDomainLoggingEventId.DocumentGenerationAlreadyProcessed, $"Already processed this message DocumentsDomain handling DocumentGenerationCommand message END - {message}");
            }
        }
    }
}
