namespace SFA.FCT.PaymentManagementDomain.BusinessLogic.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using MoreLinq;
    using CrossDomain.Integration.Entities.DeliveryAllocation;
    using SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule;

    public static class PlannedValueCopier
    {
        public static void CopyDeliveryCommencedValuesToPaymentSchedule(IReadOnlyCollection<contractDeliverableType> sourceContractDeliverables, IReadOnlyCollection<AllocationDeliverable> destinationAllocationDeliverables)
        {
            sourceContractDeliverables = FlattenDeliverables(sourceContractDeliverables);
            sourceContractDeliverables.ForEach(cd => CopyDeliverablePlannedValues(cd, destinationAllocationDeliverables.Single(ad => ad.DeliverableCode == cd.deliverable.deliverableCode)));
        }

        private static void CopyDeliverablePlannedValues(contractDeliverableType sourceContractDeliverableType, AllocationDeliverable destinationAllocationDeliverable)
        {
            sourceContractDeliverableType.contractDeliverablePeriods.ForEach(source => CopyPaymentLine(source, destinationAllocationDeliverable.ScheduledPayments.SingleOrDefault(destSp => destSp.Period == source.period.periodValue)));
        }

        private static void CopyPaymentLine(contractDeliverablePeriodsTypeContractDeliverablePeriod source, ScheduledPayment destinationScheduledPayment)
        {
            if (destinationScheduledPayment != null)
            {
                destinationScheduledPayment.PlannedValue = source.plannedValue;
            }
        }

        private static IReadOnlyCollection<contractDeliverableType> FlattenDeliverables(IReadOnlyCollection<contractDeliverableType> deliverables)
        {
            var results = new List<contractDeliverableType>();
            foreach (var contractDeliverableType in deliverables)
            {
                results.Add(contractDeliverableType);
                if (contractDeliverableType.contractDeliverables != null &&
                    contractDeliverableType.contractDeliverables.Any())
                {
                    results.AddRange(FlattenDeliverables(contractDeliverableType.contractDeliverables));
                }
            }

            return results;
        }
    }
}
