namespace FundingAllocation.Dto
{
    using System.Collections.Generic;
    using System.Linq;
    using DataStore.Model;
    using Extensions;

    public class PreContractControlParkCheckResult
    {
        public PreContractControlParkCheckResult(
            IReadOnlyCollection<FundingAllocation> fundingAllocationsForContractControl,
            IReadOnlyCollection<string> fundingIdsForParkingAwaitingOutcome,
            IReadOnlyCollection<string> fundingIdsForDiscardingNonMaterialUpdate, 
            IReadOnlyCollection<string> fundingIdsAwaitingFundingAllocationConfig, 
            IReadOnlyCollection<string> fundingIdsAwaitingContractTypeConfig, 
            IReadOnlyCollection<string> fundingIdsAwaitingFundingLineConfig,
            IReadOnlyCollection<FundingAllocation> allFundingAllocations,
            IReadOnlyCollection<string> mutualExclusiveForAdultFilterCheckResult)
        {
            FundingAllocationsForContractControl = fundingAllocationsForContractControl;
            FundingIdsForParkingAwaitingOutcome = fundingIdsForParkingAwaitingOutcome;
            FundingIdsForDiscardingNonMaterialUpdate = fundingIdsForDiscardingNonMaterialUpdate;
            FundingIdsAwaitingFundingAllocationConfig = fundingIdsAwaitingFundingAllocationConfig;
            FundingIdsAwaitingContractTypeConfig = fundingIdsAwaitingContractTypeConfig;
            FundingIdsAwaitingFundingLineConfig = fundingIdsAwaitingFundingLineConfig;
            AllFundingAllocations = allFundingAllocations;
            MutualExclusiveForAdultFilterCheckResult = mutualExclusiveForAdultFilterCheckResult;
        }

        public IReadOnlyCollection<FundingAllocation> FundingAllocationsForContractControl { get; }
        public IReadOnlyCollection<string> FundingIdsForParkingAwaitingOutcome { get; }
        public IReadOnlyCollection<string> FundingIdsForDiscardingNonMaterialUpdate { get; }
        public IReadOnlyCollection<string> FundingIdsAwaitingFundingAllocationConfig { get; }
        public IReadOnlyCollection<string> FundingIdsAwaitingContractTypeConfig { get; }
        public IReadOnlyCollection<string> FundingIdsAwaitingFundingLineConfig { get; }
        public IReadOnlyCollection<string> MutualExclusiveForAdultFilterCheckResult { get; }
        public IReadOnlyCollection<string> FundingIdsForContractControl =>
            FundingAllocationsForContractControl.GetValueOrEmpty().Select(fa => fa.FundingId).ToList();
        public IReadOnlyCollection<FundingAllocation> AllFundingAllocations { get; }

        public bool IsValid(string fundingId) => FundingAllocationsForContractControl.GetValueOrEmpty()
            .Any(fa => fa.FundingId == fundingId);

        public override string ToString() =>
            $"FundingIdsForContractControl: {FundingAllocationsForContractControl.Count}," + 
            $"FundingIdsForParkingAwaitingOutcome: {FundingIdsForParkingAwaitingOutcome.Count}," +
            $"FundingIdsForDiscardingNonMaterialUpdate: {FundingIdsForDiscardingNonMaterialUpdate.Count}, " +
            $"FundingIdsAwaitingFundingAllocationConfig: {FundingIdsAwaitingFundingAllocationConfig.Count}, " +
            $"FundingIdsAwaitingContractTypeConfig: {FundingIdsAwaitingContractTypeConfig.Count}, " +
            $"FundingIdsAwaitingFundingLineConfig: {FundingIdsAwaitingFundingLineConfig.Count}," +
            $"MutualExclusiveForAdultFilterCheckResult: {MutualExclusiveForAdultFilterCheckResult.Count},";

        public List<string> GetFundingAllocationNames()
        {
            IReadOnlyCollection<IReadOnlyCollection<string>> fundingIdLists = new List<IReadOnlyCollection<string>>
            {
                FundingIdsForParkingAwaitingOutcome,
                FundingIdsForDiscardingNonMaterialUpdate,
                FundingIdsAwaitingFundingAllocationConfig,
                FundingIdsAwaitingContractTypeConfig,
                FundingIdsAwaitingFundingLineConfig
            };

            var fundingNames  = fundingIdLists.SelectMany(fundingIdList => fundingIdList.Select(fId => fId.RemoveVersionFromId()))
                .ToList();

            fundingNames.AddRange(FundingAllocationsForContractControl
                .Select(fa => fa.FundingAllocationName).ToList());

            return fundingNames;
        }

        public string GetParkedAwaitingConfigSubStatus(string fundingId)
        {
            if (FundingIdsAwaitingFundingAllocationConfig.Any(fi => fi == fundingId))
            {
                return FundingAllocationSubStatus.AwaitingFundingAllocationConfig.ToString();
            }
            if (FundingIdsAwaitingContractTypeConfig.Any(fi => fi == fundingId))
            {
                return FundingAllocationSubStatus.AwaitingContractTypeConfig.ToString();
            }
            if (FundingIdsAwaitingFundingLineConfig.Any(fi => fi == fundingId))
            {
                return FundingAllocationSubStatus.AwaitingFundingLineConfig.ToString();
            }
            return string.Empty;
        }
    }
}
