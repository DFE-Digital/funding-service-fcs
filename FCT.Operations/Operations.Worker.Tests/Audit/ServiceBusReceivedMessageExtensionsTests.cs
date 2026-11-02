namespace Operations.Worker.Tests.Audit
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using System.Text;
    using Azure.Messaging.ServiceBus;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Newtonsoft.Json;
    using Newtonsoft.Json.Linq;
    using Worker.Audit;

    [TestClass]
    public class ServiceBusReceivedMessageExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ServiceBusReceivedMessageExtensions_ShouldMapToFcsMessage()
        {
            // arrange
            string messageAsJson = GetBrokeredMessageFromFile();
            var jObject = JsonConvert.DeserializeObject(messageAsJson) as JObject;
            var body = jObject["Body"].ToString();
            
            byte[] byteArray = Encoding.ASCII.GetBytes(body);

            JToken properties = jObject["Properties"];
            var propertiesDictionary = properties.ToDictionary(p => ((JProperty)p).Name, p => (object)((JProperty)p).Value.ToString());

            ServiceBusReceivedMessage brokeredMessage = ServiceBusModelFactory.ServiceBusReceivedMessage(
                body:new BinaryData(byteArray),
                properties:propertiesDictionary,
                messageId: Guid.NewGuid().ToString());

            //foreach (JProperty property in properties)
            //{
            //    brokeredMessage.ApplicationProperties.Add(property.Name, property.Value.ToString());
            //}

            // act
            var fctMessage = brokeredMessage.ToFcsMessage(m => m.Body.ToArray());

            // assert
            DateTime expectedTimeSent = new DateTime(2019,12,16,7,47,59, DateTimeKind.Utc);
            DateTime timeSentWithoutMilliseconds = fctMessage.SentTime.AddTicks(-(fctMessage.SentTime.Ticks % TimeSpan.TicksPerSecond));
            Assert.AreEqual(expectedTimeSent, timeSentWithoutMilliseconds, "The time sent is not correct");
            Assert.AreEqual("PaymentManagementDomain.PaymentAggregation", fctMessage.ProcessingEndpoint, "The processing endpoint is not correct");
            Assert.AreEqual("PaymentManagementDomain.PaymentSchedule", fctMessage.OriginatingEndpoint, "The processing endpoint is not correct");
            Assert.AreEqual("SFA.FCT.CrossDomain.Integration.Events.PaymentScheduleEvent", fctMessage.MessageType, "The MessageType is not correct");
            Assert.AreEqual("ContractNumber=APPLEVY-732, AllocationNumber=LEVY-732, VersionNumber=1", fctMessage.BusinessKey, "The BusinessKey is not correct");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ServiceBusReceivedMessageExtensions_ShouldMapMessageWithBodyInFcsDataBusStorageToFcsMessage()
        {
            // arrange
          //  BrokeredMessage brokeredMessage = new BrokeredMessage(Encoding.ASCII.GetBytes("{\"the-body-is-in-blob-storage\":}"));
            Dictionary<string, object> dictionary = new Dictionary<string, object>();
            dictionary.Add("IAmFcsDataBusMessage", Guid.NewGuid().ToString());
            dictionary.Add("NServiceBus.TimeSent", "2019-12-16 07:47:59:931312 Z");
            dictionary.Add("NServiceBus.OriginatingEndpoint", "PaymentManagementDomain.PaymentSchedule");
            dictionary.Add("NServiceBus.ProcessingEndpoint", "PaymentManagementDomain.PaymentAggregation");
            dictionary.Add("NServiceBus.EnclosedMessageTypes", "SFA.FCT.CrossDomain.Integration.Events.PaymentScheduleEvent, CrossDomain.Integration.Events, Version=1.0.0.0, Culture=neutral, PublicKeyToken=6226b767697cf1cd;SFA.FCT.CrossDomain.Integration.Events.IDeferrableEvent, CrossDomain.Integration.Events, Version=1.0.0.0, Culture=neutral, PublicKeyToken=6226b767697cf1cd");

            byte[] largeMessageBodyBytes = Encoding.ASCII.GetBytes(GetJson("Operations.Worker.Tests", "Resources.VeryLargeMessageBody.json"));

            ServiceBusReceivedMessage message = ServiceBusModelFactory.ServiceBusReceivedMessage(
                body:new BinaryData(largeMessageBodyBytes),
                properties: dictionary,
                messageId:Guid.NewGuid().ToString());
            // act
            FcsMessage fctMessage = message.ToFcsMessage(m => largeMessageBodyBytes);

            // assert
            Assert.AreEqual("ContractNumber=ESIF-2129, AllocationNumber=ESF-2133, VersionNumber=11", fctMessage.BusinessKey, "The BusinessKey is not correct");
        }


        [TestMethod, TestCategory("UnitTest")]
        public void ServiceBusReceivedMessageExtensions_ShouldIdentifyWhenMessageIsFcsDataBusMessage()
        {
            // arrange
            Dictionary<string, object> properties = new Dictionary<string, object>
            {
               {"IAmFcsDataBusMessage", Guid.NewGuid()}
            }; 
            ServiceBusReceivedMessage message = ServiceBusModelFactory.ServiceBusReceivedMessage(new BinaryData(new byte[0]), properties: properties);

            // act
            bool isFcsDataBusMessage = message.IsFcsDataBusMessage();

            // assert
            Assert.IsTrue(isFcsDataBusMessage, "Should return true");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ServiceBusReceivedMessageExtensions_ShouldIdentifyWhenMessageIsNotFcsDataBusMessage()
        {
            // arrange
            Dictionary<string, object> properties = new Dictionary<string, object>
            {
                {"MessageId", Guid.NewGuid()}
            };
            ServiceBusReceivedMessage message = ServiceBusModelFactory.ServiceBusReceivedMessage(new BinaryData(new byte[0]), properties: properties);

            // act
            bool isFcsDataBusMessage = message.IsFcsDataBusMessage();

            // assert
            Assert.IsFalse(isFcsDataBusMessage, "Should return false");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ServiceBusReceivedMessageExtensions_ShouldGetFcsDataBusKey()
        {
            // arrange
            string fcsDataBusKey = Guid.NewGuid().ToString();
            Dictionary<string, object> properties = new Dictionary<string, object>
            {
                {"IAmFcsDataBusMessage", fcsDataBusKey}
            };
            ServiceBusReceivedMessage message = ServiceBusModelFactory.ServiceBusReceivedMessage(new BinaryData(new byte[0]), properties: properties);

            // act
            string returnedFcsDataBusKey = message.GetFcsDataBusKey();

            // assert
            Assert.AreEqual(fcsDataBusKey, returnedFcsDataBusKey, "Should return FcsDataBus key");
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
