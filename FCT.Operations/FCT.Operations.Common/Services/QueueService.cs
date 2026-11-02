namespace SFA.FCT.Operations.Common.Services
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.IO;
    using System.IO.Compression;
    using System.Linq;
    using System.Text;
    using Extensions;
    using DTOs;
    using Microsoft.ServiceBus;
    using Microsoft.ServiceBus.Messaging;

    public class QueueService : IQueueCommandService, IQueueQueryService
    {
        private static string TransportConnectionString => ConfigurationManager.ConnectionStrings["NServiceBus/Transport"].ConnectionString;

        public MessageDetail GetMessageDetail(string queueName, string messageId)
        {
            BrokeredMessage message = FindMessageById(queueName: queueName, messageId: messageId);

            if (message != null)
            {
                string messageBody = ExtractMessageBody(message);

                string messageType = ExtractMessageType(message);

                string endpointName = ExtractEndpointName(message);

                return new MessageDetail(messageId: messageId,
                    messageType: messageType,
                    messageBody: messageBody,
                    endpointName: endpointName);
            }

            return null;
        }

        public IList<MessageDetail> GetMessageDetails(
            string queueName,
            string messageType,
            DateTime timeRangeStartUtc,
            DateTime timeRangeEndUtc,
            long fromSequenceNo,
            Func<MessageDetail, bool> matchMessage)
        {
            const int batchSize = 1000;
            QueueClient queueClient = CreateQueueClient(queueName);
            List<BrokeredMessage> allMatchingMessages = new List<BrokeredMessage>();

            do
            {
                try
                {
                    List<BrokeredMessage> batchMessages = queueClient.PeekBatch(fromSequenceNo, batchSize).ToList();
                    if (!batchMessages.Any())
                    {
                        break;
                    }

                    IEnumerable<BrokeredMessage> matchingBatchMessages = batchMessages
                        .Where(m => IsTimeWithinRange(m.EnqueuedTimeUtc, timeRangeStartUtc, timeRangeEndUtc) && IsMessageType(m, messageType));

                    allMatchingMessages.AddRange(matchingBatchMessages); 

                    BrokeredMessage lastMessageInPeekBatch = batchMessages.Last();

                    if (IsTimeBeyondRange(lastMessageInPeekBatch.EnqueuedTimeUtc, timeRangeEndUtc))
                    {
                        break;
                    }

                    fromSequenceNo = lastMessageInPeekBatch.SequenceNumber + 1;
                }
                catch (Exception)
                {
                    queueClient = CreateQueueClient(queueName);
                }
            } while (true);

            IEnumerable<MessageDetail> messageDtos = allMatchingMessages
                .Select(m => new MessageDetail(
                    messageId: m.MessageId,
                    messageType: ExtractMessageType(m),
                    messageBody: ExtractMessageBody(m),
                    endpointName: ExtractEndpointName(m)));

            return messageDtos
                .Where(matchMessage)
                .ToList();
        }

        public long GetQueueSizeInBytes(string queueName)
        {
            NamespaceManager namespaceManager = CreateNamespaceManager();

            return namespaceManager.GetQueue(queueName).SizeInBytes;
        }

        public void DeleteMessagesFromQueue(string queueName, int numberOfMessagesToDelete)
        {
            QueueClient queueClient = CreateQueueClient(queueName);

            IEnumerable<BrokeredMessage> messages = queueClient.ReceiveBatch(numberOfMessagesToDelete);

            if (messages != null && messages.Any())
            {
                queueClient.CompleteBatch(messages.Select(m => m.LockToken));
            }
        }

        private static bool IsTimeWithinRange(DateTime enqueuedTimeUtc, DateTime startRangeTime, DateTime endRangeTime)
        {
            return enqueuedTimeUtc < endRangeTime && enqueuedTimeUtc > startRangeTime;
        }

        private static bool IsTimeBeyondRange(DateTime enqueuedTimeUtc, DateTime endRangeTime)
        {
            return enqueuedTimeUtc > endRangeTime;
        }

        private static bool IsMessageType(BrokeredMessage brokeredMessage, string messageType)
        {
            const string nserviceBusMessageTypeProperty = "NServiceBus.EnclosedMessageTypes";
            bool isMessageTypeCorrect = false;

            if (brokeredMessage.Properties.ContainsKey(nserviceBusMessageTypeProperty))
            {
                string propertyValue = brokeredMessage.Properties[nserviceBusMessageTypeProperty] as string;
                isMessageTypeCorrect = propertyValue.Contains(messageType);
            }

            return isMessageTypeCorrect;
        }

        private static string ExtractEndpointName(BrokeredMessage message)
        {
            const string originatingEndpointProperty = "NServiceBus.OriginatingEndpoint";

            if (message.Properties.ContainsKey(originatingEndpointProperty))
            {
                return message.Properties[originatingEndpointProperty] as string;
            }

            throw new ArgumentException($"The message does not contain the property {originatingEndpointProperty}");
        }

        private static string ExtractMessageType(BrokeredMessage message)
        {
            // the message type live in the custom section
            const string nserviceBusMessageTypeProperty = "NServiceBus.EnclosedMessageTypes";
            
            if (message.Properties.ContainsKey(nserviceBusMessageTypeProperty))
            {
                string fullyQualifiedMessageTypeValue = message.Properties[nserviceBusMessageTypeProperty] as string;
                
                // we just want the string before the first comma
                return fullyQualifiedMessageTypeValue.GetSubstringBeforeCharacter(",");
            }

            throw new ArgumentException($"The message does not contain the property {nserviceBusMessageTypeProperty}");
        }

        private static BrokeredMessage FindMessageById(string queueName, string messageId)
        {
            BrokeredMessage foundMessage = null;
            QueueClient queueClient = CreateQueueClient(queueName);
            const int batchSize = 10;
            long startSequence = 0;            
            do
            {
                IEnumerable<BrokeredMessage> messages = queueClient.PeekBatch(startSequence, batchSize).ToList();
                if (messages.Any())
                {
                    foundMessage = messages.SingleOrDefault(m => m.MessageId == messageId);

                    startSequence = messages.Last().SequenceNumber + 1;
                }
                else
                {
                    // we have reached the end and not found the message
                    break;
                }
            } while (foundMessage == null);

            return foundMessage;
        }

        private static string ExtractMessageBody(BrokeredMessage message)
        {
            string messageBody;
            byte[] bytes = message.Clone().GetBody<byte[]>();
            try
            {
                if (message.Clone().GetBody<byte[]>().IsZipped())
                {
                    messageBody = UnZipMessage(message);
                }
                else
                {
                    messageBody = Encoding.UTF8.GetString(message.GetBody<byte[]>());
                }
            }
            catch(Exception e)
            {
                using (GZipStream bigStream = new GZipStream(new MemoryStream(bytes), CompressionMode.Decompress))
                {
                    MemoryStream bigStreamOut = new MemoryStream();
                    bigStream.CopyToAsync(bigStreamOut).Wait();
                    byte[] uncompressedBytes = bigStreamOut.ToArray();
                    messageBody = Encoding.UTF8.GetString(uncompressedBytes);
                }

               // messageBody = "Unable to read the message body.";
            }

            return messageBody;
        }

        private static string UnZipMessage(BrokeredMessage message)
        {
            Stream stream = message.GetBody<Stream>();

            string messageText = String.Empty;
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

        private static string GetStringFromByteArray(byte[] bytes)
        {
            using (GZipStream uncompressedStream = new GZipStream(new MemoryStream(bytes), CompressionMode.Decompress))
            {
                MemoryStream ms = new MemoryStream();
                uncompressedStream.CopyTo(ms);
                ms.Position = 0;
                bytes = new byte[ms.Length];
                ms.Read(bytes, 0, bytes.Length);
            }

            string messageText;
            using (MemoryStream ms = new MemoryStream(bytes.ToArray()))
            {
                using (StreamReader sr = new StreamReader(ms))
                {
                    messageText = sr.ReadToEnd();
                }
            }

            return messageText;
        }

        private static QueueClient CreateQueueClient(string queueName)
        {
            return QueueClient.CreateFromConnectionString(TransportConnectionString, queueName);
        }

        private static NamespaceManager CreateNamespaceManager()
        {
            return NamespaceManager.CreateFromConnectionString(TransportConnectionString);
        }
    }

    public static class ByteArrayExtensions
    {
        public static bool IsZipped(this byte[] data)
        {
            byte[] gzipHeaderBytes = new byte[] { 0x1f, 0x8b, 8, 0, 0, 0, 0, 0, 4, 0 };

            if (data != null && data.Length >= gzipHeaderBytes.Length)
            {
                var header = data.Take(gzipHeaderBytes.Length);
                return header.SequenceEqual(gzipHeaderBytes);
            }

            return false;
        }
    }
}
