namespace FundingAllocation.Endpoints.CheckForReadComplete
{
    using System;
    using System.Threading.Tasks;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class SetBatchToDiscardedHandler : IHandleMessages<SetBatchToDiscardedCommand>
    {
        private readonly ILogger _logger;
        private readonly ICheckForReadCompleteFundingAllocationRepository _fundingAllocationRepository;

        public SetBatchToDiscardedHandler(ILogger logger, ICheckForReadCompleteFundingAllocationRepository fundingAllocationRepository)
        {
            _logger = logger;
            _fundingAllocationRepository = fundingAllocationRepository;
        }

        public async Task Handle(SetBatchToDiscardedCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingId.SetBatchToDiscardedCommandReceived, $"Received SetBatchToDiscardedCommand for {message}");

            await _fundingAllocationRepository.SetToDiscardedSupersededWhereParked(message.FundingNamesForDiscarding,
                message.ReadIdToIgnore);

            await _fundingAllocationRepository.UpdateParkingInfoForDiscarded(message.FundingNamesForDiscarding, message.ReadIdToIgnore, DateTime.Now);

            _logger.LogInformation(LoggingId.SetBatchToDiscardedCommandProcessed, $"Processed SetBatchToDiscardedCommand for {message}");
        }
    }
}
