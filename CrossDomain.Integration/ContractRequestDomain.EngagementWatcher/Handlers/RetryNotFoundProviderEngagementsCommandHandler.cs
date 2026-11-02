namespace ContractRequestDomain.EngagementWatcher.Handlers
{
    using System.Linq;
    using System.Threading.Tasks;
    using ContractManagement.DataStore.Repositories;
    using NServiceBus;
    using Services;
    using SFA.FCT.ContractRequestDomain.Common;
    using SFA.FCT.ContractRequestDomain.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class RetryNotFoundProviderEngagementsCommandHandler : IHandleMessages<RetryNotFoundProviderEngagementsCommand>
    {
        private readonly ILogger _logger;
        private readonly IDasRequestService _dasRequestService;
        private readonly IEngagementEventRepository _engagementEventRepository;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;

        public RetryNotFoundProviderEngagementsCommandHandler(
            ILogger logger,
            IDasRequestService dasRequestService,
            IEngagementEventRepository engagementEventRepository,
            ISessionConnectionFactory sessionConnectionFactory)
        {
            _logger = logger;
            _dasRequestService = dasRequestService;
            _engagementEventRepository = engagementEventRepository;
            _sessionConnectionFactory = sessionConnectionFactory;
        }

        public async Task Handle(RetryNotFoundProviderEngagementsCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(ContractRequestDomainEventLoggingId.RetryNotFoundProviderEngagementsCommandRecieved,
                "RetryNotFoundProviderEngagementsCommand received.");

            var connection = _sessionConnectionFactory.GetConnection(context);

            DasRequestsResult providerNotFoundResult = await _dasRequestService.GetProviderNotFoundEvents(connection);

            _logger.LogInformation(ContractRequestDomainEventLoggingId.RetryNotFoundProviderEngagementsCommandDasRequests,
                $"RetryNotFoundProviderEngagementsCommand DasRequestsResult: {providerNotFoundResult}");

            var sendCommands = providerNotFoundResult.InitiatedEngagementEventsReceived.Select(
                dasRequest =>
                    new NewDasContractRequestCommand
                    {
                        DasRequest = dasRequest,
                        DasEngagementEventId = dasRequest.DasEngagementEventId
                    })
                .Select(context.Send).ToArray();

            await Task.WhenAll(sendCommands);

            await _engagementEventRepository.MarkEventsAsDuplicate(providerNotFoundResult.DuplicateEvents, connection);
            
            _logger.LogInformation(ContractRequestDomainEventLoggingId.RetryNotFoundProviderEngagementsCommandProcessed,
                "RetryNotFoundProviderEngagementsCommand processed.");
        }
    }
}