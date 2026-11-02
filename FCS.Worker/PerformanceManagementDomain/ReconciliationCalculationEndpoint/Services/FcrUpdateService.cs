namespace PerformanceManagementDomain.ReconciliationCalculationEndpoint.Services
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using CrmRepositories;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation;

    public class FcrUpdateService : IFcrUpdateService
    {
        private readonly ICrmFundingClaimReconciliationRepository _crmFundingClaimReconciliationRepository;

        public FcrUpdateService(ICrmFundingClaimReconciliationRepository crmFundingClaimReconciliationRepository)
        {
            _crmFundingClaimReconciliationRepository = crmFundingClaimReconciliationRepository;
        }

        public void UpdateFundingClaimReconciliationInCrm(AmountSummary amounts, IEnumerable<ContractAllocation> contractAllocations, Guid fcrCrmId)
        {
            _crmFundingClaimReconciliationRepository.UpdateValues(
                fcrId: fcrCrmId,
                newProposedReconciliationValue: amounts.ProposedReconciliationValue.Value,
                newPlannedValue: amounts.PlannedValue.Value,
                adjustedCappedClaimValue: amounts.AdjustedCappedClaimValue ?? 0,
                cappedClaimValue:amounts.CappedClaimedValue ?? 0);

            IReadOnlyCollection<AllocationPlannedValue> fcrAllocationInfos = _crmFundingClaimReconciliationRepository.GetFcrAllocationInfos(fcrCrmId);

            IEnumerable<ContractAllocationAllocationInfo> allocationsWithChangedPlannedValue = contractAllocations
                .Select(ca => new ContractAllocationAllocationInfo(ca, new AllocationPlannedValue(ca.ContractAllocationNumber, ca.Amounts.PlannedValue.Value)))
                .Where(caai => !fcrAllocationInfos.Contains(caai.AllocationPlannedValue));

            allocationsWithChangedPlannedValue.ToList()
                .ForEach(caai =>
                {
                    _crmFundingClaimReconciliationRepository.AssociateAllocationToFcrAndUpdateValues(
                        fcrId: fcrCrmId,
                        fcrAllocId: GetAllocationIdFromFcrAllocInfo(fcrAllocationInfos, caai.AllocationPlannedValue),
                        allocationNumber: caai.ContractAllocation.ContractAllocationNumber,
                        versionNumber: caai.ContractAllocation.Contract.ContractVersionNumber,
                        subVersionNumber: caai.ContractAllocation.Contract.ContractSubVersionNumber,
                        plannedValue: caai.ContractAllocation.Amounts.PlannedValue.Value,
                        proposedReconciliationValue: caai.ContractAllocation.Amounts.ProposedReconciliationValue.Value,
                        adjustedCappedClaimValue:caai.ContractAllocation.Amounts.AdjustedCappedClaimValue ?? 0,
                        cappedClaimValue: caai.ContractAllocation.Amounts.CappedClaimedValue ?? 0);

                    _crmFundingClaimReconciliationRepository.IssueCrmNotificationForAllocation(
                        caai.ContractAllocation.ContractAllocationNumber, caai.ContractAllocation.Contract.ContractVersionNumber);
                });
        }

        private static Guid GetAllocationIdFromFcrAllocInfo(IReadOnlyCollection<AllocationPlannedValue> fcrAllocationInfos, AllocationPlannedValue allocationPlannedValue)
        {
            AllocationPlannedValue matchingAllocPlannedValue = fcrAllocationInfos.Single(ai => ai.AllocationNumber == allocationPlannedValue.AllocationNumber);

            return matchingAllocPlannedValue.FcrAllocationId;
        }

        public void UpdateFcrAdjustedCappedClaimValueInCrm(
            decimal? adjustedCappedClaimValue,
            decimal? claimAdjustmentValue,
            decimal? proposedReconciliationValue,
            decimal? earningsBoostValue,
            Guid fcrCrmId)
        {
            IReadOnlyCollection<Guid> fcrAllocationIds = _crmFundingClaimReconciliationRepository.GetFcrAllocationIdsForFcrId(fcrCrmId);

            _crmFundingClaimReconciliationRepository.UpdateFcrAndAllocationValues(
                fcrId: fcrCrmId,
                adjustedCappedClaimValue: adjustedCappedClaimValue,
                claimAdjustmentValue: claimAdjustmentValue,
                proposedReconciliationValue: proposedReconciliationValue,
                earningsBoostValue : earningsBoostValue,
                fcrAllocationIds: fcrAllocationIds);
        }

        public void UpdateFundingClaimReconciliationInCrm(
            decimal? adjustedCappedClaimValue,
            decimal? claimAdjustmentValue,
            decimal? proposedReconciliationValue,
            decimal? reconciliationValue,
            decimal? earningsBoostValue,    
            Guid fcrCrmId)
        {
            IReadOnlyCollection<Guid> fcrAllocationIds = _crmFundingClaimReconciliationRepository.GetFcrAllocationIdsForFcrId(fcrCrmId);

            _crmFundingClaimReconciliationRepository.UpdateFcrAndAllocationValues(
                fcrId: fcrCrmId,
                adjustedCappedClaimValue: adjustedCappedClaimValue,
                claimAdjustmentValue: claimAdjustmentValue,
                proposedReconciliationValue: proposedReconciliationValue,
                reconciliationValue: reconciliationValue,
                 earningsBoostValue: earningsBoostValue,
                fcrAllocationIds: fcrAllocationIds);
        }

        private class ContractAllocationAllocationInfo
        {
            public ContractAllocationAllocationInfo(ContractAllocation contractAllocation, AllocationPlannedValue allocationPlannedValue)
            {
                ContractAllocation = contractAllocation;
                AllocationPlannedValue = allocationPlannedValue;
            }

            public ContractAllocation ContractAllocation { get; }

            public AllocationPlannedValue AllocationPlannedValue { get; }
        }
    }
}