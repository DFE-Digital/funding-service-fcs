namespace PerformanceManagementDomain.PullFundingClaim.Handlers
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Infrastructure;
    using NServiceBus;
    using Repositories;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.PerformanceManagementDomain.Common.Commands;
    using SFA.FCT.PerformanceManagementDomain.Common.Logging;

    public class BeginFundingClaimPullHandler :
        IHandleMessages<BeginFundingClaimPullCommand>
    {
        private readonly ILogger _logger;
        private readonly IFundingClaimsApiAdapter _fundingClaimsApiAdapter;
        private readonly IFundingClaimImportInfoRepository _fundingClaimImportInfoRepository;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;

        public BeginFundingClaimPullHandler(
            ILogger logger,
            IFundingClaimsApiAdapter fundingClaimsApiAdapter,
            IFundingClaimImportInfoRepository fundingClaimImportInfoRepository,
            ISessionConnectionFactory sessionConnectionFactory)
        {
            _logger = logger;
            _fundingClaimsApiAdapter = fundingClaimsApiAdapter;
            _fundingClaimImportInfoRepository = fundingClaimImportInfoRepository;
            _sessionConnectionFactory = sessionConnectionFactory;
        }

        public async Task Handle(BeginFundingClaimPullCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(
                PerformanceManagementLoggingId.FundingClaimPollingPollClosedCollectionsCommandArrived,
                $"BeginFundingClaimPullCommand arrived, starting pulling from SLD");

            var connectionInfo = _sessionConnectionFactory.GetConnection(context);

            var lastCompletedImportDate = await _fundingClaimImportInfoRepository.GetLastCompletedImportDateOrDefault(connectionInfo);

            _logger.LogInformation(
                PerformanceManagementLoggingId.FundingClaimPollingUsingLastClosedCollectionTime,
                $"Determined last closed collection time of {lastCompletedImportDate}");

            IReadOnlyCollection<string> completedCollections = await _fundingClaimsApiAdapter.GetFundingClaimCompletedCollections(lastCompletedImportDate);

            var sendTasks = completedCollections.Select(BeginPullOfFundingClaimsForClosedCollectionCommand.Create)
                                    .Select(context.SendLocal)
                                    .ToList();

            await Task.WhenAll(sendTasks);

            _logger.LogInformation(
                PerformanceManagementLoggingId.FundingClaimPollingPollClosedCollectionsCommandProcessed,
                $"BeginFundingClaimPullCommand processed");
        }
    }
}
