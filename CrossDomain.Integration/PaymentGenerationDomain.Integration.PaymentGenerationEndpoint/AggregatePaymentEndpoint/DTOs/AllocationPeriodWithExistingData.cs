namespace PaymentGenerationDomain.Integration.PaymentGenerationEndpoint.AggregatePaymentEndpoint.DTOs
{
    using System.Collections.Generic;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation;

    public class AllocationPeriodWithExistingData
    {
        public AllocationPeriod AllocationPeriod { get; }

        public IReadOnlyCollection<SimpleSubnominalAggregation> ExistingSubnominalAggregations { get; }

        public AllocationPeriodWithExistingData(AllocationPeriod allocationPeriod, IReadOnlyCollection<SimpleSubnominalAggregation> existingSubnominalAggregations)
        {
            AllocationPeriod = allocationPeriod;
            ExistingSubnominalAggregations = existingSubnominalAggregations;
        }
    }
}
