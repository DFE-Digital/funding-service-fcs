namespace Datafix.Tests.Automation.Releases.R88
{
    using Azure.Messaging.ServiceBus.Administration;
    using System.Configuration;

    public class RemoveRedundantQueueAndTopic : IApplyDataFix
    {
        public string Release => "R88";

        public int StoryNumber => 30150;

        public string Name => "Remove AllocationDeliveryDomain.Endpoint queues and topic";

        public int Order => 2;

        public void ApplyDataFix()
        {
            GetAsbNamespaceManager().DeleteQueueAsync("AllocationDeliveryDomain.Endpoint");
            GetAsbNamespaceManager().DeleteQueueAsync("allocationdeliverydomain.endpoint.retries");
            GetAsbNamespaceManager().DeleteTopicAsync("allocationdeliverydomain.endpoint.events");
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