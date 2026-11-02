namespace PerformanceManagementDomain.ReconciliationCalculationEndpoint.Extensions
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;

    public static class ContractAllocationListExtensions
    {
        public static AmountSummary CalculateAmountSummaryForClaimGroup(
            this IReadOnlyCollection<ContractAllocation> contractAllocations,
            ClaimReconciliationBehaviour claimGroupBehaviour,
            decimal claimAdjustmentValue, decimal? earningsBoostValue = 0)
        {
            decimal plannedValue = contractAllocations.Sum(a => a.Amounts.PlannedValue.GetValueOrDefault());
            decimal claimedValue = contractAllocations.Sum(a => a.Amounts.ClaimedValue.GetValueOrDefault());
            decimal cappedClaimedValue = contractAllocations.Sum(a => a.Amounts.CappedClaimedValue.GetValueOrDefault());
            decimal adjustedCappedClaimValue = cappedClaimedValue + claimAdjustmentValue;
            decimal variance = adjustedCappedClaimValue - plannedValue;
            decimal proposedReconciliationValue = 0m;
            decimal toleranceValue = Math.Abs(plannedValue * claimGroupBehaviour.UnderDeliveryTolerancePercentage / 100);
            decimal? overDeliveryLimit = decimal.MaxValue;
            if (claimGroupBehaviour.OverDeliveryLimitPercentage.HasValue)
            {
                overDeliveryLimit = plannedValue * claimGroupBehaviour.OverDeliveryLimitPercentage / 100;
            }

            if (variance != 0)
            {
                if (variance < 0)
                {
                    if (claimGroupBehaviour.DoWeReconcileUnderDelivery &&
                        variance < claimGroupBehaviour.UnderDeliveryDeMinimis && variance < toleranceValue)
                    {
                        if (claimGroupBehaviour.UnderDeliveryRecoveryAmount == UnderDeliveryRecoveryAmount.Excess ||
                            claimGroupBehaviour.UnderDeliveryRecoveryAmount == UnderDeliveryRecoveryAmount.ExcessUnlessNoDelivery && adjustedCappedClaimValue != 0)
                        {
                            var excessVariance = variance - -Math.Abs(toleranceValue);
                            proposedReconciliationValue = Math.Min(0, excessVariance);
                        }
                        else
                        {
                            if (Math.Abs(variance) > Math.Abs(toleranceValue))
                            {
                                proposedReconciliationValue = variance;
                            }
                        }
                    }
                }
                else
                {
                    // variance greater then 0
                    if (claimGroupBehaviour.DoWeReconcileOverDelivery && variance > claimGroupBehaviour.OverDeliveryDeMinimis)
                    {
                        proposedReconciliationValue = Math.Min(variance, overDeliveryLimit.GetValueOrDefault());
                    }
                }
            }
            
            var amountSummary = new AmountSummary
            {
                PlannedValue = plannedValue,
                ClaimedValue = claimedValue,
                CappedClaimedValue = cappedClaimedValue,
                AdjustedCappedClaimValue = adjustedCappedClaimValue
            };

            amountSummary.SetReconciliationAmounts(proposedReconciliationValue);
        
            return amountSummary;
        }

        public static void ApportionProposedReconciliationToAllocations(this IReadOnlyCollection<ContractAllocation> allocations, AmountSummary claimGroupAmounts)
        {
            allocations.ToList().ForEach(a => a.Amounts.ProposedReconciliationValue = 0);

            var grpTotalVariance = claimGroupAmounts.AdjustedCappedClaimValue - claimGroupAmounts.PlannedValue;

            if (grpTotalVariance.GetValueOrDefault() != 0)
            {
                IReadOnlyCollection<ContractAllocation> providerPerformanceAllocations = allocations;
                if (allocations.Count > 1)
                {
                    providerPerformanceAllocations = grpTotalVariance.GetValueOrDefault() > 0
                        ? allocations.Where(alloc => alloc.Amounts.VarianceValue.GetValueOrDefault() > 0).ToList()
                        : allocations.Where(alloc => alloc.Amounts.VarianceValue.GetValueOrDefault() < 0).ToList();
                }

                var totalVariance = providerPerformanceAllocations.Sum(ppa => ppa.Amounts.VarianceValue);
                if (totalVariance != 0)
                {
                    foreach (var allocation in providerPerformanceAllocations)
                    {
                        decimal? reconciliation = claimGroupAmounts.ProposedReconciliationValue * allocation.Amounts.VarianceValue.GetValueOrDefault() /
                                                  totalVariance;

                        reconciliation = Math.Round(reconciliation.GetValueOrDefault(), 2);
                        allocation.Amounts.SetReconciliationAmounts(reconciliation.GetValueOrDefault());
                    }
                }
            }
        }

        public static void ApportionAdjustedCappedClaimValueToAllocations(this IReadOnlyCollection<ContractAllocation> allocations, decimal? adjustedCappedClaimValue)
        {
            // this assumes there is one allocation, ie no apportionment
            allocations
                .ToList()
                .ForEach(a => a.Amounts.AdjustedCappedClaimValue = adjustedCappedClaimValue);
        }
    }
}