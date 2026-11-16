namespace ContractCreateDomain.Endpoint.EnrichForDocumentation
{
    using System;
    using System.Threading.Tasks;
    using Infrastructure;
    using NServiceBus;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Services;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class EnrichContractForDocumentationHandler : IHandleMessages<EnrichContractForDocumentationCommand>
    {
        private readonly ILogger _logger;
        private readonly IOrganisationService _organisationService;
        private readonly IContractEnrichmentService _contractEnrichmentService;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;

        public EnrichContractForDocumentationHandler(
            ILogger logger,
            IOrganisationService organisationService,
            IContractEnrichmentService contractEnrichmentService,
            ISessionConnectionFactory sessionConnectionFactory)
        {
            _logger = logger;
            _organisationService = organisationService;
            _contractEnrichmentService = contractEnrichmentService;
            _sessionConnectionFactory = sessionConnectionFactory;
        }

        public async Task Handle(EnrichContractForDocumentationCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(ContractCreateDomainEventLoggingId.EnrichContractForDocumentationCommandReceived, $"EnrichContractForDocumentationCommand received {message}");

            var orgServiceCache = new OrganisationServiceCache(_organisationService);

            var connectionInfo = _sessionConnectionFactory.GetConnection(context);
            await _contractEnrichmentService.EnrichContractWithOrganisationData(message.Contract, message.MasterContractNumber, connectionInfo, orgServiceCache.GetOrganisationForUkprn);

            await SendToDocGen(message.Contract, message.MasterContractNumber, message.ReplyToEndpointName, context);

            _logger.LogInformation(ContractCreateDomainEventLoggingId.EnrichContractForDocumentationCommandProcessed, $"EnrichContractForDocumentationCommand processed {message}");
        }

        private async Task SendToDocGen(
            Contract corporateContract,
            string masterContractNumber,
            string replyToEndpointName,
            IMessageHandlerContext context)
        {
            var message = new DocumentGenerationCommand
            {
                CorrelationId = Guid.NewGuid().ToString(),
                CorporateContract = corporateContract,
                MasterContractNumber = masterContractNumber
            };

            SendOptions sendOptions = new SendOptions();
            sendOptions.RouteReplyTo(replyToEndpointName);

            await context.Send(message, sendOptions);
        }
    }
}
