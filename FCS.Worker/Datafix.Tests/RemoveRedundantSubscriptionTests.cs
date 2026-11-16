namespace Datafix.Tests
{ 
    using Automation;
    using Azure.Messaging.ServiceBus.Administration;
    using System.Configuration;

    public class RemoveRedundantSubscriptionTests : IApplyDataFix
    {
        public string Release => "R71";
        public int StoryNumber => 26707;
        public string Name => "Remove redundant subscription for PaymentAggregatedEvent";
        public int Order => 1;
        public void ApplyDataFix()
        {
            GetAsbNamespaceManager().DeleteSubscriptionAsync("paymentmanagementdomain.paymentaggregation.events", "89e0d6eb-6967-6042-6fd1-254a88850d01");
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
