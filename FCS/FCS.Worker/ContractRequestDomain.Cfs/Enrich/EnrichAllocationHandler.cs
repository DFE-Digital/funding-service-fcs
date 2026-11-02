namespace ContractRequestDomain.Cfs.Enrich
{
    using System.Threading.Tasks;
    using Commands;
    using Common;
    using ContractRequestDomain.Cfs.Common.Dtos;
    using NServiceBus;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class EnrichAllocationHandler : IHandleMessages<EnrichAllocationCommand>
    {
        private readonly ILogger _logger;

        public EnrichAllocationHandler(ILogger logger)
        {
            _logger = logger;
        }

        public async Task Handle(EnrichAllocationCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(ContractRequestCfsLoggingEvents.PollNotificationFeedCommandReceived, $"START: EnrichAllocationCommand received for {message}");

            Allocation allocation = message.Allocation;
            Enrich(allocation);

            await context.Send(new CreateAllocationCommand
            {
                Allocation = allocation
            }).ConfigureAwait(continueOnCapturedContext: false);

            _logger.LogInformation(ContractRequestCfsLoggingEvents.PollNotificationFeedCommandProcessed, $"END: EnrichAllocationCommand processed for {message}");
        }

        private static void Enrich(Allocation allocation)
        {
            allocation.FundingStreamPeriodCode = "ALLF1819";
            allocation.DeliverableCode = 5;
            allocation.FundingTypeCode = "LOANS";
            allocation.FundingPeriod = "AY1819";
        }
    }
}
