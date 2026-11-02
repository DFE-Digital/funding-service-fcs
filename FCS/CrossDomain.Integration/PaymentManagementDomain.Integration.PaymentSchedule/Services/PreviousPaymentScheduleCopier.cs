namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.Data;
    using PaymentManagementDomain.PaymentSchedule.DataStore.Model;
    using PaymentManagementDomain.PaymentSchedule.DataStore.Repositories;
    using PaymentSchedule = SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule;

    public class PreviousPaymentScheduleCopier : IPreviousPaymentScheduleCopier
    {
        private readonly IDeliverablePaymentRepository _deliverablePaymentRepository;

        public PreviousPaymentScheduleCopier(IDeliverablePaymentRepository deliverablePaymentRepository)
        {
            _deliverablePaymentRepository = deliverablePaymentRepository;
        }

        public void CopyPreviousReplacedValuesOntoPaySchedule(string allocationNumber, PaymentSchedule.Allocation currentAllocation, ConnectionInfo connectionInfo)
        {
            int? latestVersion = _deliverablePaymentRepository.GetLatestVersion(allocationNumber, connectionInfo);

            if (latestVersion.HasValue)
            {
                IReadOnlyCollection<DeliverablePayment> previousVersionDeliverablePayments =
                    _deliverablePaymentRepository.GetDeliverablePaymentsForAllocation(allocationNumber, latestVersion.Value, connectionInfo);

                var previousDeliverableGroups = previousVersionDeliverablePayments.GroupBy(dp => dp.DeliverableCode);

                var previousAllocationDeliverables = previousDeliverableGroups.Select(g => DeliverablePaymentGroupToAllocationDeliverable(
                    deliverableCode: g.Key,
                    deliverablePaymentsForDeliverableCode: g)).ToList();

                // if there are any new deliverables on the current version then keep those otherwise we simply overwrite
                var previousDistinctDeliverables = previousAllocationDeliverables.Select(ad => ad.DeliverableCode);

                var currentDeliverablesNotOnPreviousVersion = currentAllocation.AllocationDeliverables.Where(ad => !previousDistinctDeliverables.Contains(ad.DeliverableCode));

                List<PaymentSchedule.AllocationDeliverable> currentAllocationDeliverables = currentAllocation.AllocationDeliverables;

                currentAllocation.AllocationDeliverables = previousAllocationDeliverables;

                currentAllocation.AllocationDeliverables.AddRange(currentDeliverablesNotOnPreviousVersion);

                // copy the plannedValue and plannedVolume from the currentAllocationDeliverables onto our new object which is mainly the previous version
                CopyAllocationDeliverablePlannedValuesAndVolumes(source: currentAllocationDeliverables,
                    destination: currentAllocation.AllocationDeliverables);
            }
        }

        private static void CopyAllocationDeliverablePlannedValuesAndVolumes(
            IEnumerable<PaymentSchedule.AllocationDeliverable> source,
            IEnumerable<PaymentSchedule.AllocationDeliverable> destination)
        {
            source.ToList().ForEach(sourceDeliverable =>
            {
                var destinationDeliverable = destination.Single(d => d.DeliverableCode == sourceDeliverable.DeliverableCode);

                destinationDeliverable.ScheduledPayments.ForEach(destinationSchedulePayment =>
                {
                    PaymentSchedule.ScheduledPayment sourceScheduledPayment =
                        sourceDeliverable.ScheduledPayments.SingleOrDefault(
                            sourcePeriod => sourcePeriod.Period == destinationSchedulePayment.Period);

                    destinationSchedulePayment.PlannedValue = sourceScheduledPayment?.PlannedValue;
                    destinationSchedulePayment.PlannedVolume = sourceScheduledPayment?.PlannedVolume;
                });
            });
        }

        private void UpdateActualsOnAllocation(DeliverablePayment existingDeliverablePayment, IReadOnlyCollection<PaymentSchedule.AllocationDeliverable> allocationDeliverables)
        {
            PaymentSchedule.AllocationDeliverable allocationDeliverable = allocationDeliverables.SingleOrDefault(
                ad => ad.DeliverableCode == existingDeliverablePayment.DeliverableCode);

            PaymentSchedule.ScheduledPayment scheduledPayment = allocationDeliverable?.ScheduledPayments.SingleOrDefault(
                sp => sp.Period == existingDeliverablePayment.Period);

            if (scheduledPayment != null)
            {
                scheduledPayment.ActualValue = existingDeliverablePayment.ActualValue;
                scheduledPayment.ActualVolume = existingDeliverablePayment.ActualVolume;
            }
        }

        private PaymentSchedule.AllocationDeliverable DeliverablePaymentGroupToAllocationDeliverable(int deliverableCode,  IEnumerable<DeliverablePayment> deliverablePaymentsForDeliverableCode)
        {
            return new PaymentSchedule.AllocationDeliverable
            {
                DeliverableCode = deliverableCode,
                ScheduledPayments = deliverablePaymentsForDeliverableCode.Select(DeliverablePaymentToScheduledPayment).ToList()
            };
        }

        private PaymentSchedule.ScheduledPayment DeliverablePaymentToScheduledPayment(DeliverablePayment deliverablePayment)
        {
            return new PaymentSchedule.ScheduledPayment
            {
                ActualVolume = deliverablePayment.ActualVolume,
                ActualValue = deliverablePayment.ActualValue,
                PlannedValue = deliverablePayment.PlannedValue,
                PlannedVolume = deliverablePayment.PlannedVolume,
                BalancingPaymentAmount = deliverablePayment.BalancingPaymentAmount,
                CappedPaymentAmount = deliverablePayment.CappedPaymentAmount,
                NetPaymentAmount = deliverablePayment.NetPaymentAmount,
                ReconciliationPaymentAmount = deliverablePayment.ReconciliationPaymentAmount,
                ProfilePaymentAmount = deliverablePayment.ProfilePaymentAmount,
                CollectionReturnCode = deliverablePayment.CollectionReturnCode,
                Period = deliverablePayment.Period,
                PeriodTypeCode = deliverablePayment.PeriodTypeCode.ToString()
            };
        }
    }
}