namespace Datafix.Tests
{ 
    using System.Configuration;
    using Automation;
    using Microsoft.ServiceBus;

    public class RemoveRedundantSubscriptionTests : IApplyDataFix
    {
        public string Release => "R71";
        public int StoryNumber => 26707;
        public string Name => "Remove redundant subscription for PaymentAggregatedEvent";
        public int Order => 1;
        public void ApplyDataFix()
        {
            GetAsbNamespaceManager().DeleteSubscription("paymentmanagementdomain.paymentaggregation.events", "89e0d6eb-6967-6042-6fd1-254a88850d01");
        }

        private static NamespaceManager GetAsbNamespaceManager()
        {
            return NamespaceManager.CreateFromConnectionString(ConfigurationManager.ConnectionStrings["NServiceBus/Transport"].ConnectionString);
        }
    }
}
