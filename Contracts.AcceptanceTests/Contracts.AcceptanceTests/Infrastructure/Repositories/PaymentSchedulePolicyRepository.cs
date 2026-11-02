namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System.Collections.Generic;
    using System.Linq;
    using Extensions;
    using PaymentManagementDomain.PaymentSchedule.DataStore;
    using PaymentManagementDomain.PaymentSchedule.DataStore.Model;

    public static class PaymentSchedulePolicyRepository
    {
        public static DeliverablePayment GetDeliverablePaymentByKey(string allocationNumber, int versionNumber, int deliverableCode, string period)
        {
            using (var context = new PaymentSchedulePolicyContext())
            {
                return context.DeliverablePayments.Find(allocationNumber, versionNumber, deliverableCode, period);
            }
        }

        public static IReadOnlyCollection<DeliverablePayment> GetDeliverablePayments(string allocationNumber, int versionNumber)
        {
            using (var context = new PaymentSchedulePolicyContext())
            {
                return context.DeliverablePayments.Where(dp => dp.AllocationNumber == allocationNumber && dp.VersionNumber == versionNumber).ToList();
            }
        }

        public static bool HaveDeliverablePaymentsGotEquivalentCalcValues(DeliverablePayment deliverablePayment1,
           DeliverablePayment deliverablePayment2)
        {
            return deliverablePayment1 != null && deliverablePayment2 != null &&
                   deliverablePayment1.PeriodTypeCode == deliverablePayment2.PeriodTypeCode &&
                   deliverablePayment1.PlannedVolume == deliverablePayment2.PlannedVolume &&
                   deliverablePayment1.PlannedValue == deliverablePayment2.PlannedValue &&
                   deliverablePayment1.ProfilePaymentAmount.GetValueOrDefault() == deliverablePayment2.ProfilePaymentAmount.GetValueOrDefault() &&
                   deliverablePayment1.CappedPaymentAmount .GetValueOrDefault()== deliverablePayment2.CappedPaymentAmount.GetValueOrDefault() &&
                   deliverablePayment1.BalancingPaymentAmount.GetValueOrDefault() == deliverablePayment2.BalancingPaymentAmount.GetValueOrDefault() &&
                   deliverablePayment1.ReconciliationPaymentAmount.GetValueOrDefault() == deliverablePayment2.ReconciliationPaymentAmount.GetValueOrDefault() &&
                   deliverablePayment1.NetPaymentAmount == deliverablePayment2.NetPaymentAmount &&
                   deliverablePayment1.ActualValue.GetValueOrDefault() == deliverablePayment2.ActualValue.GetValueOrDefault() &&
                   (deliverablePayment1.ActualVolume ?? 0) == (deliverablePayment2.ActualVolume ?? 0);
        }

        public static void RemovePublishedPayableFcrAllocationsByKey(IEnumerable<string> allocationNumbers)
        {
            using (var context = new PaymentSchedulePolicyContext())
            {
                context.PublishedPayableFcrAllocations.RemoveWhere(a => allocationNumbers.Contains(a.AllocationNumber));
                context.SaveChanges();
            }
        }
    }
}
