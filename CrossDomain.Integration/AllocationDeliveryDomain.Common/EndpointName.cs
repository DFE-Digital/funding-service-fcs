namespace SFA.FCT.AllocationDeliveryDomain.Common
{
    using CrossDomain.Integration.Common;

    public static class EndpointName
    {
        public const string AllocationDeliveryDomainValidation = "AllocationDeliveryDomain.Validation";
        public const string AllocationDeliveryCommenced = "AllocationDelivery.MonitoringDeliverablesEnrichment";
        public const string AllocationDeliveryDomainRouting = "AllocationDeliveryDomain.Routing";
        public const string AllocationDeliveryDomainMonthEndCheck = "AllocationDeliveryDomain.MonthEndCheck";

        public static string AllocationDeliveryDomainValidationEncoded
        {
            get { return FctEndpoint.GenerateEndpointName(AllocationDeliveryDomainValidation); }
        }

        public static string AllocationDeliveryCommencedEncoded
        {
            get { return FctEndpoint.GenerateEndpointName(AllocationDeliveryCommenced); }
        }
    }
}
