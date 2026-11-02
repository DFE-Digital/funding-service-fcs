namespace FundingAllocation.Endpoints.EnrichProviderFunding
{
    using System.Threading.Tasks;
    using NServiceBus;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class EnrichProviderFundingHandler : IHandleMessages<EnrichProviderFundingCommand>
    {
        private readonly ILogger _logger;
        private readonly IProviderService _providerService;

        public EnrichProviderFundingHandler(
            ILogger logger, IProviderService providerService)
        {
            _logger = logger;
            _providerService = providerService;
        }

        public async Task Handle(EnrichProviderFundingCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingId.EnrichProviderFundingCommandReceived, $"Received EnrichProviderFundingCommand for {message}");

            await _providerService.CreateProviderFundingAllocation(
                fundingId: message.FundingId,
                providerFundingId: message.ProviderFundingId);

            await context.Send(new CheckForReadCompleteCommand
            {
                FundingAllocationId = message.FundingId
            });

            _logger.LogInformation(LoggingId.EnrichProviderFundingCommandProcessed, $"Processed EnrichProviderFundingCommand for {message}");
        }
    }
}
