namespace SFA.FCT.ContractRequestDomain.Integration.BulkUpload.FundingAllocationRelease.Handlers
{
    using System.Threading.Tasks;
    using CrossDomain.Integration.Events;
    using Framework.Logging.Interfaces;
    using NServiceBus;
    using Repositories;
    using Common;

    public class FundingAllocationReleaseGroupGroupReleasedHandler : IHandleMessages<FundingAllocationReleaseGroupGroupReleasedEvent>
    {
        private readonly ILogger _logger;
        private readonly IFundingAllocationReleaseRepository _fundingAllocationReleaseRepository;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;

        public FundingAllocationReleaseGroupGroupReleasedHandler(ILogger logger, IFundingAllocationReleaseRepository fundingAllocationReleaseRepository, ISessionConnectionFactory sessionConnectionFactory)
        {
            _logger = logger;
            _fundingAllocationReleaseRepository = fundingAllocationReleaseRepository;
            _sessionConnectionFactory = sessionConnectionFactory;
        }

        public async Task Handle(FundingAllocationReleaseGroupGroupReleasedEvent message, IMessageHandlerContext context)
        {
            _logger.LogInformation(ContractRequestDomainEventLoggingId.FundingAllocationReleasedEventReceived, $"Received FundingAllocationReleaseGroupGroupReleasedEvent: {message}");
            var connectionInfo = _sessionConnectionFactory.GetConnection(context);

            await _fundingAllocationReleaseRepository.SetToReleased(message.ReleaseGroupGroupId, 
                connectionInfo);

            _logger.LogInformation(ContractRequestDomainEventLoggingId.FundingAllocationReleasedEventProcessed, $"Processed FundingAllocationReleaseGroupGroupReleasedEvent: {message}");
        }
    }
}
