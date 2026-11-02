namespace Operations.Web.Notifiers
{
    using System;
    using System.Configuration;
    using System.Linq;
    using System.Threading.Tasks;
    using Dtos;
    using Microsoft.ServiceBus;
    using Microsoft.ServiceBus.Messaging;

    public class ErrorQueueNotifier : INotifier
    {
        private static readonly string[] ErrorQueueNames =
        {
            "error",
            "error-1",
            "error.log"
        };

        public async Task<Notification> GetNotification()
        {
            try
            {
                const string notificationName = "Error Queue Is Not Empty";

                NamespaceManager namespaceManager = GetNamespaceManager();
                long[] queueMessageCounts = await Task.WhenAll(ErrorQueueNames.Select(queueName => GetMessageCountAsync(queueName, namespaceManager)));
                bool areAllErrorQueuesEmpty = queueMessageCounts.All(count => count == 0);

                return areAllErrorQueuesEmpty ? null :
                    new Notification($"{queueMessageCounts.Sum()} Item(s) on Error Queue", notificationName, NotificationType.Error);
            }
            catch (Exception)
            {
                return null; 
            }
        }

        private static NamespaceManager GetNamespaceManager()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["NServiceBus/Transport"].ConnectionString;
            return NamespaceManager.CreateFromConnectionString(connectionString);
        }

        private static async Task<long> GetMessageCountAsync(string queueName, NamespaceManager namespaceManager)
        {
            if (await namespaceManager.QueueExistsAsync(queueName))
            {
                QueueDescription queue = await namespaceManager.GetQueueAsync(queueName);
                return queue.MessageCount;
            }

            return 0;
        }
    }
}