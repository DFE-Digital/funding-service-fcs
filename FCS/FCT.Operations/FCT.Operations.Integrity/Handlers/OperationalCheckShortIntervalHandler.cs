namespace SFA.FCT.Operations.Integrity.Handlers
{
    using System.Threading.Tasks;
    using CrossDomain.Integration.Messages.Commands;
    using Framework.Logging.Interfaces;
    using NServiceBus;

    public class OperationalCheckShortIntervalHandler : IHandleMessages<OperationalCheckShortIntervalCommand>
    {
        private readonly ILogger _logger;

        public OperationalCheckShortIntervalHandler(ILogger logger)
        {
            _logger = logger;
        }

        public async Task Handle(OperationalCheckShortIntervalCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(IntegrityLoggingIds.OperationalCheckShortIntervalCommandReceived, "OperationalCheckShortIntervalCommand received");

            await context.SendLocal(new CheckForDuplicateContractsCommand());
            _logger.LogInformation(IntegrityLoggingIds.CheckForDuplicateContractsCommandSent, "CheckForDuplicateContractsCommand Sent");

            await SendCheckConnectivityCommandToDestination(context, "FundingAllocation.Operational", "Operations.Connectivity");
            _logger.LogInformation(IntegrityLoggingIds.CheckConnectivityCommandSent, "CFS CheckConnectivityCommand Sent");

            await SendCheckConnectivityCommandToDestination(context, "ContractRequestDomain.EngagementWatcher", "Operations.Connectivity");
            _logger.LogInformation(IntegrityLoggingIds.CheckConnectivityCommandSent, "DAS CheckConnectivityCommand Sent");

            await SendCheckConnectivityCommandToDestination(context, "OrgService.Main", "Operations.Connectivity");
            _logger.LogInformation(IntegrityLoggingIds.CheckConnectivityCommandSent, "Orgservice CPDS CheckConnectivityCommand Sent");

            _logger.LogInformation(IntegrityLoggingIds.OperationalCheckShortIntervalCommandProcessed, "OperationalCheckShortIntervalCommand processed");
        }

        private static async Task SendCheckConnectivityCommandToDestination(IMessageHandlerContext context, string destination, string replyTo)
        {
            var sendOptions = new SendOptions();
            var checkConnectivityCommand = new CheckConnectivityCommand();

            sendOptions.SetDestination(destination);
            sendOptions.RouteReplyTo(replyTo);

            await context.Send(checkConnectivityCommand, sendOptions);
        }
    }
}