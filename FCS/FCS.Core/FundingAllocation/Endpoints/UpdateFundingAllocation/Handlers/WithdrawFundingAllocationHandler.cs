namespace FundingAllocation.Endpoints.UpdateFundingAllocation.Handlers
{
    using System.Threading.Tasks;
    using System.Collections.Generic;
    using System.Linq;
    using DataStore.Model;
    using Services;
    using NServiceBus;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class WithdrawFundingAllocationHandler : IHandleMessages<WithdrawFundingAllocationCommand>
    {
        private readonly IFundingAllocationRepository _fundingAllocationRepository;
        private readonly ILogger _logger;
        private readonly IPreContractControlService _preContractControlService;

        public WithdrawFundingAllocationHandler(IFundingAllocationRepository fundingAllocationRepository,
            ILogger logger,
            IPreContractControlService preContractControlService)
        {
            _fundingAllocationRepository = fundingAllocationRepository;
            _logger = logger;
            _preContractControlService = preContractControlService;
        }

        public async Task Handle(WithdrawFundingAllocationCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingId.WithdrawFundingAllocationCommandReceived, $"Received WithdrawFundingAllocationCommand - {message}");

            await _fundingAllocationRepository.UpdateReleaseGroupOnFundingAllocation(message.FundingId, null);

            await _fundingAllocationRepository.SetFundingAllocationStatusSubStatus(new[] {message.FundingId}, FundingAllocationStatus.Withdrawn, FundingAllocationSubStatus.Withdrawn);

            await context.SendLocal(new UpdateFundingAllocationInCrmCommand(fundingId: message.FundingId,
                releaseGroupId: null,
                serviceResponse: sfa_FundingAllocationServiceResponse.Withdrawn));

            var parkResult =
                await _preContractControlService.GetFundingIdsToBeUnParkedOnApproval(new List<string> {message.FundingId});

            _logger.LogInformation(LoggingId.OnWithdrawFundingAllocationParkedFundingIdToBeUnParkedFound,
                $"Processing WithdrawFundingAllocationCommand for {message}, Parked Result: {parkResult}");

            await SendFundingAllocationsToContractControl(parkResult.FundingAllocationsForContractControl, context);

            await _preContractControlService.SetStatuses(
                parkResult.FundingIdsForParkingAwaitingOutcome,
                parkResult.FundingIdsForDiscardingNonMaterialUpdate,
                parkResult.FundingIdsAwaitingContractTypeConfig,
                parkResult.FundingIdsAwaitingFundingAllocationConfig,
                parkResult.FundingIdsAwaitingFundingLineConfig,
                parkResult.FundingAllocationsForContractControl
                    .Select(fa => fa.FundingId).ToList(),
                parkResult.MutualExclusiveForAdultFilterCheckResult);

            _logger.LogInformation(LoggingId.WithdrawFundingAllocationCommandProcessed, $"Processed WithdrawFundingAllocationCommand - {message}");
        }

        private async Task SendFundingAllocationsToContractControl(IReadOnlyCollection<FundingAllocation> fundingAllocationsToBeUnParked, IMessageHandlerContext context)
        {
            await context.Send(new IgnoreItemsOfNoInterestCommand
            {
                FundingAllocationIds = fundingAllocationsToBeUnParked.Select(fa => fa.FundingId).ToList()
            });
        }
    }
}
