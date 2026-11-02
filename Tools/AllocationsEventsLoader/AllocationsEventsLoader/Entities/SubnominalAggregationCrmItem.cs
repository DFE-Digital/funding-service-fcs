namespace AllocationsEventsLoader.Entities
{
    using System.Diagnostics.CodeAnalysis;
    using Microsoft.Xrm.Sdk;

    [SuppressMessage("ReSharper", "InconsistentNaming")]
    public class SubnominalAggregationCrmItem
    {
        public string sfa_SubnominalAggregateKey { get; set; }

        public string sfa_Period { get; set; }

        public string sfa_SubnominalCode { get; set; }

        public OptionSetValue sfa_PaymentType { get; set; }

        public decimal? sfa_AggregatedValue { get; set; }
    }
}