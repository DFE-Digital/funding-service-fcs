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

    public class DasContractRequestRejectedEventHandler :
        IHandleMessages<DasContractRequestRejectedEvent>
    {
        private readonly ILogger _logger;
        private readonly IEngagementEventRepository _engagementEventRepository;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;

        public DasContractRequestRejectedEventHandler(
            ILogger logger,
            IEngagementEventRepository engagementEventRepository,
            ISessionConnectionFactory sessionConnectionFactory)
        {
            _logger = logger;
            _engagementEventRepository = engagementEventRepository;
            _sessionConnectionFactory = sessionConnectionFactory;
        }

        public async Task Handle(DasContractRequestRejectedEvent message, IMessageHandlerContext context)
        {
            _logger.LogInformation(
                ContractRequestDomainEventLoggingId.DasContractRequestProcessedEventRecieved,
                $"MarkDasEngagementAsRejectedCommand received for event ID: {message.DasEngagementEventId}.");

            var connection = _sessionConnectionFactory.GetConnection(context);

            await _engagementEventRepository.Update(
                eventId:message.DasEngagementEventId,
                contractNumber: null,
                processingState: EngagementEventProcessingState.RejectedByRule,
                connectionInfo: connection);

            _logger.LogInformation(
                ContractRequestDomainEventLoggingId.DasContractRequestProcessedEventProcessed,
                $"MarkDasEngagementAsRejectedCommand processed for event ID: {message.DasEngagementEventId}.");
        }
    }
}