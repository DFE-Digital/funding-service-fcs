namespace FundingAllocation.Endpoints.CheckForJobComplete
{
    using System.Threading.Tasks;
    using NServiceBus;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class CheckForJobCompleteHandler : IHandleMessages<CheckForJobCompleteCommand>
    {
        private readonly IJobCompleteRepository _jobCompleteRepository;
        private readonly ILogger _logger;

        public CheckForJobCompleteHandler(IJobCompleteRepository jobCompleteRepository, ILogger logger)
        {
            _jobCompleteRepository = jobCompleteRepository;
            _logger = logger;
        }

        public async Task Handle(CheckForJobCompleteCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingId.CheckForJobCompleteCommandReceived, $"Processing CheckForJobCompleteCommand {message}");

            if (await _jobCompleteRepository.IsJobComplete(message.ReadId))
            {
                await context.Send(new JobCompletedCommand(message.ReadId));

                _logger.LogInformation(LoggingId.CheckForJobCompleteCommandResult, $"CheckForJobCompleteCommand Job completed {message}");
            }

            _logger.LogInformation(LoggingId.CheckForJobCompleteCommandProcessed, $"Processed CheckForJobCompleteCommand {message}");
        }
    }
}