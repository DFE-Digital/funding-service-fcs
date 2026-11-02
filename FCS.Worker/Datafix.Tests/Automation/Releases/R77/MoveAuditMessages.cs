namespace Datafix.Tests.Automation.Releases.R77
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using Audit;
    using Datafix.Tests.Repositories;
    using Microsoft.ServiceBus.Messaging;

    public class MoveAuditMessages : IApplyDataFix
    {
        private static string TransportConnectionString => ConfigurationManager.ConnectionStrings["NServiceBus/Transport"].ConnectionString;
        public string Release => "R77";
        public int StoryNumber => 27124;
        public string Name => "Move messages from the audit queue to a table in Operations";
        public int Order => 1;

        public void ApplyDataFix()
        {
            var queueClient = CreateQueueClient(queueName: "audit");
            const int batchSize = 100;
            
            do
            {
                List<BrokeredMessage> batchMessages = queueClient.ReceiveBatch(batchSize).ToList();
                if (!batchMessages.Any())
                {
                    break;
                }

                batchMessages.ForEach(m =>
                {
                    try
                    {
                        WriteMesssageToTable(m);
                        m.Complete();
                    }
                    catch (Exception)
                    {
                        m.Abandon();
                    }
                });
                
            } while (true);
        }

        private static QueueClient CreateQueueClient(string queueName)
        {
            return QueueClient.CreateFromConnectionString(TransportConnectionString, queueName);
        }

        private void WriteMesssageToTable(BrokeredMessage brokeredMessage)
        {
            const int UniqueConstraintViolation = 2627;
            var fcsMessage = brokeredMessage.ToFcsMessage();

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
