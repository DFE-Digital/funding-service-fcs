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

    public class DasContractRequestCreatedEventHandler : 
        IHandleMessages<DasContractRequestCreatedEvent>
    {
        private readonly ILogger _logger;
        private readonly IEngagementEventRepository _engagementEventRepository;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;

        public DasContractRequestCreatedEventHandler(
            ILogger logger, 
            IEngagementEventRepository engagementEventRepository, 
            ISessionConnectionFactory sessionConnectionFactory)
        {
            _logger = logger;
            _engagementEventRepository = engagementEventRepository;
            _sessionConnectionFactory = sessionConnectionFactory;
        }

        public async Task Handle(DasContractRequestCreatedEvent message, IMessageHandlerContext context)
        {
            _logger.LogInformation(
                ContractRequestDomainEventLoggingId.DasContractRequestProcessedEventRecieved,
                $"MarkDasEngagementAsCreatedCommand received for event ID: {message.DasEngagementEventId}, contract number: {message.ContractNumber}.");
           
            var connection = _sessionConnectionFactory.GetConnection(context);
            
            await _engagementEventRepository.Update(message.DasEngagementEventId, message.ContractNumber, EngagementEventProcessingState.InCrm, connection);

            _logger.LogInformation(
                ContractRequestDomainEventLoggingId.DasContractRequestProcessedEventProcessed,
                $"MarkDasEngagementAsCreatedCommand processed for event ID: {message.DasEngagementEventId}, contract number: {message.ContractNumber}.");
        }
    }
}