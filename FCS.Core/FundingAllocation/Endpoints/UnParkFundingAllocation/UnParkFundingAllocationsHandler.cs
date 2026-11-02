namespace FundingAllocation.Endpoints.UnParkFundingAllocation
{
    using System.Linq;
    using System.Threading.Tasks;
    using NServiceBus;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class UnParkFundingAllocationsHandler: IHandleMessages<UnParkFundingAllocationsCommand>
    {
        private readonly IPreContractControlService _preContractControlService;
        private readonly ILogger _logger;

        public UnParkFundingAllocationsHandler(
            IPreContractControlService preContractControlService,
            ILogger logger)
        {
            _preContractControlService = preContractControlService;
            _logger = logger;
        }

        public async Task Handle(UnParkFundingAllocationsCommand message, IMessageHandlerContext context)
        {
            const int readIdThatDoesntExist = -1;
            _logger.LogInformation(LoggingId.UnParkFundingAllocationsCommandReceived, $"UnParkFundingAllocationsCommand received: {message}");

            var parkCheckResult = await _preContractControlService.GetParkCheckResult(message.FundingAllocationIds.ToList(), readIdThatDoesntExist);

            _logger.LogInformation(LoggingId.UnParkFundingAllocationsParkResult, $"UnParkFundingAllocationsCommand received parkCheckResult: {parkCheckResult}, for message: {message}");

            await context.Send(new IgnoreItemsOfNoInterestCommand
            {
                FundingAllocationIds = parkCheckResult.FundingIdsForContractControl
            });

            await _preContractControlService.SetStatuses(
                parkCheckResult.FundingIdsForParkingAwaitingOutcome,
                parkCheckResult.FundingIdsForDiscardingNonMaterialUpdate,
                parkCheckResult.FundingIdsAwaitingContractTypeConfig,
                parkCheckResult.FundingIdsAwaitingFundingAllocationConfig,
                parkCheckResult.FundingIdsAwaitingFundingLineConfig,
                parkCheckResult.FundingAllocationsForContractControl
                    .Select(fa => fa.FundingId).ToList(),
                parkCheckResult.MutualExclusiveForAdultFilterCheckResult);

            await context.Send(new CreateFundingAllocationExtractCommand());

            _logger.LogInformation(LoggingId.UnParkFundingAllocationsCommandProcessed, $"UnParkFundingAllocationsCommand processed: {message}");
        }
    }
}
