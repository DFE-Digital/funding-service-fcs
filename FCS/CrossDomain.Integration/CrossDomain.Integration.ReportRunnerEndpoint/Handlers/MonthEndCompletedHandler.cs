namespace CrossDomain.Integration.ReportRunnerEndpoint.Handlers
{
    using System.Configuration;
    using System.Threading.Tasks;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class MonthEndCompletedHandler : IHandleMessages<MonthEndCompletedEvent>
    {
        private readonly ILogger _logger;

        public MonthEndCompletedHandler(ILogger logger)
        {
            _logger = logger;
        }

        public async Task Handle(MonthEndCompletedEvent message, IMessageHandlerContext context)
        {
            _logger.LogInformation(CommonLoggingEventId.StartReceivedMonthEndCompletedEventForReporting, "Starting reporting handler for IMonthEndCompletedEvent");

            if (ShouldInitiateCdaReports())
            {
                await context.Send(new RunReportsAndArchiveExistingCommand
                {
                    GenerateLastApprovedReportsOnly = true
                }).ConfigureAwait(false);
            }

            _logger.LogInformation(CommonLoggingEventId.FinishReceivedMonthEndCompletedEventForReporting, "Finishing reporting handler for IMonthEndCompletedEvent");
        }

        private static bool ShouldInitiateCdaReports()
        {
            return bool.Parse(ConfigurationManager.AppSettings["MonthEnd:CompletionShouldInitiateCdaReports"]);
        }
    }
}
