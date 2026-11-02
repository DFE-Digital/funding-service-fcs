namespace AllocationDeliveryDomain.Endpoint.Settings
{
    using Infrastructure;

    public class AllocationDeliveryDomainSettings : IAllocationDeliveryDomainSettings
    {
        public bool SendDownstreamProcessingMessages => bool.Parse(ConfigurationRetriever.GetAppSetting("DedsPollerSendDownstreamProcessingMessages"));
    }
}