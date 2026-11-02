namespace SFA.FCT.PerformanceManagementDomain.FundingClaimImportEndpoint.Handlers
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim;
    using CrossDomain.Integration.Events;
    using DataStore.Repositories;
    using Framework.Logging.Interfaces;
    using NServiceBus;
    using Services;
    using Common.Commands;
    using Common.Logging;

    public class ProcessFundingClaimsHandler : IHandleMessages<ProcessFundingClaimsCommand>
    {
        private readonly ILogger _logger;
        private readonly IFundingClaimDebatchService _fundingClaimDebatchService;
        private readonly IFundingClaimRepository _fundingClaimRepository;

        public ProcessFundingClaimsHandler(ILogger logger, IFundingClaimDebatchService fundingClaimDebatchService, IFundingClaimRepository fundingClaimRepository)
        {
            _logger = logger;
            _fundingClaimDebatchService = fundingClaimDebatchService;
            _fundingClaimRepository = fundingClaimRepository;
        }

        public async Task Handle(ProcessFundingClaimsCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(PerformanceManagementLoggingId.StartProcessingFundingClaims, "Beginning handler to process funding claims - " + message);

            List<FundingClaim> fundingClaims = _fundingClaimRepository.RetrieveAllFundingClaimsForPeriodAndClaimType(message.Period, message.ClaimTypeName);

            List<IEnumerable<DebatchedFundingClaim>> allDebatchedFundingClaims = fundingClaims
                .Select(_fundingClaimDebatchService.DebatchFundingClaimByAllocationGroup)
                .ToList();

            foreach (var debatchedFundingClaimCollection in allDebatchedFundingClaims)
            {
                await PublishDebatchedFundingClaims(debatchedFundingClaimCollection, context)
                    .ConfigureAwait(false);
            }

            _logger.LogInformation(PerformanceManagementLoggingId.FinishProcessingFundingClaims, "Finished processing funding claims" + message);
        }

        private async Task PublishDebatchedFundingClaims(IEnumerable<DebatchedFundingClaim> debatchedFundingClaims, IMessageHandlerContext context)
        {
            foreach(DebatchedFundingClaim fc in debatchedFundingClaims)
            {
                await context.Publish<FundingClaimDebatchedEvent>(x =>
                {
                    x.DebatchedFundingClaim = fc;
                }).ConfigureAwait(false);
            };
        }
    }
}