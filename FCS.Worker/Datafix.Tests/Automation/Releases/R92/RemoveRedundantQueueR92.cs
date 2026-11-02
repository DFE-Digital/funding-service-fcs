namespace Datafix.Tests.Automation.Releases.R92
{
    using System.Configuration;
    using Microsoft.ServiceBus;

    public class RemoveRedundantQueueR92 : IApplyDataFix
    {
        public string Release => "R92";

        public int StoryNumber => 30534;

        public string Name => "Remove AllocationDeliveryDomain.Endpoint queue";

        public int Order => 1;

        public void ApplyDataFix()
        {
            GetAsbNamespaceManager().DeleteQueue("allocationdeliverydomain.endpoint");
        }

        private static NamespaceManager GetAsbNamespaceManager()
        {
            return NamespaceManager.CreateFromConnectionString(ConfigurationManager.ConnectionStrings["NServiceBus/Transport"].ConnectionString);
        }
    }
}