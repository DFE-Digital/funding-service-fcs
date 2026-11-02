namespace Datafix.Tests.Automation.Releases.R88.Audit
{
    using System.Collections.Generic;
    using Microsoft.ServiceBus.Messaging;
    using System.Linq;
    using System.Configuration;

    public static class AzureServiceBusService
    {
        public static void ClearMessagesFromDeadLetterQueue(string queueName, IReadOnlyCollection<string> messageIds)
        {
            var client = GetQueueClient(QueueClient.FormatDeadLetterPath(queueName));

            while (client.Peek() != null)
            {
                var brokeredMessage = client.Receive();

                if (messageIds.Contains(brokeredMessage.MessageId))
                {
                    brokeredMessage.Complete();
                }
            }
        }

        private static QueueClient GetQueueClient(string queueName) => QueueClient.CreateFromConnectionString(AzureServiceBusConnectionString, queueName);

        private static string AzureServiceBusConnectionString => ConfigurationManager.ConnectionStrings["NServiceBus/Transport"].ConnectionString;
    }
}