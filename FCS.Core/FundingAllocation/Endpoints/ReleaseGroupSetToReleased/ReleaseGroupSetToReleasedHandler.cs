namespace FundingAllocation.Endpoints.ReleaseGroupSetToReleased
{
    using System.Threading.Tasks;
    using NServiceBus;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class ReleaseGroupSetToReleasedHandler : IHandleMessages<ReleaseGroupSetToReleasedCommand>
    {
        private readonly ILogger _logger;
        private readonly IReleaseGroupRepository _releaseGroupRepository;
        private readonly ICrmReleaseGroupRepository _crmReleaseGroupRepository;

        public ReleaseGroupSetToReleasedHandler(ILogger logger, IReleaseGroupRepository releaseGroupRepository, ICrmReleaseGroupRepository crmReleaseGroupRepository)
        {
            _logger = logger;
            _releaseGroupRepository = releaseGroupRepository;
            _crmReleaseGroupRepository = crmReleaseGroupRepository;
        }

        public async Task Handle(ReleaseGroupSetToReleasedCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingId.ReleaseGroupSetToReleasedCommandReceived, $"Received ReleaseGroupSetToReleasedCommand: {message}");

            bool isReleased = await _releaseGroupRepository.SetToReleasedIfNotAlready(message.ReleaseGroupName);
            if (isReleased)
            {
                _logger.LogInformation(LoggingId.ReleaseGroupSetToReleasedCommandReceived, $"Setting CRM to be released: {message}");
                var crmEntityId = await _releaseGroupRepository.GetCrmEntityId(message.ReleaseGroupName);
                await _crmReleaseGroupRepository.SetToReleased(crmEntityId);
                await context.SendLocal(new CheckForReleaseGroupGroupReleased(message.ReleaseGroupName));
            }

            _logger.LogInformation(LoggingId.ReleaseGroupSetToReleasedCommandProcessed, $"Processed ReleaseGroupSetToReleasedCommand: {message}");
        }
    }
}