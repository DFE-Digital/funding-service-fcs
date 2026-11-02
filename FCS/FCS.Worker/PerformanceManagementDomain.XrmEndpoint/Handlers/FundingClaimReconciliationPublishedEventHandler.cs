namespace PerformanceManagementDomain.XrmEndpoint.Handlers
{
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Logging;
    using System.Threading.Tasks;
    using Repositories;

    public class FundingClaimReconciliationPublishedEventHandler : IHandleMessages<FundingClaimReconciliationPublishedEvent>,
                                                                   IHandleMessages<FundingClaimReconciliationFailedPublicationEvent>
    {
        private readonly ILogger _logger;
        private readonly IFundingClaimReconciliationCommandRepository _fundingClaimReconciliationCommandRepository;

        public FundingClaimReconciliationPublishedEventHandler(ILogger logger, IFundingClaimReconciliationCommandRepository fundingClaimReconciliationCommandRepository)
        {
            _logger = logger;
            _fundingClaimReconciliationCommandRepository = fundingClaimReconciliationCommandRepository;
        }

        public Task Handle(FundingClaimReconciliationPublishedEvent message, IMessageHandlerContext context)
        {
            _logger.LogInformation(PerformanceManagementLoggingId.StartPublishFundingClaimReconciliation,
                $"Beginning FCR XRMEndpoint FundingClaimReconciliationPublishedEvent handler to process FundingClaim: {message.FundingClaimReconciliationName}");

            if (message.IsForManualPublication)
            {
                _fundingClaimReconciliationCommandRepository
                    .SetStatusOfFundingClaimReconciliationToManuallyPublished(message.FundingClaimReconciliationId, message.PublishedDate);
            }
            else
            {
                _fundingClaimReconciliationCommandRepository
                    .SetStatusOfFundingClaimReconciliationToPublished(message.FundingClaimReconciliationId, message.PublishedDate);
            }

            _logger.LogInformation(PerformanceManagementLoggingId.FinishPublishFundingClaimReconciliation,
                $"Finished FCR XRMEndpoint FundingClaimReconciliationPublishedEvent handler for FundingClaim: {message.FundingClaimReconciliationName}");

            return Task.CompletedTask;
        }
        public Task Handle(FundingClaimReconciliationFailedPublicationEvent message, IMessageHandlerContext context)
        {
            _logger.LogInformation(PerformanceManagementLoggingId.StartPublicationOfFundingClaimReconciliationFailed,
                $"Beginning FCR XRMEndpoint IFundingClaimReconciliationFailedPublicationEvent Name: {message.FundingClaimReconciliationName}");

            _fundingClaimReconciliationCommandRepository
                .SetStatusOfFundingClaimReconciliationToPublishFailed(message.FundingClaimReconciliationId, message.OccurredOnDate, message.FailureReason);

            _logger.LogInformation(PerformanceManagementLoggingId.FinishedPublicationOfFundingClaimReconciliationFailed,
                $"Finished FCR XRMEndpoint IFundingClaimReconciliationFailedPublicationEvent Name: {message.FundingClaimReconciliationName}");

            return Task.CompletedTask;
        }
    }
}