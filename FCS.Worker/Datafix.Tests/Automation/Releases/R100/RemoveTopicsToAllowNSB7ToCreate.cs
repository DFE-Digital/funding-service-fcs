namespace Datafix.Tests.Automation.Releases.R100
{
    using Azure.Messaging.ServiceBus.Administration;
    using System.Configuration;
    using System.Linq;

    public class RemoveTopicsToAllowNSB7ToCreate : IApplyDataFix
    {
        public string Release => "R100";
        public int StoryNumber => 31996;
        public string Name => "Move Cross Domain Integration to NServiceBus 7 (31996)";
        public int Order => 1;

        public void ApplyDataFix()
        {
            var client = GetAsbAdminClient();

            var topics = client.GetTopicsAsync();

            var enumerator = topics.GetAsyncEnumerator();

            try
            {
                while (enumerator.MoveNextAsync().AsTask().GetAwaiter().GetResult())
                {
                    var topic = enumerator.Current;

                    client.DeleteTopicAsync(topic.Name)
                          .GetAwaiter()
                          .GetResult();
                }
            }
            finally
            {
                enumerator.DisposeAsync().AsTask().GetAwaiter().GetResult();
            }
        }

        private static ServiceBusAdministrationClient GetAsbAdminClient()
        {
            var connectionString = ConfigurationManager
                .ConnectionStrings["NServiceBus/Transport"]
                .ConnectionString;

            return new ServiceBusAdministrationClient(connectionString);
        }

    }
}
