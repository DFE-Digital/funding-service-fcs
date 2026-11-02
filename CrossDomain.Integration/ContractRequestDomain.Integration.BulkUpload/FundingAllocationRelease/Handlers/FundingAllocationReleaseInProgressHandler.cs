namespace SFA.FCT.ContractRequestDomain.Integration.BulkUpload.FundingAllocationRelease.Handlers
{
    using System.Threading.Tasks;
    using Common;
    using CrossDomain.Integration.Events;
    using Framework.Logging.Interfaces;
    using NServiceBus;
    using Repositories;

    public class FundingAllocationReleaseInProgressHandler : IHandleMessages<FundingAllocationReleaseInProgressEvent>
    {
        private readonly ILogger _logger;
        private readonly IFundingAllocationReleaseRepository _fundingAllocationReleaseRepository;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;

        public FundingAllocationReleaseInProgressHandler(
            ILogger logger,
            IFundingAllocationReleaseRepository fundingAllocationReleaseRepository,
            ISessionConnectionFactory sessionConnectionFactory)
        {
            _logger = logger;
            _fundingAllocationReleaseRepository = fundingAllocationReleaseRepository;
            _sessionConnectionFactory = sessionConnectionFactory;
        }

        public async Task Handle(FundingAllocationReleaseInProgressEvent message, IMessageHandlerContext context)
        {
            _logger.LogInformation(ContractRequestDomainEventLoggingId.FundingAllocationReleaseInProgressEventReceived, $"Received FundingAllocationReleaseInProgressEvent: {message}");
            var connectionInfo = _sessionConnectionFactory.GetConnection(context);

            await _fundingAllocationReleaseRepository.SetToReleaseInProgress(message.ReleaseGroupGroupId,
                message.FundingTypeCode, message.FundingPeriodName, connectionInfo);

            _logger.LogInformation(ContractRequestDomainEventLoggingId.FundingAllocationReleaseInProgressEventProcessed, $"Processed FundingAllocationReleaseInProgressEvent: {message}");
        }
    }
}
