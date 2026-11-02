namespace FundingAllocation.Services
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using DataStore.Model;
    using Dto;
    using Extensions;
    using Repositories;

    public class PreContractControlService : IPreContractControlService
    {
        private readonly IFundingAllocationRepository _fundingAllocationRepository;
        private readonly INonMaterialCheckService _nonMaterialCheckService;
        private readonly IConfigValidationService _configValidationService;

        public PreContractControlService(
            IFundingAllocationRepository fundingAllocationRepository,
            INonMaterialCheckService nonMaterialCheckService,
            IConfigValidationService configValidationService)
        {
            _fundingAllocationRepository = fundingAllocationRepository;
            _nonMaterialCheckService = nonMaterialCheckService;
            _configValidationService = configValidationService;
        }

        public async Task<PreContractControlParkCheckResult> GetParkCheckResult(IReadOnlyCollection<string> fundingIds, int readIdToIgnore)
        {
            var fundingAllocations =
                await _fundingAllocationRepository.GetFundingAllocationsIncludingProvidersAndLines(
                    fundingIds);

            ConfigValidationResult awaitingConfigFilterResult = await _configValidationService.GetAwaitingConfigFilterResult(fundingAllocations.ToValidationInputs());

            var fundingAllocationNames = awaitingConfigFilterResult.PassedValidationFundingIds.Select(f => f.RemoveVersionFromId()).ToList();

            var fundingAllocationNamesForParkingAwaitingOutcome =
                await _fundingAllocationRepository.GetFundingAllocationNamesInContractControlWithoutOutcome(fundingAllocationNames, readIdToIgnore);

            var fundingIdsForParkingAwaitingOutcome = awaitingConfigFilterResult.PassedValidationFundingIds.Where(fId =>
                fundingAllocationNamesForParkingAwaitingOutcome.Contains(fId.RemoveVersionFromId())).ToList();

            var fundingIdsForContractControl = awaitingConfigFilterResult.PassedValidationFundingIds.WhereNotIn(fundingIdsForParkingAwaitingOutcome);

            var nonMaterialFilterCheckResult = await _nonMaterialCheckService.GetFilterCheckResult(fundingIdsForContractControl);

            var MutualExclusiveForAdultFilterCheckResult = await _nonMaterialCheckService.GetLoanFilterCheckResult(fundingIds);

            IReadOnlyCollection<FundingAllocation> fundingAllocationsForContractControl = fundingAllocations.WhereInTheseFundingIds(nonMaterialFilterCheckResult.FundingIdsForContractControl);
            fundingAllocationsForContractControl = fundingAllocationsForContractControl.WhereInTheseFundingIds(MutualExclusiveForAdultFilterCheckResult.FundingIdsForContractControl);

            return new PreContractControlParkCheckResult(
                fundingAllocationsForContractControl,
                fundingIdsForParkingAwaitingOutcome, 
                nonMaterialFilterCheckResult.FundingIdsFilteredOut,
                awaitingConfigFilterResult.AwaitingFundingAllocationConfigFundingIds,
                awaitingConfigFilterResult.AwaitingContractTypeConfigFundingIds,
                awaitingConfigFilterResult.AwaitingFundingLineCodeFundingIds,
                fundingAllocations,
                MutualExclusiveForAdultFilterCheckResult.FundingIdsFilteredOut);
        }


        public async Task<PreContractControlParkCheckResult> GetFundingIdsToBeUnParkedOnApproval(IReadOnlyCollection<string> fundingIds)
        {
            var currentlyParkedFundingIds = await _fundingAllocationRepository.GetFundingIdsForFundingNamesAndStatus(
                fundingAllocationNames: fundingIds.Select(fi => fi.RemoveVersionFromId()).ToList(),
                status: FundingAllocationStatus.Parked);

            var fundingAllocations =
                await _fundingAllocationRepository.GetFundingAllocationsIncludingProvidersAndLines(
                    currentlyParkedFundingIds);

            ConfigValidationResult awaitingConfigFilterResult = await _configValidationService.GetAwaitingConfigFilterResult(fundingAllocations.ToValidationInputs());

            var nonMaterialFilterCheckResult = await _nonMaterialCheckService.GetFilterCheckResult(awaitingConfigFilterResult.PassedValidationFundingIds);

            var MutualExclusiveForAdultFilterCheckResult = await _nonMaterialCheckService.GetLoanFilterCheckResult(fundingIds);

            return new PreContractControlParkCheckResult(
                fundingAllocations.WhereInTheseFundingIds(nonMaterialFilterCheckResult.FundingIdsForContractControl),
                fundingIdsForParkingAwaitingOutcome: Enumerable.Empty<string>().ToList(),
                fundingIdsForDiscardingNonMaterialUpdate: nonMaterialFilterCheckResult.FundingIdsFilteredOut,
                fundingIdsAwaitingFundingAllocationConfig: awaitingConfigFilterResult.AwaitingFundingAllocationConfigFundingIds,
                fundingIdsAwaitingContractTypeConfig: awaitingConfigFilterResult.AwaitingContractTypeConfigFundingIds,
                fundingIdsAwaitingFundingLineConfig: awaitingConfigFilterResult.AwaitingFundingLineCodeFundingIds,
                fundingAllocations,
                mutualExclusiveForAdultFilterCheckResult: MutualExclusiveForAdultFilterCheckResult?.FundingIdsFilteredOut);
        }

        public async Task SetStatuses(
            IReadOnlyCollection<string> fundingIdsForParkingAwaitingOutcome, 
            IReadOnlyCollection<string> fundingIdsForDiscardingNonMaterial,
            IReadOnlyCollection<string> fundingIdsAwaitingContractTypeConfig,
            IReadOnlyCollection<string> fundingIdsAwaitingFundingAllocationConfig,
            IReadOnlyCollection<string> fundingIdsAwaitingFundingLineConfig,
            IReadOnlyCollection<string> fundingIdsForContractControl,
            IReadOnlyCollection<string> mutualExclusiveForAdultFilterCheckResult = null)
        {            
            if (fundingIdsForContractControl.Any())
            {
                await _fundingAllocationRepository.SetFundingAllocationStatusSubStatus(
                    fundingIdsForContractControl,
                    FundingAllocationStatus.NotSet,
                    FundingAllocationSubStatus.NotSet);
            }

            if (fundingIdsForParkingAwaitingOutcome.Any())
            {
                await _fundingAllocationRepository.SetFundingAllocationsParkedSubStatus(
                    fundingIdsForParkingAwaitingOutcome, FundingAllocationSubStatus.AwaitingOutcome);
            }

            if (fundingIdsForDiscardingNonMaterial.Any())
            {
                await _fundingAllocationRepository.SetFundingAllocationStatusSubStatus(fundingIdsForDiscardingNonMaterial,
                    FundingAllocationStatus.Discarded, FundingAllocationSubStatus.NonMaterialUpdate);
                await _fundingAllocationRepository.InsertOrUpdateParkingInfoLastDiscarded(fundingIdsForDiscardingNonMaterial, DateTime.Now);
            }

            if (mutualExclusiveForAdultFilterCheckResult != null)
            {
                if (mutualExclusiveForAdultFilterCheckResult.Any())
                {
                    await _fundingAllocationRepository.SetFundingAllocationStatusSubStatus(mutualExclusiveForAdultFilterCheckResult,
                        FundingAllocationStatus.Discarded, FundingAllocationSubStatus.NonMutualExclusive);
                    await _fundingAllocationRepository.InsertOrUpdateParkingInfoLastDiscarded(mutualExclusiveForAdultFilterCheckResult, DateTime.Now);
                }
            }

            await _fundingAllocationRepository.SetFundingAllocationsParkedSubStatus(
                fundingIdsAwaitingContractTypeConfig, FundingAllocationSubStatus.AwaitingContractTypeConfig);

            await _fundingAllocationRepository.SetFundingAllocationsParkedSubStatus(
                fundingIdsAwaitingFundingAllocationConfig, FundingAllocationSubStatus.AwaitingFundingAllocationConfig);

            await _fundingAllocationRepository.SetFundingAllocationsParkedSubStatus(
                fundingIdsAwaitingFundingLineConfig, FundingAllocationSubStatus.AwaitingFundingLineConfig);
        }
    }
}
