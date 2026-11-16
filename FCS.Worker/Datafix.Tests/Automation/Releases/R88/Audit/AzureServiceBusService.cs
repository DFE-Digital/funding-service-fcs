namespace Datafix.Tests.Automation.Releases.R88.Audit
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Configuration;
    using System.Threading.Tasks;
    using Azure.Messaging.ServiceBus;

    public static class AzureServiceBusService
    {
        public static async Task ClearMessagesFromDeadLetterQueue(
            string queueName,
            IReadOnlyCollection<string> messageIds)
        {
            var client = new ServiceBusClient(AzureServiceBusConnectionString);

            var receiver = client.CreateReceiver(
                queueName,
                new ServiceBusReceiverOptions
                {
                    SubQueue = SubQueue.DeadLetter
                });

            while (true)
            {
                var messages = await receiver.ReceiveMessagesAsync(50);

                if (messages == null || messages.Count == 0)
                {
                    break;
                }

                foreach (var message in messages)
                {
                    if (messageIds.Contains(message.MessageId))
                    {
                        await receiver.CompleteMessageAsync(message);
                    }
                    else
                    {
                        // ✅ IMPORTANT: release message back to DLQ
                        await receiver.AbandonMessageAsync(message);
                    }
                }
            }
        }

        private static string AzureServiceBusConnectionString =>
            ConfigurationManager.ConnectionStrings["NServiceBus/Transport"].ConnectionString;
    }
}