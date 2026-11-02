namespace ContractRequest.Cfs.AllocationCreated
{
    using System.Threading.Tasks;
    using ContractRequestDomain.Cfs;
    using NServiceBus;
    using SFA.FCT.Framework.Logging.Interfaces;
    using ContractRequestDomain.Cfs.Common.Events;
    using Repositories;
    using ContractRequest.Cfs.AllocationCreated.Infrastructure;
    using ContractRequestDomain.Cfs.Common;

    public class CompleteAllocationNotificationHandler : IHandleMessages<AllocationCreatedEvent>
    {
        private readonly ILogger _logger;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;
        private readonly IAllocationNotificationRepository _allocationNotificationRepository;

        public CompleteAllocationNotificationHandler(
            ILogger logger,
            ISessionConnectionFactory sessionConnectionFactory,
            IAllocationNotificationRepository allocationNotificationRepository)
        {
            _logger = logger;
            _sessionConnectionFactory = sessionConnectionFactory;
            _allocationNotificationRepository = allocationNotificationRepository;
        }

        public async Task Handle(AllocationCreatedEvent message, IMessageHandlerContext context)
        {
            _logger.LogInformation(ContractRequestCfsLoggingEvents.AllocationCreatedEventEventReceived,
                $"START: CompleteAllocationNotificationHandler AllocationCreatedEvent for {message} received");

            var connectionInfo = _sessionConnectionFactory.GetConnection(context);

            await _allocationNotificationRepository.SetAllocationNotificationToComplete(
                connectionInfo,
                allocationId: message.Allocation.Id,
                versionNumber: message.Allocation.MajorVersion);

            _logger.LogInformation(ContractRequestCfsLoggingEvents.AllocationCreatedEventEventProcessed,
                $"END: CompleteAllocationNotificationHandler AllocationCreatedEvent for {message} processed");
        }
    }
}