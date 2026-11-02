namespace SFA.FCT.Operations.Integrity.Handlers
{
    using System;
    using System.Threading.Tasks;
    using CrossDomain.Integration.Events;
    using CrossDomain.Integration.Messages.Commands;
    using FCS.Worker.Common;
    using Framework.Logging.Interfaces;
    using NServiceBus;

    public class MonthEndCompletedHandler : IHandleMessages<MonthEndCompletedEvent>
    {
        private const int MinutesBetweenIntegrityCheckerBatches = 30;
        private readonly ILogger _logger;
        private readonly IFcsConfiguration _configuration;

        public MonthEndCompletedHandler(ILogger logger, IFcsConfiguration configuration)
        {
            _logger = logger;
            _configuration = configuration;
        }

        public async Task Handle(MonthEndCompletedEvent message, IMessageHandlerContext context)
        {
            _logger.LogInformation(IntegrityLoggingIds.StartReceivedMonthEndCompletedEvent, "Starting handler for IMonthEndCompletedEvent");

            if (ShouldInitiateIntegrityCheckers())
            {
                await context.Send(InitiateCheckersCommand.CreatePostMonthEndImmediateBatchIntegrityChecksCommand());

                SendOptions sendOptions = new SendOptions();
                sendOptions.DelayDeliveryWith(TimeSpan.FromMinutes(MinutesBetweenIntegrityCheckerBatches));
                await context.Send(InitiateCheckersCommand.CreatePostMonthEndDelayedBatchIntegrityChecksCommand(), sendOptions);
            }

            _logger.LogInformation(IntegrityLoggingIds.FinishReceivedMonthEndCompletedEvent, "Finishing handler for IMonthEndCompletedEvent");
        }

        private bool ShouldInitiateIntegrityCheckers()
        {
            return bool.Parse(_configuration["MonthEnd:CompletionShouldInitiateIntegrityCheckers"]);
        }
    }
}
