namespace PaymentGenerationDomain.Integration.PaymentGenerationEndpoint.Extensions
{
    using DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation;

    public static class AggregationExtensions
    {
        public static SubnominalAggregation ToSubnominalAggregation(
            this Aggregation aggregation,
            SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation.Allocation allocation,
            string period,
            string periodTypeCode)
        {
            return new SubnominalAggregation
            {
                AllocationNumber = allocation.AllocationNumber,
                Period = period,
                PaymentType = aggregation.PaymentType.ToString(),
                SubnominalCode = aggregation.SubnominalCode,
                PeriodTypeCode = periodTypeCode,
                FundingStreamPeriodCode = allocation.FundingStreamPeriodCode,
                Ukprn = int.Parse(allocation.Organisation.GetUkprn()),
                OrganisationId = allocation.Organisation.MainOrganisationIdentifier,
                AggregatedValue = aggregation.AggregatedValue,
                AllocationVersionNumber = allocation.VersionNumber
            };
        }
    }
}
