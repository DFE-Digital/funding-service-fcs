namespace SFA.FCT.AllocationDeliveryDomain.MDEnrich.Endpoint
{
    using Common;
    using NServiceBus;
    using Common.BusinessLogic.Repository;
    using Common.DataStore.Model;
    using CrossDomain.Integration.Entities.Data;
    using CrossDomain.Integration.Events;
    using Framework.Logging.Interfaces;
    using System.Threading.Tasks;

    public class ContractClosedHandler : IHandleMessages<ContractClosedEvent>
    {
        private readonly IInactiveAllocationRepository _inactiveAllocationRepository;
        private readonly ILogger _logger;

        public ContractClosedHandler(IInactiveAllocationRepository inactiveAllocationRepository, ILogger logger)
        {
            _inactiveAllocationRepository = inactiveAllocationRepository;
            _logger = logger;
        }

        public async Task Handle(ContractClosedEvent message, IMessageHandlerContext context)
        {
            _logger.LogInformation(AllocationDeliverDomainEventLoggingId.ClosedHandlerStarted, $"ContractClosed handler started for - {message.ContractNumber} v{message.VersionNumber}.{message.SubVersionNumber}");

            message.AllocationNumbers.ForEach(an =>
            {
                _inactiveAllocationRepository.AddOrUpdate(new InactiveAllocation(an, InactiveReason.Closed), ConnectionInfo.CreateDefault());
            });
            _inactiveAllocationRepository.SaveChanges();

            _logger.LogInformation(AllocationDeliverDomainEventLoggingId.ClosedHandlerCompleted, $"ContractClosed handler finished for - {message.ContractNumber} v{message.VersionNumber}.{message.SubVersionNumber}");
        }
    }
}
