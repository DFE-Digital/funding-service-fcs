namespace ContractRequestDomain.Cfs.Xrm
{
    using System.Threading.Tasks;
    using Common;
    using ContractRequestDomain.Cfs.Commands;
    using ContractRequestDomain.Cfs.Xrm.Repositories;
    using NServiceBus;
    using SFA.FCT.Framework.Logging.Interfaces;
    using ContractRequestDomain.Cfs.Common.Events;

    public class CreateAllocationHandler : IHandleMessages<CreateAllocationCommand>
    {
        private readonly ILogger _logger;
        private readonly IAllocationRepository _allocationRepository;

        public CreateAllocationHandler(
            ILogger logger,
            IAllocationRepository allocationRepository)
        {
            _logger = logger;
            _allocationRepository = allocationRepository;
        }

        public async Task Handle(CreateAllocationCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(ContractRequestCfsLoggingEvents.CreateAllocationCommandReceived,$"START: CreateAllocationCommand for {message} received");

            _allocationRepository.CreateAllocationAndPeriods(message.Allocation);

            await context.Publish(new AllocationCreatedEvent { Allocation = message.Allocation }).ConfigureAwait(false);

            _logger.LogInformation(ContractRequestCfsLoggingEvents.CreateAllocationCommandProcessed, $"END: CreateAllocationCommand for {message} processed");
        }
    }
}
