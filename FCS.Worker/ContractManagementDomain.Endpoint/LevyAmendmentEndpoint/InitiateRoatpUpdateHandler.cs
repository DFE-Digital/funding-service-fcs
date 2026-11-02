namespace ContractManagementDomain.Endpoint.LevyAmendmentEndpoint
{
    using System.Threading.Tasks;
    using Infrastructure;
    using NServiceBus;
    using Services;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class InitiateRoatpUpdateHandler : IHandleMessages<InitiateRoatpUpdateCommand>
    {
        private readonly IRoatpApiHttpClient _roatpApiHttpClient;
        private readonly IRoatpRepositoryService _roatpRepositoryService;
        private readonly ILogger _logger;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;

        public InitiateRoatpUpdateHandler(IRoatpApiHttpClient roatpApiHttpClient, IRoatpRepositoryService roatpRepositoryService, ILogger logger, ISessionConnectionFactory sessionConnectionFactory)
        {
            _roatpApiHttpClient = roatpApiHttpClient;
            _roatpRepositoryService = roatpRepositoryService;
            _logger = logger;
            _sessionConnectionFactory = sessionConnectionFactory;
        }

        public async Task Handle(InitiateRoatpUpdateCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(ContractManagementLoggingEvents.InitiateRoatpUpdateHandleStarted, 
                "InitiateRoatpUpdateHandler - Started handling InitiateRoatpUpdateCommand - Getting all providers from RoATP");

            var retrievedProviders = await _roatpApiHttpClient.GetAllProviders().ConfigureAwait(continueOnCapturedContext: false);

            _logger.LogInformation(ContractManagementLoggingEvents.InitiateRoatpUpdateHandleRetrievedFromRoatp, 
                $"InitiateRoatpUpdateHandler - Found {retrievedProviders.Count} providers, updating cache");

            var connectionInfo = _sessionConnectionFactory.GetConnection(context);

            await _roatpRepositoryService.PopulateValidUkprnsFromRoatp(retrievedProviders, connectionInfo).ConfigureAwait(continueOnCapturedContext: false);

            _logger.LogInformation(ContractManagementLoggingEvents.InitiateRoatpUpdateHandleCompleted, 
                "InitiateRoatpUpdateHandler - Completed handling InitiateRoatpUpdateCommand, updated RoATP provider cache");
        }
    }
}