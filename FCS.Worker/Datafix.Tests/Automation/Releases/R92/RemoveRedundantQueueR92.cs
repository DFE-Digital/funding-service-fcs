namespace Datafix.Tests.Automation.Releases.R92
{
    using Azure.Messaging.ServiceBus.Administration;
    using System.Configuration;
    
    public class RemoveRedundantQueueR92 : IApplyDataFix
    {
        public string Release => "R92";

        public int StoryNumber => 30534;

        public string Name => "Remove AllocationDeliveryDomain.Endpoint queue";

        public int Order => 1;

        public void ApplyDataFix()
        {
            GetAsbNamespaceManager().DeleteQueueAsync("allocationdeliverydomain.endpoint");
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