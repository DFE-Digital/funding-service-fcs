namespace FundingAllocation.Endpoints.ReleaseGroup.Handlers
{
    using System.Threading.Tasks;
    using NServiceBus;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class ResetReleaseGroupsBackToAwaitingReleaseHandler : IHandleMessages<ResetReleaseGroupsBackToAwaitingReleaseCommand>
    {
        private readonly ILogger _logger;
        private readonly IReleaseGroupService _releaseGroupService;

        public ResetReleaseGroupsBackToAwaitingReleaseHandler(ILogger logger, IReleaseGroupService releaseGroupService)
        {
            _logger = logger;
            _releaseGroupService = releaseGroupService;
        }

        public async Task Handle(ResetReleaseGroupsBackToAwaitingReleaseCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingId.ResetReleaseGroupsBackToAwaitingReleaseReceived,
                $"ResetReleaseGroupsBackToAwaitingReleaseCommand received - {message}");

            await _releaseGroupService.ResetToAwaitingReleaseAndSendSlackMessage(message.ReleaseGroupNames);
            
            _logger.LogInformation(LoggingId.ResetReleaseGroupsBackToAwaitingReleaseProcessed,
                $"ResetReleaseGroupsBackToAwaitingReleaseCommand processed - {message}");
        }
    }
}
