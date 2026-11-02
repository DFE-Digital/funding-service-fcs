namespace SFA.FCT.Operations.Integrity.Handlers
{
    using System.Threading.Tasks;
    using NServiceBus;
    using Common.Commands;
    using CrossDomain.Integration.Messages.Commands;
    using Framework.Logging.Interfaces;
    using Services;

    public class InitiateCheckersCommandHandler : IHandleMessages<InitiateCheckersCommand>
    {
        private readonly ILogger _logger;
        private readonly IIntegrityCheckRunnerService _integrityCheckRunnerService;

        public InitiateCheckersCommandHandler(ILogger logger, IIntegrityCheckRunnerService integrityCheckRunnerService)
        {
            _logger = logger;
            _integrityCheckRunnerService = integrityCheckRunnerService;
        }

        public Task Handle(InitiateCheckersCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(IntegrityLoggingIds.StartInitiateCheckersCommand, $"Start handler for InitiateCheckersCommand for Checkers: {message}");

            _integrityCheckRunnerService.RunChecks(message);

            _logger.LogInformation(IntegrityLoggingIds.FinishInitiateCheckersCommand, $"Finish handler for InitiateCheckersCommand for Checkers: {message}");

            return Task.FromResult(0);
        }
    }
}
