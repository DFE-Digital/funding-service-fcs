namespace Datafix.Tests.Automation.Releases.R88
{
    using System.IO;
    using System.Reflection;
    using Newtonsoft.Json;
    using System.Collections.Generic;
    using Microsoft.ServiceBus.Messaging;
    using Audit;
    using Datafix.Tests.Repositories;
    using System.Linq;
    using System.Data.SqlClient;

    public class WriteDeadLetterQueueAuditMessagesToAuditTable : IApplyDataFix
    {
        private static readonly string VeryLargeMessageHeaderKey = "IAmFcsDataBusMessage";

        public string Release => "R88";

        public int StoryNumber => 30145;

        public string Name => "Write Dead Letter Queue Audit Messages To Audit Table";

        public int Order => 1;

        public void ApplyDataFix()
        {
            var brokeredMessages = GetBrokeredMessagesFromJson(
                "Datafix.Tests", "Resources.R88.audit_dead_letter_messages.json");

            brokeredMessages.ToList().ForEach(brokeredMessage =>
            {
                var storageKey = brokeredMessage.Properties[VeryLargeMessageHeaderKey].ToString();

                var largeMessageBodyBytes = LargeMessageRepository.GetMessageBody(storageKey);
                
                WriteMessageToTable(brokeredMessage, largeMessageBodyBytes);
            });

            var messageIds = brokeredMessages.Select(br => br.MessageId).ToList();

            AzureServiceBusService.ClearMessagesFromDeadLetterQueue("audit", messageIds);
        }

        private static IReadOnlyCollection<BrokeredMessage> GetBrokeredMessagesFromJson(string nameSpace, string resourceName)
        {
            using (var stream = Assembly.GetCallingAssembly().GetManifestResourceStream($"{nameSpace}.{resourceName}"))
            using (var streamReader = new StreamReader(stream))
            {
                return JsonConvert.DeserializeObject<List<BrokeredMessage>>(streamReader.ReadToEnd());
            }
        }

        private void WriteMessageToTable(BrokeredMessage brokeredMessage, byte[] body)
        {
            const int UniqueConstraintViolation = 2627;
            var fcsMessage = brokeredMessage.ToFcsMessage(body);

            try
            {
                AuditMessageRepository.Add(
                    messageBytes: fcsMessage.MessageBytes,
                    messageType: fcsMessage.MessageType,
                    sentTime: fcsMessage.SentTime,
                    messageId: fcsMessage.MessageId,
                    originatingEndpoint: fcsMessage.OriginatingEndpoint,
                    processingEndpoint: fcsMessage.ProcessingEndpoint,
                    businessKey: fcsMessage.BusinessKey,
                    propertiesBytes: fcsMessage.PropertiesBytes);
            }
            catch (SqlException sqlE) when (sqlE.Number == UniqueConstraintViolation)
            {
                // we ignore these
            }
        }
    }
}