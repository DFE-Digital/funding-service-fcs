namespace SFA.FCT.ContractRequestDomain.EngagementWatcher.Handlers
{
    using System.Threading.Tasks;
    using NServiceBus;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using Services;
    using SFA.FCT.ContractRequestDomain.Common;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class DasContractRequestProviderNotFoundEventHandler :
        IHandleMessages<DasContractRequestProviderNotFoundEvent>
    {
        private readonly ILogger _logger;
        private readonly IEngagementEventRepository _engagementEventRepository;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;

        public DasContractRequestProviderNotFoundEventHandler(
            ILogger logger,
            IEngagementEventRepository engagementEventRepository,
            ISessionConnectionFactory sessionConnectionFactory)
        {
            _logger = logger;
            _engagementEventRepository = engagementEventRepository;
            _sessionConnectionFactory = sessionConnectionFactory;
        }

        public async Task Handle(DasContractRequestProviderNotFoundEvent message, IMessageHandlerContext context)
        {
            _logger.LogInformation(
                ContractRequestDomainEventLoggingId.DasContractRequestProcessedEventRecieved,
                $"MarkDasEngagementProviderNotFoundCommand recieved for event ID: {message.DasEngagementEventId}.");

            var connection = _sessionConnectionFactory.GetConnection(context);

            await _engagementEventRepository.Update(
                message.DasEngagementEventId,
                contractNumber:null,
                EngagementEventProcessingState.ProviderNotFound,
                connection);

            _logger.LogInformation(
                ContractRequestDomainEventLoggingId.DasContractRequestProcessedEventProcessed,
                $"MarkDasEngagementProviderNotFoundCommand processed for event ID: {message.DasEngagementEventId}");
        }
    }
}