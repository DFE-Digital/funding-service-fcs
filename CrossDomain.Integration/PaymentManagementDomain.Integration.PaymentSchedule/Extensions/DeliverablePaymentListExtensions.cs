namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Extensions
{
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.PaymentSchedule;
    using PaymentManagementDomain.PaymentSchedule.DataStore.Model;
    using Allocation = CrossDomain.Integration.Entities.PaymentSchedule.Allocation;

    public static class DeliverablePaymentListExtensions
    {
        public static Allocation ToPaymentSchedule(
            this IReadOnlyCollection<DeliverablePayment> deliverablePayments,
            string fundingStreamPeriod, 
            string contractNumber,
            CrossDomain.Integration.Entities.PaymentSchedule.Organisation organisation)
        {
            if (deliverablePayments.Any())
            {
                var deliverablePayment = deliverablePayments.First();
                var allocationNumber = deliverablePayment.AllocationNumber;
                var version = deliverablePayment.VersionNumber;

                return new Allocation
                {
                    Organisation = organisation,
                    AllocationNumber = allocationNumber,
                    VersionNumber = version,
                    ContractNumber = contractNumber,
                    FundingStreamPeriodCode = fundingStreamPeriod,
                    ContractVersionNumber = version,
                    AllocationDeliverables = deliverablePayments.GroupBy(dp => dp.DeliverableCode)
                        .Select(ToAllocationDeliverable).ToList()
                };
            }
           
            return new Allocation();
        }

        private static AllocationDeliverable ToAllocationDeliverable(
            IGrouping<int, DeliverablePayment> deliverablePaymentsWithTheSameDeliverableCode)
        {
            return new AllocationDeliverable
            {
                DeliverableCode = deliverablePaymentsWithTheSameDeliverableCode.Key,
                ScheduledPayments = deliverablePaymentsWithTheSameDeliverableCode.Select(ToScheduledPayment).ToList()
            };
        }

        private static ScheduledPayment ToScheduledPayment(DeliverablePayment deliverablePayment)
        {
            return new ScheduledPayment
            {
                ActualValue = deliverablePayment.ActualValue,
                ActualVolume = deliverablePayment.ActualVolume,
                BalancingPaymentAmount = deliverablePayment.BalancingPaymentAmount,
                CappedPaymentAmount = deliverablePayment.CappedPaymentAmount,
                CollectionReturnCode = deliverablePayment.CollectionReturnCode,
                NetPaymentAmount = deliverablePayment.NetPaymentAmount,
                Period = deliverablePayment.Period,
                PeriodTypeCode = deliverablePayment.PeriodTypeCode.ToString(),
                PlannedValue = deliverablePayment.PlannedValue,
                PlannedVolume = deliverablePayment.PlannedVolume,
                ProfilePaymentAmount = deliverablePayment.ProfilePaymentAmount,
                ReconciliationPaymentAmount = deliverablePayment.ReconciliationPaymentAmount
            };
        }
    }
}
