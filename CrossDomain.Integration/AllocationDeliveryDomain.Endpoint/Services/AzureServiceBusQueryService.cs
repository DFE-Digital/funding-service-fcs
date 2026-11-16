namespace AllocationDeliveryDomain.Endpoint.Services
{
    using Azure.Messaging.ServiceBus.Administration;
    using System.Configuration;
    using System.Linq;
    using System.Threading.Tasks;

    public class AzureServiceBusQueryService : IAzureServiceBusQueryService
    {
        public long GetQueueMessageCount(string queueName)
        {
            var client = CreateAdministrationClient();

            var runtimeProperties = client
                .GetQueueRuntimePropertiesAsync(queueName)
                .GetAwaiter()
                .GetResult();

            return runtimeProperties.Value.ActiveMessageCount;
        }


        public long GetTopicMessageCount(string topicName)
        {
            return GetTopicMessageCountAsync(topicName).GetAwaiter().GetResult();
        }

        public async Task<long> GetTopicMessageCountAsync(string topicName)
        {
            var client = CreateAdministrationClient();

            long total = 0;

            await foreach (var sub in client.GetSubscriptionsRuntimePropertiesAsync(topicName))
            {
                total += sub.ActiveMessageCount;
            }

            return total;
        }


        private ServiceBusAdministrationClient CreateAdministrationClient()
        {
            string connectionString = ConfigurationManager
                .ConnectionStrings["NServiceBus/Transport"]
                .ConnectionString;

            return new ServiceBusAdministrationClient(connectionString);
        }
    }
}