namespace PerformanceManagementDomain.PullFundingClaim.Handlers
{
    using System.Linq;
    using System.Threading.Tasks;
    using Extensions;
    using Infrastructure;
    using NServiceBus;
    using Repositories;
    using Services;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.PerformanceManagementDomain.Common.Commands;
    using SFA.FCT.PerformanceManagementDomain.Common.Logging;

    public class BeginPullOfFundingClaimsForClosedCollectionHandler : IHandleMessages<BeginPullOfFundingClaimsForClosedCollectionCommand>
    {
        private readonly ILogger _logger;
        private readonly IFundingClaimsApiAdapter _fundingClaimsApiAdapter;
        private readonly IFundingClaimImportInfoRepository _fundingClaimImportInfoRepository;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;
        private readonly IClaimReconciliationBehaviourAsyncRepository _claimReconciliationBehaviourRepository;

        public BeginPullOfFundingClaimsForClosedCollectionHandler(
            ILogger logger,
            IFundingClaimsApiAdapter fundingClaimsApiAdapter,
            IFundingClaimImportInfoRepository fundingClaimImportInfoRepository,
            ISessionConnectionFactory sessionConnectionFactory,
            IClaimReconciliationBehaviourAsyncRepository claimReconciliationBehaviourRepository)
        {
            _logger = logger;
            _fundingClaimsApiAdapter = fundingClaimsApiAdapter;
            _fundingClaimImportInfoRepository = fundingClaimImportInfoRepository;
            _sessionConnectionFactory = sessionConnectionFactory;
            _claimReconciliationBehaviourRepository = claimReconciliationBehaviourRepository;
        }

        public async Task Handle(BeginPullOfFundingClaimsForClosedCollectionCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(
                PerformanceManagementLoggingId.BeginPullOfFundingClaimsForClosedCollectionCommandArrived,
                $"BeginPullOfFundingClaimsForClosedCollectionCommand arrived :{message}");
            
            var connectionInfo = _sessionConnectionFactory.GetConnection(context);

            int totalRows = await _fundingClaimsApiAdapter.GetCountOfFundingClaimsForCollectionKey(message.PeriodClaimType);

            _logger.LogInformation(
                PerformanceManagementLoggingId.FundingClaimsForCollectionCount,
                $"BeginPullOfFundingClaimsForClosedCollectionCommand {message}, total rows:{totalRows}");

            if (totalRows > 0 && await _claimReconciliationBehaviourRepository.DoesClaimCollectionCodeExist(message.PeriodClaimType, connectionInfo))
            {
                var totalPages = _fundingClaimsApiAdapter.GetNumberOfPagesRequired(totalRows);
                await _fundingClaimImportInfoRepository.Add(message.PeriodClaimType, totalRows, connectionInfo);

                var sendTasks = Enumerable.Range(1, totalPages)
                    .Select(pageNumber => PullPageForPeriodClaimTypeCommand.Create(message.PeriodClaimType, pageNumber))
                    .Select(context.SendLocal);

                await Task.WhenAll(sendTasks);
            }

            _logger.LogInformation(
                PerformanceManagementLoggingId.BeginPullOfFundingClaimsForClosedCollectionCommandProcessed,
                $"BeginPullOfFundingClaimsForClosedCollectionCommand processed :{message}");
        }
    }
}
