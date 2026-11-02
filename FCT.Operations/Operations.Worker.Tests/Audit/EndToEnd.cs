namespace Operations.Worker.Tests.Audit
{
    using System;
    using System.Data.Common;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using System.Text;
    using Azure.Messaging.ServiceBus;
    using Dapper;
    using Microsoft.Data.SqlClient;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Newtonsoft.Json;
    using Newtonsoft.Json.Linq;
    using DataStore.Model;
    using Worker.Audit;

    [TestClass]
    public class EndToEnd
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void AuditQueue_ShouldGetTheSameMessageBodyAndPropertiesThatWereWritten()
        {
            RemoveAuditMessage("SFA.FCT.CrossDomain.Integration.Events.PaymentScheduleEvent");

            string messageAsJson = GetBrokeredMessageFromFile();
            var jObject = JsonConvert.DeserializeObject(messageAsJson) as JObject;
            var body = jObject["Body"].ToString();

            byte[] byteArray = Encoding.ASCII.GetBytes(body);

            JToken properties = jObject["Properties"];
            var propertiesDictionary = properties.ToDictionary(p => ((JProperty)p).Name, p => (object)((JProperty)p).Value.ToString());

            ServiceBusReceivedMessage message = ServiceBusModelFactory.ServiceBusReceivedMessage(
                body:new BinaryData(byteArray),
                properties: propertiesDictionary,
                messageId:Guid.NewGuid().ToString());

            var fctMessage = message.ToFcsMessage(m => m.Body.ToArray());

            FcsConfiguration fcsConfiguration = new FcsConfiguration(AppConfiguration.Configuration());

            FcsMessageProcessor.WriteAuditMessageToTable(fctMessage, fcsConfiguration);

            var auditMessage = GetAuditMessage(fctMessage.MessageId.ToString());

            // act
            var messageRetrieved = auditMessage.GetMessageAsJson();
            Assert.AreEqual(body, messageRetrieved, "The message body is not equivalent");

            // act (I know a test should not test 2 things)
            var dictionaryRetrieved = auditMessage.GetPropertiesDictionary();
            Assert.AreEqual(message.ApplicationProperties.Count, dictionaryRetrieved.Count, "The message properties do not have the same number of elements");
            Assert.IsTrue(message.ApplicationProperties.ToList().All(kv => dictionaryRetrieved.ContainsKey(kv.Key)), "All key are not present" );
            var notMatching = message.ApplicationProperties.ToList().First(kv => dictionaryRetrieved[kv.Key] != kv.Value);
            Assert.IsTrue(message.ApplicationProperties.ToList().All(kv => dictionaryRetrieved[kv.Key].ToString() == kv.Value.ToString()), "All values are not present");
        }

        private AuditMessage GetAuditMessage(string messageId)
        {
            const string sql = @"SELECT [MessageId]
                                      ,[MessageType]
                                      ,[SentTime]
                                      ,[OriginatingEndpoint]
                                      ,[ProcessingEndpoint]
                                      ,[BusinessKey]
                                      ,[MessageBytes]
                                      ,[PropertiesBytes]
                                  FROM [Operations].[AuditMessage]
                                  WHERE MessageId = @messageId";

            var connectionString = AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"];
            DbConnection connection = new SqlConnection($@"{connectionString}");

            return connection.QuerySingleOrDefault<AuditMessage>(sql, new { messageId });
        }

        private void RemoveAuditMessage(string messageType)
        {
            var connectionString = AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"];
            DbConnection connection = new SqlConnection($@"{connectionString}");
            const string sql = "delete from Operations.AuditMessage where MessageType = @messageType";

            connection.Execute(sql, param: new {messageType});
        }

        private string GetBrokeredMessageFromFile()
        {
            return GetJson("Operations.Worker.Tests", "Resources.FctMessage.json");
        }

        private static string GetJson(string nameSpace, string resourceName)
        {
            using (Stream stream = Assembly.GetCallingAssembly().GetManifestResourceStream($"{nameSpace}.{resourceName}"))
            using (StreamReader streamReader = new StreamReader(stream))
            {
                return streamReader.ReadToEnd();
            }
        }
    }
}
