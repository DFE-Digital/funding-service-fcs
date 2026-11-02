namespace Datafix.Tests.Tests.R88.Audit
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using System.IO;
    using System.Reflection;
    using Newtonsoft.Json;
    using System.Collections.Generic;
    using Microsoft.ServiceBus.Messaging;
    using System.Linq;
    using System.Configuration;
    using Datafix.Tests.Automation.Releases.R88.Audit;

    [TestClass]
    public class AzureServiceBusServiceTests
    {
        [TestMethod, TestCategory("TechnicalExploration")] 
        public void AzureServiceBusService_ClearMessagesFromDeadLetterQueue_RemoveCorrectMessages()
        {
            // arrange 
            const string auditQueueName = "audit";
            var clientAuditQueue = GetQueueClient(auditQueueName);
            var clientAuditDeadLetterQueue = GetQueueClient(QueueClient.FormatDeadLetterPath(auditQueueName));

            ClearQueue(clientAuditQueue);
            ClearQueue(clientAuditDeadLetterQueue);

            var brokeredMessages = GetBrokeredMessagesFromJson(
                "Datafix.Tests", "Resources.R88.audit_dead_letter_messages.json");
            
            AddTheAssertMessagesToQueue(clientAuditQueue, brokeredMessages);
            AddOneRandomMessageToQueue(clientAuditQueue, brokeredMessages.First());
            
            MoveAllAuditMessagesToDeadLetterQueue(clientAuditQueue);

            var messageIds = brokeredMessages.Select(bm => bm.MessageId).ToList();

            // Act
            AzureServiceBusService.ClearMessagesFromDeadLetterQueue(auditQueueName, messageIds);
            
            // check the 27 messages are not in the dead letter queue but the random one is still there
        }

        private static void ClearQueue(QueueClient client)
        {
            while (client.Peek() != null)
            {
                var brokeredMessage = client.Receive();
                brokeredMessage?.Complete();
            }
        }

        private static void AddTheAssertMessagesToQueue(QueueClient client, IReadOnlyCollection<BrokeredMessage> brokeredMessages)
        {
            brokeredMessages.ToList().ForEach(brokeredMessage =>
            {
                client.Send(brokeredMessage);
            });
        }

        private static void AddOneRandomMessageToQueue(QueueClient client, BrokeredMessage brokeredMessage)
        {
            var randomBrokeredMessage = brokeredMessage.Clone();
            randomBrokeredMessage.MessageId = "55555555-4444-3333-2222-111111111111";

            client.Send(randomBrokeredMessage);
        }

        private static void MoveAllAuditMessagesToDeadLetterQueue(QueueClient client)
        {
            while (client.Peek() != null)
            {
                var receivedMessage = client.Receive();
                receivedMessage.DeadLetter();
            }
        }

        private static IReadOnlyCollection<BrokeredMessage> GetBrokeredMessagesFromJson(string nameSpace, string resourceName)
        {
            using (var stream = Assembly.GetCallingAssembly().GetManifestResourceStream($"{nameSpace}.{resourceName}"))
            using (var streamReader = new StreamReader(stream))
            {
                return JsonConvert.DeserializeObject<List<BrokeredMessage>>(streamReader.ReadToEnd());
            }
        }
        
        private static QueueClient GetQueueClient(string queueName) => QueueClient.CreateFromConnectionString(AzureServiceBusConnectionString, queueName);

        private static string AzureServiceBusConnectionString => ConfigurationManager.ConnectionStrings["NServiceBus/Transport"].ConnectionString;
    }
}