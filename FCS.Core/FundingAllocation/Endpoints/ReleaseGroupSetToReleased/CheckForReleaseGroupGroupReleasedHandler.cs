namespace FundingAllocation.Endpoints.ReleaseGroupSetToReleased
{
    using System.Threading.Tasks;
    using NServiceBus;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class CheckForReleaseGroupGroupReleasedHandler : IHandleMessages<CheckForReleaseGroupGroupReleased>
    {
        private readonly ILogger _logger;
        private readonly IReleaseGroupRepository _releaseGroupRepository;

        public CheckForReleaseGroupGroupReleasedHandler(ILogger logger, IReleaseGroupRepository releaseGroupRepository)
        {
            _logger = logger;
            _releaseGroupRepository = releaseGroupRepository;
        }

        public async Task Handle(CheckForReleaseGroupGroupReleased message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingId.CheckForReleaseGroupGroupReleasedReceived, $"Received CheckForReleaseGroupGroupReleased: {message}");

            var isReleaseGroupGroupReleased = await _releaseGroupRepository.IsReleaseGroupGroupReleased(message.ReleaseGroupName);

            if (isReleaseGroupGroupReleased)
            {
                var releaseGroupGroupId = await _releaseGroupRepository.GetReleaseGroupGroupId(message.ReleaseGroupName);

                await context.Publish(new FundingAllocationReleaseGroupGroupReleasedEvent(releaseGroupGroupId));
            }
            
            _logger.LogInformation(LoggingId.CheckForReleaseGroupGroupReleasedProcessed, $"Processed CheckForReleaseGroupGroupReleased: {message}, isTheReleaseGroupGroupReleased: {isReleaseGroupGroupReleased}");
        }
    }
}
