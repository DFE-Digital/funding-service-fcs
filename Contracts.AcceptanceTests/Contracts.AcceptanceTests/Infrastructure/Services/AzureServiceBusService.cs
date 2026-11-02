namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Services
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using Microsoft.ServiceBus;

    public static class AzureServiceBusService
    {
        private static readonly string ConnectionString = ConfigurationManager.ConnectionStrings["NServiceBus/Transport"].ConnectionString;

        public static long GetTotalTopicMessageCount(IReadOnlyCollection<string> topicsToIgnore)
        {
            NamespaceManager namespaceManager = NamespaceManager.CreateFromConnectionString(ConnectionString);
            var topics = namespaceManager.GetTopics().ToList();
            return topics.Where(t => !topicsToIgnore.Contains(t.Path))
                .Sum(t => namespaceManager.GetSubscriptions(t.Path).Sum(s => s.MessageCount));
        }

        public static long GetQueueMessageCount(string queueName)
        {
            NamespaceManager namespaceManager = NamespaceManager.CreateFromConnectionString(ConnectionString);
            return namespaceManager.GetQueue(queueName).MessageCount;
        }
    }
}
