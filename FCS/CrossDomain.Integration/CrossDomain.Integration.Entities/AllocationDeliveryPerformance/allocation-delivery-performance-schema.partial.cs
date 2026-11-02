namespace SFA.FCT.CrossDomain.Integration.Entities
{
    using System.Linq;

    public partial class AllocationDeliveryPerformance
    {
        public virtual bool ShouldSerializeActualsPeriods()
        {
            return (ActualsPeriods != null && ActualsPeriods.ActualsPeriod != null && ActualsPeriods.ActualsPeriod.Any());
        }

        public virtual bool ShouldSerializeAggregatedPaymentPeriods()
        {
            return (AggregatedPaymentPeriods != null && AggregatedPaymentPeriods.Any());
        }

        public virtual bool ShouldSerializeScheduledPaymentPeriods()
        {
            return (ScheduledPaymentPeriods != null && ScheduledPaymentPeriods.Any());
        }

        public virtual bool ShouldSerializeContractDeliverables()
        {
            ContractDeliverables?.ForEach(TraverseContractDeliverable);

            return (ContractDeliverables != null && ContractDeliverables.Any());
        }

        public virtual bool ShouldSerializeallocationOrganisationRelationships()
        {
            return !string.IsNullOrEmpty(allocationOrganisationRelationships?.contractAllocationNumber)
                   && !string.IsNullOrEmpty(allocationOrganisationRelationships.Organisation?.organisationIdentifier);

        }

        private void TraverseContractDeliverable(DeliverableTYPE contractDeliverable)
        {
            contractDeliverable?.ContractDeliverables?.ForEach(TraverseContractDeliverable);

            RemoveEmptyContractDeliverables(contractDeliverable);
        }

        private void RemoveEmptyContractDeliverables(DeliverableTYPE contractDeliverable)
        {
            if (contractDeliverable.ContractDeliverables != null && !contractDeliverable.ContractDeliverables.Any())
            {
                contractDeliverable.ContractDeliverables = null;
            }
        }
    }
}
