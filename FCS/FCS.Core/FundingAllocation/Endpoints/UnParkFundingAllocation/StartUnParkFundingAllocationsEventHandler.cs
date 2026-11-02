namespace FundingAllocation.Endpoints.UnParkFundingAllocation
{
    using System.Linq;
    using System.Threading.Tasks;
    using DataStore.Model;
    using NServiceBus;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class StartUnParkFundingAllocationsEventHandler : IHandleMessages<StartUnParkFundingAllocationsCommand>
    {
        private readonly IFundingAllocationRepository _fundingAllocationRepository;
        private readonly ILogger _logger;
        private const int BatchSize = 100;

        public StartUnParkFundingAllocationsEventHandler(IFundingAllocationRepository fundingAllocationRepository, ILogger logger)
        {
            _fundingAllocationRepository = fundingAllocationRepository;
            _logger = logger;
        }

        public async Task Handle(StartUnParkFundingAllocationsCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingId.StartUnParkFundingAllocationsCommandReceived, "StartUnParkFundingAllocationsEventHandler Received");

            var fundingIds = (await _fundingAllocationRepository
                .GetAllParkedFundingIdsWithSubStatuses(
                    FundingAllocationSubStatus.AwaitingContractTypeConfig,
                    FundingAllocationSubStatus.AwaitingFundingAllocationConfig,
                    FundingAllocationSubStatus.AwaitingFundingLineConfig))
                .ToList();

            await context.SendLocal(new UnParkFundingAllocationsCommand { FundingAllocationIds = fundingIds });

            // Removed sending several batched fundingIds messages approach. Performance issues may result in this returning.
            // If so then 'check UnParkFundingAllocationsCommands are complete' handler/functionality would be needed before 
            // sending CreateFundingAllocationExtractCommand message (currently in UnParkFundingAllocationsHandler)

            //var commands = fundingIds.GetBatchesOfSize(BatchSize)
            //    .Select(batch => new UnParkFundingAllocationsCommand {FundingAllocationIds = batch});

            //var sendTasks = commands.Select(context.SendLocal).ToList();

            //await Task.WhenAll(sendTasks);

            _logger.LogInformation(LoggingId.StartUnParkFundingAllocationsCommandProcessed, $"StartUnParkFundingAllocationsEventHandler Completed, Number of fundingIds to UnPark: {fundingIds.Count}");
        }
    }
}
