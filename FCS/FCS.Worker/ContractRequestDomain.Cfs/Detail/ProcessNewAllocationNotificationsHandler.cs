namespace ContractRequestDomain.Cfs.Detail
{
    using System.Linq;
    using System.Threading.Tasks;
    using Common;
    using ContractRequestDomain.Cfs.Commands;
    using ContractRequestDomain.Cfs.Common.Commands;
    using ContractRequestDomain.Cfs.Detail.DTOs;
    using ContractRequestDomain.Cfs.Detail.Repositories;
    using ContractRequestDomain.Cfs.Detail.Services;
    using Infrastructure;
    using MoreLinq;
    using NServiceBus;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class ProcessNewAllocationNotificationsHandler : IHandleMessages<ProcessNewAllocationNotificationsCommand>
    {
        private readonly ILogger _logger;
        private readonly IProcessNewAllocationNotificationsService _newAllocationNotificationsService;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;
        private readonly IAllocationNotificationRepository _allocationNotificationRepository;

        public ProcessNewAllocationNotificationsHandler(
            ILogger logger,
            IProcessNewAllocationNotificationsService newAllocationNotificationsService,
            ISessionConnectionFactory sessionConnectionFactory,
            IAllocationNotificationRepository allocationNotificationRepository)
        {
            _logger = logger;
            _newAllocationNotificationsService = newAllocationNotificationsService;
            _sessionConnectionFactory = sessionConnectionFactory;
            _allocationNotificationRepository = allocationNotificationRepository;
        }

        public async Task Handle(ProcessNewAllocationNotificationsCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(ContractRequestCfsLoggingEvents.ProcessNewAllocationNotificationsCommandReceived, "START: ProcessNewAllocationNotificationsCommand received");

            var connectionInfo = _sessionConnectionFactory.GetConnection(context);

            AllocationWithEntityId[] allocations = await _newAllocationNotificationsService.GetPopulatedNewAllocations(connectionInfo)
                .ConfigureAwait(continueOnCapturedContext: false);

            await _allocationNotificationRepository.SetAllocationNotificationsToProcessing(connectionInfo,
                allocations.Select(a => a.EntityId).ToList())
                .ConfigureAwait(continueOnCapturedContext: false);

            allocations.ForEach(async a =>
            {
                await context.Send(new EnrichAllocationCommand
                {
                    Allocation = a.Allocation
                }).ConfigureAwait(continueOnCapturedContext: false);
            });
            
            _logger.LogInformation(ContractRequestCfsLoggingEvents.ProcessNewAllocationNotificationsCommandProcessed, "END: ProcessNewAllocationNotificationsCommand processed");
        }
    }
}
