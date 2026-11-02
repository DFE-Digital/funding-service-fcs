namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using PaymentManagementDomain.PaymentSchedule.DataStore.Model;
    using PaymentSchedule = CrossDomain.Integration.Entities.PaymentSchedule;
    using System;

    public static class PaymentScheduleAllocationToDeliverablePaymentTransformer
    {
        public static IReadOnlyCollection<DeliverablePayment> ToDeliverablePayments(PaymentSchedule.Allocation allocation)
        {
            return
                allocation.AllocationDeliverables.SelectMany(ad =>
                    ad.ScheduledPayments.Select(sp => new DeliverablePayment
                    {
                        AllocationNumber = allocation.AllocationNumber,
                        VersionNumber = allocation.ContractVersionNumber,
                        DeliverableCode = ad.DeliverableCode,
                        BalancingPaymentAmount = sp.BalancingPaymentAmount,
                        CappedPaymentAmount = sp.CappedPaymentAmount,
                        CollectionReturnCode = sp.CollectionReturnCode,
                        NetPaymentAmount = sp.NetPaymentAmount,
                        Period = sp.Period,
                        PeriodTypeCode = (PeriodTypeCode)Enum.Parse(typeof(PeriodTypeCode), sp.PeriodTypeCode),
                        PlannedValue = sp.PlannedValue,
                        PlannedVolume = sp.PlannedVolume,
                        ProfilePaymentAmount = sp.ProfilePaymentAmount,
                        ReconciliationPaymentAmount = sp.ReconciliationPaymentAmount,
                        ActualValue = sp.ActualValue,
                        ActualVolume = sp.ActualVolume
                    })).ToList();
        }
    }
}