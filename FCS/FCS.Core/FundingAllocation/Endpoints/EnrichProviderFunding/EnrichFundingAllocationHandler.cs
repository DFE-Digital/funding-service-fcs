namespace FundingAllocation.Endpoints.EnrichProviderFunding
{
    using System;
    using System.Linq;
    using System.Threading.Tasks;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class EnrichFundingAllocationHandler : IHandleMessages<EnrichFundingAllocationCommand>
    {
        private readonly ILogger _logger;

        public EnrichFundingAllocationHandler(ILogger logger)
        {
            _logger = logger;
        }

        public async Task Handle(EnrichFundingAllocationCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingId.EnrichFundingAllocationCommandReceived, $"Received EnrichFundingAllocationCommand for {message}");

            var fundingAllocation = message.FundingAllocation;

            if (!fundingAllocation.ProviderFundingIds.Any())
            {
                throw new InvalidOperationException($"Funding Allocation has no Provider Fundings: {fundingAllocation}");
            }

            foreach (var providerFundingId in fundingAllocation.ProviderFundingIds)
            {
                await context.SendLocal(new EnrichProviderFundingCommand
                {
                    FundingId = fundingAllocation.FundingId,
                    ProviderFundingId = providerFundingId
                });
            }

            _logger.LogInformation(LoggingId.EnrichFundingAllocationCommandProcessed, $"Processed EnrichFundingAllocationCommand for {message}");
        }
    }
}
