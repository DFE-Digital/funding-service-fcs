namespace PaymentManagement.Calculation.Extensions
{
    using System.Collections.Generic;
    using System.Linq;
    using Dtos;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation.Infos;

    public static class FcrAllocationInfoExtensions
    {
        public static CalculationAllocationInput ToCalculationAllocationInput(
            this AllocationInfo allocationInfo,
            string contractNumber,
            int versionNumber,
            int ukprn,
            string orgId,
            IReadOnlyCollection<DeliverablePeriodPaymentInfo> deliverablePeriods,
            IReadOnlyCollection<FspDeliverableInfo> fspDeliverables)
        {
            List<CalculationDeliverableInput> deliverableInputs =
                deliverablePeriods
                    .GroupBy(dp => dp.DeliverableCode)
                    .Select(grp => new CalculationDeliverableInput(
                        deliverableCode: grp.Key,
                        deliverablePeriods: grp.Select(ToCalculationDeliverablePeriodInput).ToList(),
                        allowProfile: DoesDeliverableAllowProfile(grp.Key, fspDeliverables),
                        cappingApportionmentPriorityOrder: null,
                        fundingStreamPeriodCappingGroupId: null,
                        allowPayment: DoesDeliverableAllowPayment(grp.Key, fspDeliverables)))
                    .ToList();

            return new CalculationAllocationInput(
                allocationNumber: allocationInfo.AllocationNumber,
                versionNumber: versionNumber,
                fundingStreamPeriodCode: allocationInfo.FundingStreamPeriodCode,
                deliverables: deliverableInputs,
                ukprn: ukprn.ToString(),
                orgId: orgId,
                contractNumber: contractNumber,
                cappingGroups: null); ;
        }

        private static bool DoesDeliverableAllowProfile(int deliverableCode, IEnumerable<FspDeliverableInfo> fspDeliverables)
        {
            return fspDeliverables.Single(fspd => fspd.DeliverableCode == deliverableCode).AllowProfile;
        }

        private static bool DoesDeliverableAllowPayment(int deliverableCode, IEnumerable<FspDeliverableInfo> fspDeliverables)
        {
            return fspDeliverables.Single(fspd => fspd.DeliverableCode == deliverableCode).AllowPayment;
        }

        private static CalculationDeliverablePeriodInput ToCalculationDeliverablePeriodInput(DeliverablePeriodPaymentInfo deliverablePeriodPaymentInfo)
        {
            return new CalculationDeliverablePeriodInput
            {
                Period = deliverablePeriodPaymentInfo.Period,
                ActualVolume = deliverablePeriodPaymentInfo.ActualVolume,
                ActualValue = deliverablePeriodPaymentInfo.ActualValue,
                PlannedValue = deliverablePeriodPaymentInfo.PlannedValue,
                PlannedVolume = deliverablePeriodPaymentInfo.PlannedVolume,
                NetPayment = deliverablePeriodPaymentInfo.NetPaymentAmount,
                CappedPayment = deliverablePeriodPaymentInfo.CappedPaymentAmount,
                ReconciliationPayment = deliverablePeriodPaymentInfo.ReconciliationPaymentAmount,
                ProfilePayment = deliverablePeriodPaymentInfo.ProfilePaymentAmount,
                BalancingPayment = deliverablePeriodPaymentInfo.BalancingPaymentAmount
            };
        }
    }
}
