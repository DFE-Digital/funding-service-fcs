namespace PaymentGenerationDomain.Integration.PaymentGenerationEndpoint.Extensions
{
    using System.Collections.Generic;
    using System.Linq;
    using AggregatePaymentEndpoint.DTOs;

    public static class SubnominalAggregationCollectionExtensions
    {
        public static bool ArePosted(this IEnumerable<SimpleSubnominalAggregation> subnominalAggregations)
        {
            return subnominalAggregations.Any(sa => sa.IsPosted);
        }
    }
}
