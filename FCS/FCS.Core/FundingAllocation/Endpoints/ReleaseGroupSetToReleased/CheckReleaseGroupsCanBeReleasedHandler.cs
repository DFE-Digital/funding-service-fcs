namespace FundingAllocation.Endpoints.ReleaseGroupSetToReleased
{
    using System.Linq;
    using System.Threading.Tasks;
    using FundingAllocation.Repositories;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class CheckReleaseGroupsCanBeReleasedHandler : IHandleMessages<CheckReleaseGroupsCanBeReleasedCommand>
    {
        private readonly ILogger _logger;
        private readonly IFundingAllocationRepository _fundingAllocationRepository;

        public CheckReleaseGroupsCanBeReleasedHandler(ILogger logger, IFundingAllocationRepository fundingAllocationRepository)
        {
            _logger = logger;
            _fundingAllocationRepository = fundingAllocationRepository;
        }

        public async Task Handle(CheckReleaseGroupsCanBeReleasedCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingId.CheckReleaseGroupsCanBeReleasedCommandReceived, $"Received CheckReleaseGroupsCanBeReleasedCommand: {message}");

            var releaseGroupsToBeSetToReleased = await
                _fundingAllocationRepository.GetReleaseGroupsThatCanNowBeSetToReleased(message.FundingAllocationIds, message.ReleaseGroupId);

            var sendTasks = releaseGroupsToBeSetToReleased.Select(rg => context.SendLocal(new ReleaseGroupSetToReleasedCommand(rg)));

            await Task.WhenAll(sendTasks);

            _logger.LogInformation(LoggingId.CheckReleaseGroupsCanBeReleasedCommandProcessed, $"Processed CheckReleaseGroupsCanBeReleasedCommand: {message}");
        }
    }
}
