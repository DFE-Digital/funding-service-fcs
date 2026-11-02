namespace PerformanceManagementDomain.ReconciliationCalculationEndpoint.Handlers
{
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation;
    using SFA.FCT.Framework.Logging.Interfaces;
    using NServiceBus;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Events;
    using System.Threading.Tasks;
    using SFA.FCT.PerformanceManagementDomain.Common.Logging;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using Infrastructure;

    public class FundingClaimDebatchedEventHandler : IHandleMessages<FundingClaimDebatchedEvent>
    {
        private readonly ILogger _logger;
        private readonly ICalculationService _calculationService;
        private readonly IFundingClaimEnrichmentService _fundingClaimEnrichmentService;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;

        public FundingClaimDebatchedEventHandler(ILogger logger,
            ICalculationService calculationService,
            IFundingClaimEnrichmentService fundingClaimEnrichmentService,
            ISessionConnectionFactory sessionConnectionFactory)
        {
            _logger = logger;
            _calculationService = calculationService;
            _fundingClaimEnrichmentService = fundingClaimEnrichmentService;
            _sessionConnectionFactory = sessionConnectionFactory;
        }

        public async Task Handle(FundingClaimDebatchedEvent message, IMessageHandlerContext context)
        {
                _logger.LogInformation(PerformanceManagementLoggingId.StartFundingClaimReconcilationCalculation,
                    "Beginning handler to FundingClaimDebatched Event. - " + message.DebatchedFundingClaim);

                ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

                await _fundingClaimEnrichmentService.Enrich(message.DebatchedFundingClaim, connectionInfo).ConfigureAwait(continueOnCapturedContext: false);

                FundingClaimReconciliation fundingClaimReconciliation = await _calculationService.Calculate(
                        message.DebatchedFundingClaim, connectionInfo)
                    .ConfigureAwait(continueOnCapturedContext: false);

                await context.Publish<ProposedReconciliationCalculatedEvent>(e =>
                    {
                        e.FundingClaimReconciliation = fundingClaimReconciliation;
                    })
                    .ConfigureAwait(continueOnCapturedContext: false);

                _logger.LogInformation(PerformanceManagementLoggingId.FinishFundingClaimReconcilationCalculation,
                    "Finished handler to FundingClaimDebatched Event. - " + message.DebatchedFundingClaim);
        }
    }
}