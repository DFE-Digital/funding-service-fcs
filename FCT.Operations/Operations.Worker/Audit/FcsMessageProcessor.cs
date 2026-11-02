namespace Operations.Worker.Audit
{
    using System.Data.SqlClient;
    using DataStore.Model;
    using DataStore.Repositories;
    using SFA.FCS.Worker.Common;

    public static class FcsMessageProcessor
    {
        public static void WriteAuditMessageToTable(FcsMessage message, IFcsConfiguration configuration)
        {
            var sqlConnection = new SqlConnection(configuration["ConnectionStrings:NServiceBus/Persistence"]);

             AuditMessageRepository.Add(new AuditMessage(
                messageBytes: message.MessageBytes,
                messageType: message.MessageType,
                sentTime: message.SentTime,
                messageId: message.MessageId,
                originatingEndpoint: message.OriginatingEndpoint,
                processingEndpoint: message.ProcessingEndpoint,
                businessKey: message.BusinessKey,
                propertiesBytes: message.PropertiesBytes), sqlConnection).Wait();
        }
    }
}
