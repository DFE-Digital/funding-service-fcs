namespace Datafix.Tests.Automation.Releases._73
{
    using System.Configuration;
    using Microsoft.ServiceBus;

    public class RemoveRedundantSubscription : IApplyDataFix
    {
        public string Release => "R73";
        public int StoryNumber => 27672;
        public string Name => "Remove subscriptions due to handlers being moved to Fcs Worker";
        public int Order => 1;
        public void ApplyDataFix()
        {
            GetAsbNamespaceManager().DeleteSubscription("allocationdeliverydomain.validation.events", "4529020e-4b21-dcd9-93e8-d8b1ddf899f1");
            GetAsbNamespaceManager().DeleteSubscription("paymentgenerationdomain.processpaymentcomplete.events", "0033158e-1291-2fb6-985d-3046fa46dd9f");
        }

        private static NamespaceManager GetAsbNamespaceManager()
        {
            return NamespaceManager.CreateFromConnectionString(ConfigurationManager.ConnectionStrings["NServiceBus/Transport"].ConnectionString);
        }
    }
}
