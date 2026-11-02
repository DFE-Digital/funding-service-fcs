namespace PaymentGenerationDomain.Integration.DataStore.Dtos
{
    using System;

    public class SubnominalAggregationDto
    {
        public string AllocationNumber { get; set; }

        public int AllocationVersionNumber { get; set; }

        public string SubnominalCode { get; set; }

        public decimal AggregatedValue { get; set; }

        public string ShortDescription { get; set; }

        public string PaymentType { get; set; }

        public string OrganisationId { get; set; }

        public int Ukprn { get; set; }

        public string AgencyCode { get; set; }

        public DateTime StartDate { get; set; }

        public DateTime EndDate { get; set; }

        public string FinanceShortCode { get; set; }
    }
}
