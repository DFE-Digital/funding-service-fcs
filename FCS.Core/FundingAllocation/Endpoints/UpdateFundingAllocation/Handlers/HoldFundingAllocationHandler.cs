namespace FundingAllocation.Endpoints.UpdateFundingAllocation.Handlers
{
    using System.Threading.Tasks;
    using NServiceBus;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class HoldFundingAllocationHandler :IHandleMessages<HoldFundingAllocationCommand>
    {
        private readonly IFundingAllocationRepository _fundingAllocationRepository;
        private readonly ILogger _logger;

        public HoldFundingAllocationHandler(IFundingAllocationRepository fundingAllocationRepository, ILogger logger)
        {
            _fundingAllocationRepository = fundingAllocationRepository;
            _logger = logger;
        }

        public async Task Handle(HoldFundingAllocationCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingId.HoldFundingAllocationCommandReceived, $"Received HoldFundingAllocationCommand - {message}");

            await _fundingAllocationRepository.UpdateReleaseGroupOnFundingAllocation(message.FundingId, null);
            await context.SendLocal(new UpdateFundingAllocationInCrmCommand(
                fundingId: message.FundingId,
                releaseGroupId: null,
                serviceResponse: sfa_FundingAllocationServiceResponse.Hold));

            _logger.LogInformation(LoggingId.HoldFundingAllocationCommandProcessed, $"Processed HoldFundingAllocationCommand - {message}");
        }
    }
}
