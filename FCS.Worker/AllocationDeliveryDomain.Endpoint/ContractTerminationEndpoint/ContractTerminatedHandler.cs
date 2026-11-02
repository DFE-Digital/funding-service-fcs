namespace AllocationDeliveryDomain.Endpoint.ContractTerminationEndpoint
{
    using System.Threading.Tasks;
    using Infrastructure;
    using NServiceBus;
    using SFA.FCT.AllocationDeliveryDomain.Common;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class ContractTerminatedHandler : IHandleMessages<ContractTerminatedEvent>
    {
        private readonly IInactiveAllocationRepository _inactiveAllocationRepository;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;
        private readonly ILogger _logger;

        public ContractTerminatedHandler(IInactiveAllocationRepository inactiveAllocationRepository, ISessionConnectionFactory sessionConnectionFactory, ILogger logger)
        {
            _inactiveAllocationRepository = inactiveAllocationRepository;
            _sessionConnectionFactory = sessionConnectionFactory;
            _logger = logger;
        }

        public Task Handle(ContractTerminatedEvent message, IMessageHandlerContext context)
        {
            _logger.LogInformation(AllocationDeliverDomainEventLoggingId.ContractTerminatedHandlerStarted, $"ContractTerminatedHandler started for: {message}");

            ConnectionInfo connectionInfo  = _sessionConnectionFactory.GetConnection(context);

            message.AllocationNumbers
                .ForEach(a => _inactiveAllocationRepository.AddOrUpdate(
                    new InactiveAllocation(a, InactiveReason.Terminated),
                    connectionInfo));

            _logger.LogInformation(AllocationDeliverDomainEventLoggingId.ContractTerminatedHandlerEnded, $"ContractTerminatedHandler completed for: {message}");

            return Task.FromResult(0);
        }
    }
}