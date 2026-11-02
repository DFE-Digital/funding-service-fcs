namespace PaymentGenerationDomain.Integration.PaymentGeneration.Datafixes
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.IO.Compression;
    using System.Linq;
    using Castle.Core.Internal;
    using Microsoft.ServiceBus;
    using Microsoft.ServiceBus.Messaging;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class PaymentAggregatedEventsDatafix
    {
        private string _exceptionInfo = String.Empty;
        private long _currentSequence;
        private const string TransportString =
            "Endpoint=sb://fct-nservicebus-release.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=";

        [TestMethod, TestCategory("DataFix_R12")]
        public void PaymentAggregatedEvents_ShouldParticularEventFromAzureServiceBus()
        {
            // this is to help us patch the system following an Approval that occurred during month end
            const string auditQueueName = "audit.log";
            QueueClient queueClient = CreateQueueClient(auditQueueName);

            const int batchSize = 1000;
            long startSequence = 9237632;
            List<BrokeredMessage> allMatchingMessages = new List<BrokeredMessage>();
            
            // {[NServiceBus.EnclosedMessageTypes, SFA.FCT.CrossDomain.Integration.Events.PaymentScheduleEvent, CrossDomain.Integration.Events, Version=1.0.0.0, Culture=neutral, PublicKeyToken=6226b767697cf1cd]}
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
                            IsTimeWithinRange(m.EnqueuedTimeUtc) && IsMessageType(m, "PaymentAggregatedEvent"));
                    allMatchingMessages.AddRange(matchingMessages);
                    BrokeredMessage lastMessageInPeekBatch = messages.Last();
                    if (IsTimeBeyondRange(lastMessageInPeekBatch.EnqueuedTimeUtc))
                    {
                        break;
                    }
                    startSequence = lastMessageInPeekBatch.SequenceNumber + 1;
                }
                catch (Exception)
                {
                    queueClient = CreateQueueClient(auditQueueName);
                }

            } while (true);

            var fctMessages = allMatchingMessages.Select(ExtractFctMessage).ToList();
            WriteDataToFile(fctMessages);

            Assert.AreEqual(String.Empty, _exceptionInfo);
        }

        private void WriteDataToFile(IEnumerable<string> messages)
        {
            using (var file = new System.IO.StreamWriter(Guid.NewGuid() + ".json"))
            {
                messages.ToList().ForEach(file.WriteLine);
            }
        }

        private bool IsTimeWithinRange(DateTime enqueuedTimeUtc)
        {

            return enqueuedTimeUtc.Year == 2016 &&
                   enqueuedTimeUtc.Month == 10 &&
                   enqueuedTimeUtc.Day == 21 &&
                   enqueuedTimeUtc.Hour == 16 &&
            enqueuedTimeUtc.Minute > 1 &&
             enqueuedTimeUtc.Minute < 6;
        }

        private bool IsTimeBeyondRange(DateTime enqueuedTimeUtc)
        {
            return enqueuedTimeUtc > new DateTime(2016, 10, 21, 16, 6, 0, DateTimeKind.Utc);
            
        }


        private string ExtractFctMessage(BrokeredMessage message)
        {
            try
            {
                const string amICompressedProperty = "IWasCompressed";
                if (message.Properties.ContainsKey(amICompressedProperty) &&
                    (string) message.Properties[amICompressedProperty] == "true")
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
                _exceptionInfo = e.Message;
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

        private static int GetNumMessagesOnQueue(string queueName)
        {
            NamespaceManager namespaceManager = CreateNamespaceManager();

            QueueDescription errorQueueInfo = namespaceManager.GetQueues()
                .First(q => q.Path.ToLower().Contains(queueName));

            return (int)errorQueueInfo.MessageCount;
        }

        private static NamespaceManager CreateNamespaceManager()
        {
            return NamespaceManager.CreateFromConnectionString(TransportString);
        }
    }
}
