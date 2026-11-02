namespace FundingAllocation.Services
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using Dto;

    public interface IPreContractControlService
    {
        Task<PreContractControlParkCheckResult> GetParkCheckResult(IReadOnlyCollection<string> fundingIds, int readIdToIgnore);

        Task<PreContractControlParkCheckResult> GetFundingIdsToBeUnParkedOnApproval(IReadOnlyCollection<string> fundingIds);

        Task SetStatuses(
            IReadOnlyCollection<string> fundingIdsForParkingAwaitingOutcome,
            IReadOnlyCollection<string> fundingIdsForDiscardingNonMaterial,
            IReadOnlyCollection<string> fundingIdsAwaitingContractTypeConfig,
            IReadOnlyCollection<string> fundingIdsAwaitingFundingAllocationConfig,
            IReadOnlyCollection<string> fundingIdsAwaitingFundingLineConfig,
            IReadOnlyCollection<string> fundingIdsForContractControl,
            IReadOnlyCollection<string> mutualExclusiveForAdultFilterCheckResult);
    }
}