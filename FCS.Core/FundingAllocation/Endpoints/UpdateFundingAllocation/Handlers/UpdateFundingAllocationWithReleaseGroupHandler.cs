namespace FundingAllocation.Endpoints.UpdateFundingAllocation
{
    using System.Threading.Tasks;
    using NServiceBus;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class UpdateFundingAllocationWithReleaseGroupHandler : IHandleMessages<UpdateFundingAllocationWithReleaseGroupCommand>
    {
        private readonly IFundingAllocationRepository _fundingAllocationRepository;
        private readonly ILogger _logger;

        public UpdateFundingAllocationWithReleaseGroupHandler(IFundingAllocationRepository fundingAllocationRepository, ILogger logger)
        {
            _fundingAllocationRepository = fundingAllocationRepository;
            _logger = logger;
        }

        public async Task Handle(UpdateFundingAllocationWithReleaseGroupCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingId.UpdateFundingAllocationWithReleaseGroupCommandReceived, $"Processing UpdateFundingAllocationWithReleaseGroupCommand - {message}");

            await _fundingAllocationRepository.UpdateReleaseGroupOnFundingAllocation(message.FundingId,
                message.ReleaseGroupId);

            _logger.LogInformation(LoggingId.UpdateFundingAllocationWithReleaseGroupCommandProcessed, $"Processed UpdateFundingAllocationWithReleaseGroupCommand - {message}");
        }
    }
}
