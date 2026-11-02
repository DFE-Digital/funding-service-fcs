namespace PerformanceManagementDomain.ReconciliationCalculationEndpoint.Handlers
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using SFA.FCT.PerformanceManagementDomain.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation;
    using NServiceBus;
    using Services;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.PerformanceManagementDomain.Common.Logging;
    using System.Threading.Tasks;
    using PerformanceManagementDomain.Services;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using Infrastructure;
    using FundingClaimRepository = Repositories.FundingClaimRepository;
    using Repositories;

    public class RecalculateFundingClaimReconciliationCommandHandler : IHandleMessages<RecalculateFundingClaimReconciliationCommand>,
        IHandleMessages<RecalculateFcrOnCappedClaimAdjustmentCommand>
    {
        private readonly IFundingClaimRepository _fundingClaimRepository;
        private readonly IFundingClaimDebatchService _fundingClaimDebatchService;
        private readonly ICalculationService _calculationService;
        private readonly IFcrUpdateService _fcrUpdateService;
        private readonly IFundingClaimEnrichmentService _fundingClaimEnrichmentService;
        private readonly ILogger _logger;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;

        public RecalculateFundingClaimReconciliationCommandHandler(ICalculationService calculationService,
            IFundingClaimRepository fundingClaimRepository,
            IFundingClaimDebatchService fundingClaimDebatchService,
            IFcrUpdateService fcrUpdateService,
            IFundingClaimEnrichmentService fundingClaimEnrichmentService,
            ILogger logger,
            ISessionConnectionFactory sessionConnectionFactory)
        {
            _calculationService = calculationService;
            _fundingClaimRepository = fundingClaimRepository;
            _fundingClaimDebatchService = fundingClaimDebatchService;
            _fcrUpdateService = fcrUpdateService;
            _fundingClaimEnrichmentService = fundingClaimEnrichmentService;
            _logger = logger;
            _sessionConnectionFactory = sessionConnectionFactory;
        }

        public async Task Handle(RecalculateFundingClaimReconciliationCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(PerformanceManagementLoggingId.StartRecalculationOfFundingClaimReconciliation, $"Starting Recalculation of funding claim with natural key : {message}");

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            FundingClaimRepository.FundingClaimNaturalKey naturalKey = GetFundingClaimNaturalKeyFromMessage(message.OrganisationIdentifier, message.VersionNumber, message.ClaimTypeName, message.PeriodTypeCode, message.Period);

            var debatchedFundingClaimList = await CreateDebatchedFundingClaims(naturalKey, connectionInfo).ConfigureAwait(continueOnCapturedContext: false);
            DebatchedFundingClaim debatchedFundingClaim = debatchedFundingClaimList.Single(dfc => dfc.AllocationGroupCode == message.AllocationGroupCode);

            FundingClaimReconciliation fundingClaimReconciliation = await _calculationService.Calculate(
                    debatchedFundingClaim, connectionInfo, message.CappedClaimAdjustment)
                .ConfigureAwait(continueOnCapturedContext: false);

            _fcrUpdateService.UpdateFundingClaimReconciliationInCrm(fundingClaimReconciliation.Amounts, fundingClaimReconciliation.ContractAllocations, message.FcrCrmId);

            _logger.LogInformation(PerformanceManagementLoggingId.FinishRecalculationOfFundingClaimReconciliation, $"Finished Recalculation of funding claim with natural key : {message}");
        }

        public async Task Handle(RecalculateFcrOnCappedClaimAdjustmentCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(PerformanceManagementLoggingId.StartRecalculationOfFundingClaimReconciliation, $"Starting RecalculateFcrOnCappedClaimAdjustment : {message}");

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            FundingClaimRepository.FundingClaimNaturalKey naturalKey = GetFundingClaimNaturalKeyFromMessage(message.OrganisationIdentifier, message.VersionNumber, message.ClaimTypeName, message.PeriodTypeCode, message.Period);

            var debatchedFundingClaimList = await CreateDebatchedFundingClaims(naturalKey, connectionInfo).ConfigureAwait(continueOnCapturedContext: false);

            DebatchedFundingClaim debatchedFundingClaim = debatchedFundingClaimList.Single(dfc => dfc.AllocationGroupCode == message.AllocationGroupCode);

            FundingClaimReconciliation fundingClaimReconciliation = await _calculationService.Calculate(
                    debatchedFundingClaim, connectionInfo, message.CappedClaimAdjustment, message.EarningsBoostValue)
                .ConfigureAwait(continueOnCapturedContext: false);

            decimal? reconciliationValue = fundingClaimReconciliation.Amounts.ProposedReconciliationValue; 
            if (message.EarningsBoostValue != null && message.EarningsBoostValue != 0)
            {
                reconciliationValue = fundingClaimReconciliation.Amounts.ProposedReconciliationValue + message.EarningsBoostValue;
            }
            if (message.ShouldUpdateFinalReconciliation)
            {
                _fcrUpdateService.UpdateFundingClaimReconciliationInCrm(
                    adjustedCappedClaimValue: fundingClaimReconciliation.Amounts.AdjustedCappedClaimValue,
                    claimAdjustmentValue: message.CappedClaimAdjustment,
                    proposedReconciliationValue: fundingClaimReconciliation.Amounts.ProposedReconciliationValue,
                    reconciliationValue: reconciliationValue,
                    earningsBoostValue: message.EarningsBoostValue,
                    fcrCrmId: message.FcrCrmId);
            }
            else
            {
                _fcrUpdateService.UpdateFcrAdjustedCappedClaimValueInCrm(
                    adjustedCappedClaimValue: fundingClaimReconciliation.Amounts.AdjustedCappedClaimValue,
                    claimAdjustmentValue: message.CappedClaimAdjustment,
                    proposedReconciliationValue: fundingClaimReconciliation.Amounts.ProposedReconciliationValue,
                    earningsBoostValue: message.EarningsBoostValue,
                    fcrCrmId: message.FcrCrmId);
            }

            _logger.LogInformation(PerformanceManagementLoggingId.FinishRecalculationOfFundingClaimReconciliation, $"Finished RecalculateFcrOnCappedClaimAdjustment : {message}");
        }

        private static FundingClaimRepository.FundingClaimNaturalKey GetFundingClaimNaturalKeyFromMessage(string organisationIdentifier, int versionNumber, string claimType, string periodTypeCode, string period)
        {
            return new FundingClaimRepository.FundingClaimNaturalKey
            {
                OrganisationIdentifier = organisationIdentifier,
                VersionNumber = versionNumber,
                ClaimTypeName = getClaimTypeName(claimType),
                PeriodTypeCode = periodTypeCode,
                Period = period
            };
        }

        private static FundingClaimRepository.ClaimTypeNames getClaimTypeName(string claimTypeName)
        {
            return (FundingClaimRepository.ClaimTypeNames) Enum.Parse(typeof(FundingClaimRepository.ClaimTypeNames), claimTypeName.Replace(" ", string.Empty), true);
        }

        private async Task<IEnumerable<DebatchedFundingClaim>> CreateDebatchedFundingClaims(FundingClaimRepository.FundingClaimNaturalKey naturalKey, ConnectionInfo connectionInfo)
        {
            FundingClaim fundingClaim = await _fundingClaimRepository.GetFundingClaimByNaturalKey(naturalKey, connectionInfo)
                .ConfigureAwait(continueOnCapturedContext: false);

            await _fundingClaimEnrichmentService.Enrich(fundingClaim, connectionInfo).ConfigureAwait(continueOnCapturedContext: false);

            IEnumerable<DebatchedFundingClaim> debatchedFundingClaims = await _fundingClaimDebatchService
                .DebatchFundingClaimByAllocationGroup(fundingClaim, connectionInfo)
                .ConfigureAwait(continueOnCapturedContext: false);

            return debatchedFundingClaims;
        }
    }
}