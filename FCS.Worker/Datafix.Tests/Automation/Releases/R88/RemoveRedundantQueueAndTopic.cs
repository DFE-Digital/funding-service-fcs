namespace Datafix.Tests.Automation.Releases.R88
{
    using System.Configuration;
    using Microsoft.ServiceBus;

    public class RemoveRedundantQueueAndTopic : IApplyDataFix
    {
        public string Release => "R88";

        public int StoryNumber => 30150;

        public string Name => "Remove AllocationDeliveryDomain.Endpoint queues and topic";

        public int Order => 2;

        public void ApplyDataFix()
        {
            GetAsbNamespaceManager().DeleteQueue("AllocationDeliveryDomain.Endpoint");
            GetAsbNamespaceManager().DeleteQueue("allocationdeliverydomain.endpoint.retries");
            GetAsbNamespaceManager().DeleteTopic("allocationdeliverydomain.endpoint.events");
        }

        private static NamespaceManager GetAsbNamespaceManager()
        {
            return NamespaceManager.CreateFromConnectionString(ConfigurationManager.ConnectionStrings["NServiceBus/Transport"].ConnectionString);
        }
    }
}