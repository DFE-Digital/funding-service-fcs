namespace Datafix.Tests.Automation.Releases.R77
{
    using Azure.Messaging.ServiceBus.Administration;
    using System.Configuration;

    public class RemoveAllocationDeliveryCommencedSubscription : IApplyDataFix
    {
        public string Release => "R77";
        public int StoryNumber => 28464;
        public string Name => "Remove subscription to Allocation Delivery Commenced from Contract Create";
        public int Order => 1;
        public void ApplyDataFix()
        {
            var client = GetAsbNamespaceManager();

            client.DeleteSubscriptionAsync("allocationdelivery.monitoringdeliverablesenrichment.events", "30784a08-2654-5cde-6097-3a088309e515");
        }

        private static ServiceBusAdministrationClient GetAsbNamespaceManager()
        {
            var connectionString = ConfigurationManager
                .ConnectionStrings["NServiceBus/Transport"]
                .ConnectionString;

            return new ServiceBusAdministrationClient(connectionString);
        }
    }
}
