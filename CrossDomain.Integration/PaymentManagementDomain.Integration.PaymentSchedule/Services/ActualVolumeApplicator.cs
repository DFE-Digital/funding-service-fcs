namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.PaymentSchedule;
    using SFA.FCT.CrossDomain.Integration.Entities.AllocationActuals;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model;

    public class ActualVolumeApplicator : IActualVolumeApplicator
    {
        public void MutatePaymentScheduleWithActualVolume(
            CrossDomain.Integration.Entities.PaymentSchedule.Allocation paymentScheduleForAllocation,
            IReadOnlyCollection<DeliverablePayment> deliverablePayments,
            ContractAllocationActualsType allocationActuals)
        {
            allocationActuals.ActualsSummary.ForEach(actual =>
                {
                     var deliverableOnPaymentSchedule = paymentScheduleForAllocation.AllocationDeliverables
                            .SingleOrDefault(ad => ad.DeliverableCode == actual.DeliverableCode);

                    ScheduledPayment scheduledPayment =
                        deliverableOnPaymentSchedule?.ScheduledPayments
                            .SingleOrDefault(sp => sp.Period == actual.Period);

                    if (scheduledPayment != null)
                    {
                        scheduledPayment.ActualVolume = actual.ActualVolume;
                    }

                    var deliverablePayment = deliverablePayments.SingleOrDefault(dp =>
                        dp.AllocationNumber == allocationActuals.ContractAllocationNumber &&
                        dp.VersionNumber == allocationActuals.ContractReference.ContractVersionNumber &&
                        dp.DeliverableCode == actual.DeliverableCode &&
                        dp.Period == actual.Period);

                    if (deliverablePayment != null)
                    {
                        deliverablePayment.ActualVolume = actual.ActualVolume;
                    }
                });
        }
    }
}
