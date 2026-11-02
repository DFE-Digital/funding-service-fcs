namespace FundingAllocation.Endpoints.CheckForMissingProvidersPostReadComplete
{
    using System.Threading.Tasks;
    using CheckForMissingProvidersComplete.Repositories;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class CheckForMissingProvidersPostReadCompleteHandler : IHandleMessages<CheckForMissingProvidersPostReadCompleteCommand>
    {
        private readonly ILogger _logger;
        private readonly IPostReadCompleteRepository _postReadCompleteRepository;

        public CheckForMissingProvidersPostReadCompleteHandler(
            ILogger logger, IPostReadCompleteRepository postReadCompleteRepository)
        {
            _logger = logger;
            _postReadCompleteRepository = postReadCompleteRepository;
        }

        public async Task Handle(CheckForMissingProvidersPostReadCompleteCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingId.CheckForMissingProvidersPostReadCompleteCommandReceived, $"Processing CheckForMissingProvidersPostReadCompleteCommand {message}");

            var isComplete = await _postReadCompleteRepository.IsPostReadMissingProviderCheckComplete();
            if (isComplete)
            {
                await context.Send(new CreateFundingAllocationExtractCommand());
            }

            _logger.LogInformation(LoggingId.CheckForMissingProvidersPostReadCompleteCommandProcessed, $"Processed CheckForMissingProvidersPostReadCompleteCommand {message}, isComplete: {isComplete}");
        }
    }
}
