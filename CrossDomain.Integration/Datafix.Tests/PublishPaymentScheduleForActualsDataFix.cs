namespace Datafix.Tests
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.IO;
    using System.IO.Compression;
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Microsoft.ServiceBus.Messaging;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using Newtonsoft.Json;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Handlers;
    using JsonSerializer = NServiceBus.JsonSerializer;

    [TestClass]
    public class PublishPaymentScheduleForActualsDataFix
    {
        private const string TransportString =
            "Endpoint=sb://fct-nservicebus-release.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=";

        [TestMethod, TestCategory("DataFix_ALLF_A36_MonthEnd")]
        public void PublishPaymentScheduleForActuals_ShouldGetActualsFromQueueAndPublishEvent()
        {
            var messages = GetMessages();

            var handler = GetContainer().Resolve<IHandleMessages<IAllocationActualsVerified>>();

            messages.ForEach(m => handler.Handle(m));
        }

        private IWindsorContainer GetContainer()
        {
            ConfigurationManager.AppSettings["UseRealDate"] = "true";
            IWindsorContainer container = new WindsorContainer().Install(new SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.IoC.WindsorInstaller(new LoggerFactory()));
            container.Register(Component.For<IHandleMessages<AllocationActualsVerified>>()
                .ImplementedBy<AllocationActualsVerifiedHandler>());

            container.Register(Component.For<IBus>().Instance(CreateBus()));
            
            container.BeginScope();

            return container;
        }

        private static IBus CreateBus()
        {
            var configuration = new BusConfiguration();

            configuration.AssembliesToScan(
                AllAssemblies.Matching("CrossDomain.Integration.Events.dll")
                    .And("Microsoft.WindowsAzure.Configuration.dll")
                    .And("NServiceBus.Azure.Transports.WindowsAzureServiceBus.dll"));

            configuration.UseTransport<AzureServiceBusTransport>();

            configuration.ScaleOut().UseSingleBrokerQueue();

            configuration.UseSerialization<JsonSerializer>();
            configuration.UsePersistence<InMemoryPersistence>();
            configuration.Conventions()
                .DefiningEventsAs(t => null != t.Namespace && t.Namespace.EndsWith("Events"))
                .DefiningCommandsAs(t => null != t.Namespace && t.Namespace.EndsWith("Commands"));

            configuration.EndpointName("PaymentManagementDomain.PaymentSchedule");
            return Bus.Create(configuration);
        }

        private IReadOnlyCollection<AllocationActualsVerified> GetMessages()
        {
            List<BrokeredMessage> allMatchingMessages = new List<BrokeredMessage>();

            const string auditQueueName = "error.log";
            QueueClient queueClient = CreateQueueClient(auditQueueName);
            const int batchSize = 1000;
            long startSequence = 291000001;

            do
            {
                try
                {
                    IEnumerable<BrokeredMessage> messages = queueClient.PeekBatch(startSequence, batchSize).ToList();
                    if (!messages.Any())
                    {
                        break;
                    }

                    var matchingMessages = messages.Where(
                        m =>
                            IsMessageType(m, "AllocationActualsVerified"));
                    allMatchingMessages.AddRange(matchingMessages);
                    BrokeredMessage lastMessageInPeekBatch = messages.Last();
                    
                    startSequence = lastMessageInPeekBatch.SequenceNumber + 1;
                }
                catch (Exception)
                {
                    queueClient = CreateQueueClient(auditQueueName);
                }

            } while (true);

            List<string> fctMessages = allMatchingMessages.Select(ExtractFctMessage).ToList();

            var events = fctMessages.Select(JsonConvert.DeserializeObject<AllocationActualsVerified>).ToList();

            return events;
        }

        private bool IsMessageType(BrokeredMessage brokeredMessage, string messageType)
        {
            const string nserviceBusMessageTypeProperty = "NServiceBus.EnclosedMessageTypes";
            bool isMessageTypeCorrect = false;

            if (brokeredMessage.Properties.ContainsKey(nserviceBusMessageTypeProperty))
            {
                string propertypeValue = brokeredMessage.Properties[nserviceBusMessageTypeProperty] as string;
                isMessageTypeCorrect = propertypeValue.Contains(messageType);
            }

            return isMessageTypeCorrect;
        }

        private static QueueClient CreateQueueClient(string queueName)
        {
            return QueueClient.CreateFromConnectionString(TransportString, queueName);
        }

        private string ExtractFctMessage(BrokeredMessage message)
        {
            try
            {
                const string amICompressedProperty = "IWasCompressed";
                if (message.Properties.ContainsKey(amICompressedProperty) &&
                    (string)message.Properties[amICompressedProperty] == "true")
                {
                    return UnZipMessage(message);
                }
                else
                {
                    throw new ArgumentException("We only support zipped messages at the moment");
                }
            }
            catch (Exception e)
            {
                Assert.Fail(e.Message);
            }

            return string.Empty;
        }

        private string UnZipMessage(BrokeredMessage message)
        {
            Stream stream = message.GetBody<Stream>();

            string messageText;
            stream.Seek(0, SeekOrigin.Begin);
            using (var reader = new StreamReader(stream))
            {
                messageText = reader.ReadToEnd();
                if (messageText.ToCharArray().GroupBy(c => c).
                    Where(g => char.IsControl(g.Key) && g.Key != '\t' && g.Key != '\n' && g.Key != '\r').
                    Select(g => g.First()).Any())
                {
                    byte[] bytes;
                    stream.Seek(0, SeekOrigin.Begin);
                    using (var binaryReader = new BinaryReader(stream))
                    {
                        bytes = binaryReader.ReadBytes((int)stream.Length);
                    }

                    if (bytes[0] == 0x40 && bytes[1] == 0x0C && bytes[14] == 0x08 && bytes[15] == 0x33)
                    {
                        int offset = 67;
                        //messageText = string.Empty;
                        List<byte> completeMessage = new List<byte>();
                        while (offset < bytes.Length)
                        {
                            byte messageType = bytes[offset++];
                            var entryLength = 0;
                            switch (messageType)
                            {
                                case 0xA0:
                                case 0xA1:
                                    entryLength = bytes[offset++] + (bytes[offset++] * 0x100);
                                    if (bytes[offset] == 0xEF && bytes[offset + 1] == 0xBB && bytes[offset + 2] == 0xBF && bytes[offset + 3] == 0x7B)
                                    {
                                        offset += 3;
                                    }

                                    completeMessage.AddRange(bytes.Skip(offset).Take(entryLength - 3));
                                    offset += entryLength - 3;

                                    break;

                                case 0x9E:
                                case 0x9f:
                                    entryLength = bytes[offset++];
                                    completeMessage.AddRange(bytes.Skip(offset).Take(entryLength));
                                    offset += entryLength;
                                    break;
                            }
                        }

                        messageText = GetStringFromByteArray(completeMessage.ToArray());
                    }
                    else
                    {
                        messageText = BitConverter.ToString(bytes).Replace('-', ' ');
                    }
                }
            }

            return messageText;
        }

        private string GetStringFromByteArray(byte[] bytes)
        {
            using (GZipStream uncompressedStream = new GZipStream(new MemoryStream(bytes), CompressionMode.Decompress))
            {
                MemoryStream ms = new MemoryStream();
                uncompressedStream.CopyTo(ms);
                ms.Position = 0;
                bytes = new byte[ms.Length];
                ms.Read(bytes, 0, bytes.Length);
            }

            string messageText = string.Empty;
            using (MemoryStream ms = new MemoryStream(bytes.ToArray()))
            {
                using (StreamReader sr = new StreamReader(ms))
                {
                    messageText = sr.ReadToEnd();
                }
            }

            return messageText;
        }
    }
}
