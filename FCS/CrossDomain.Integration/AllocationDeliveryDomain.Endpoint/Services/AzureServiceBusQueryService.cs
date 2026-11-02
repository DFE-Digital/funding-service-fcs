namespace AllocationDeliveryDomain.Endpoint.Services
{
    using Microsoft.ServiceBus;
    using System.Configuration;
    using System.Linq;

    public class AzureServiceBusQueryService : IAzureServiceBusQueryService
    {
        public long GetQueueMessageCount(string queueName)
        {
            NamespaceManager namespaceManager = CreateNamespaceManager();
            return namespaceManager.GetQueue(queueName).MessageCount;
        }

        public long GetTopicMessageCount(string topicName)
        {
            NamespaceManager namespaceManager = CreateNamespaceManager();
            return namespaceManager.GetSubscriptions(topicName).Sum(s => s.MessageCount);
        }

        private NamespaceManager CreateNamespaceManager()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["NServiceBus/Transport"].ConnectionString;
            return NamespaceManager.CreateFromConnectionString(connectionString);
        }
    }
}