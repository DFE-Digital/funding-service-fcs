namespace PerformanceManagementDomain.Services
{
    using System.Collections.Concurrent;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using ReconciliationCalculationEndpoint.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using FundingClaim = SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim.FundingClaim;

    public class FundingClaimDebatchService : IFundingClaimDebatchService
    {
        private readonly IClaimReconciliationAllocationGroupFspRepository _reconAllocGroupRepository;
        private readonly ConcurrentDictionary<string, ClaimReconciliationAllocationGroupFsp> _claimReconciliationAllocationGroupFsps 
            = new ConcurrentDictionary<string, ClaimReconciliationAllocationGroupFsp>();

        public FundingClaimDebatchService(IClaimReconciliationAllocationGroupFspRepository reconAllocGroupRepository)
        {
            _reconAllocGroupRepository = reconAllocGroupRepository;
        }

        public async Task<IEnumerable<DebatchedFundingClaim>> DebatchFundingClaimByAllocationGroup(FundingClaim fundingClaimToDebatch, ConnectionInfo connectionInfo)
        {
            List<ClaimReconciliationAllocationGroupFsp> claimReconciliationAllocationGroupFsps = 
                await GetAllocationGroupsForFundingClaim(fundingClaimToDebatch,connectionInfo)
                .ConfigureAwait(continueOnCapturedContext: false);

            var groupedAllocationGroups = claimReconciliationAllocationGroupFsps.GroupBy(x => x.ClaimReconciliationAllocationGroupCode);

            return groupedAllocationGroups.Select(group => 
                TransformToDebatchedFundingClaim(allocationGroupCode: group.Key, allocationGroupFsps: group, fundingClaimToDebatch: fundingClaimToDebatch));
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

        private async Task<List<ClaimReconciliationAllocationGroupFsp>> GetAllocationGroupsForFundingClaim(FundingClaim fundingClaimToDebatch, ConnectionInfo connectionInfo)
        {
            var claimReconciliationAllocationGroupFsps = new List<ClaimReconciliationAllocationGroupFsp>();

            foreach (var allocation in fundingClaimToDebatch.ContractAllocations)
            {
                var claimReconciliationAllocationGroupFsp = await GetClaimReconciliationAllocationGroupFsp(allocation.FundingStreamPeriodCode, connectionInfo)
                    .ConfigureAwait(continueOnCapturedContext: false);

                claimReconciliationAllocationGroupFsps.Add(claimReconciliationAllocationGroupFsp);
            }

            return claimReconciliationAllocationGroupFsps;
        }

        private async Task<ClaimReconciliationAllocationGroupFsp> GetClaimReconciliationAllocationGroupFsp(string fspCode, ConnectionInfo connectionInfo)
        {
            if (_claimReconciliationAllocationGroupFsps.ContainsKey(fspCode))
            {
                return _claimReconciliationAllocationGroupFsps[fspCode];
            }

            var claimReconciliationAllocationGroupFsp = await _reconAllocGroupRepository
                .GetClaimAllocationGroupForFundingStreamPeriod(fspCode,connectionInfo)
                .ConfigureAwait(continueOnCapturedContext: false);

            _claimReconciliationAllocationGroupFsps.TryAdd(fspCode, claimReconciliationAllocationGroupFsp);

            return claimReconciliationAllocationGroupFsp;
        }
    }
}