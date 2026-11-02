namespace SFA.FCT.PerformanceManagementDomain.FundingClaimImportEndpoint.Services
{
    using System.Collections.Concurrent;
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim;
    using DataStore.Models;
    using DataStore.Repositories;
    using FundingClaim = CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim.FundingClaim;

    public class FundingClaimDebatchService : IFundingClaimDebatchService
    {
        private readonly IClaimReconciliationAllocationGroupFspRepository _reconAllocGroupRepository;
        private readonly ConcurrentDictionary<string, ClaimReconciliationAllocationGroupFsp> _claimReconciliationAllocationGroupFsps = new ConcurrentDictionary<string, ClaimReconciliationAllocationGroupFsp>();

        public FundingClaimDebatchService(IClaimReconciliationAllocationGroupFspRepository reconAllocGroupRepository)
        {
            _reconAllocGroupRepository = reconAllocGroupRepository;
        }

        public IEnumerable<DebatchedFundingClaim> DebatchFundingClaimByAllocationGroup(FundingClaim fundingClaimToDebatch)
        {
            var groupedAllocationGroups = GetAllocationGroupsForFundingClaim(fundingClaimToDebatch).GroupBy(x => x.ClaimReconciliationAllocationGroupCode);

            return groupedAllocationGroups.Select(group => TransformToDebatchedFundingClaim(allocationGroupCode: group.Key, allocationGroupFsps: group, fundingClaimToDebatch: fundingClaimToDebatch));
        }

        private DebatchedFundingClaim TransformToDebatchedFundingClaim(
            string allocationGroupCode,
            IEnumerable<ClaimReconciliationAllocationGroupFsp> allocationGroupFsps,
            FundingClaim fundingClaimToDebatch)
        {
            DebatchedFundingClaim debatchedFundingClaim = new DebatchedFundingClaim
            {
                AllocationGroupCode = allocationGroupCode,
                ClaimTypeName = fundingClaimToDebatch.ClaimTypeName,
                HasBeenSigned = fundingClaimToDebatch.HasBeenSigned,
                Period = fundingClaimToDebatch.Period,
                PeriodTypeCode = fundingClaimToDebatch.PeriodTypeCode,
                Contractor = fundingClaimToDebatch.Contractor,
                VersionNumber = fundingClaimToDebatch.VersionNumber,
                ContractAllocations = CreateAllocationsAssociatedWithAllocationGroup(fundingClaimToDebatch.ContractAllocations, allocationGroupFsps)
            };

            return debatchedFundingClaim;
        }

        private static List<ContractAllocation> CreateAllocationsAssociatedWithAllocationGroup(List<ContractAllocation> contractAllocations, IEnumerable<ClaimReconciliationAllocationGroupFsp> allocationGroupFsps)
        {
            return allocationGroupFsps
                .Select(allocGroup => contractAllocations.Single(a => a.FundingStreamPeriodCode == allocGroup.FspCode)).ToList();
        }

        private List<ClaimReconciliationAllocationGroupFsp> GetAllocationGroupsForFundingClaim(FundingClaim fundingClaimToDebatch)
        {
            return fundingClaimToDebatch.ContractAllocations
                .Select(a => a.FundingStreamPeriodCode)
                .Select(GetClaimReconciliationAllocationGroupFsp)
                .ToList();
        }

        private ClaimReconciliationAllocationGroupFsp GetClaimReconciliationAllocationGroupFsp(string fspCode)
        {
            return _claimReconciliationAllocationGroupFsps.GetOrAdd(fspCode, fsp => _reconAllocGroupRepository.GetClaimAllocationGroupForFundingStreamPeriod(fsp));
        }
    }
}
