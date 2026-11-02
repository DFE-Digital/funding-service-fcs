namespace Operations.Worker.Audit
{
    using System;
    using System.Collections.Generic;
    using System.Globalization;
    using System.IO;
    using System.IO.Compression;
    using System.Linq;
    //using System.Runtime.Serialization.Formatters.Binary;
    using Azure.Messaging.ServiceBus;
    using Newtonsoft.Json.Linq;
    using Operations.Worker.Extensions;
    using System.Text.Json;

    public static class ServiceBusReceivedMessageExtensions
    {
        private const string VeryLargeMessageHeaderKey = "IAmFcsDataBusMessage";
        private static readonly IReadOnlyCollection<string> BusinessKeyAttributes = new List<string>
            { "ContractNumber", "AllocationNumber", "VersionNumber", "Ukprn", "FundingId" };

        public static FcsMessage ToFcsMessage(this ServiceBusReceivedMessage message, Func<ServiceBusReceivedMessage, byte[]> getMessageBody)
        {
            var messageBytes = getMessageBody(message);
            messageBytes = messageBytes.RemoveHeaderIfZippedOrUnZipped();
            var unZippedBytes = GetUnZippedBytes(messageBytes);
            var justTheJsonBytes = unZippedBytes.RemoveAnythingBeforeOrAfterTheCurlyBraces();
            string text = GetStringFromBytes(justTheJsonBytes);
            text = text.CleanOddCharsFromJson();
            var timeSentString = message.GetNServiceBusProperty("NServiceBus.TimeSent");
            // e.g 2019-12-16 07:47:59:931312 Z
            var timeSent = DateTime.ParseExact(
                timeSentString,
                "yyyy-MM-dd HH:mm:ss:ffffff 'Z'",
                null,
                DateTimeStyles.AssumeUniversal|DateTimeStyles.AdjustToUniversal);

            return new FcsMessage(
                messageBytes,
                message.GetMessageType(),
                timeSent,
                Guid.Parse(message.MessageId),
                message.GetNServiceBusProperty("NServiceBus.OriginatingEndpoint"),
                message.GetNServiceBusProperty("NServiceBus.ProcessingEndpoint"),
                GetBusinessKeyFromMessage(text),
                ConvertObjectToBytes(message.ApplicationProperties));
        }

        public static byte[] GetBytes(this ServiceBusReceivedMessage message)
        {
            byte[] messageBytes = null;
            try
            {
                messageBytes = message.Body.ToArray();
            }
            catch (Exception)
            {
                // ignored
            }

            var version = message.GetNServiceBusProperty("NServiceBus.Version");
            if (version != "7.1.4" && messageBytes.Length > 3 && !messageBytes.IsZipped())
            {
                // there is some kind of header at the start (2 bytes) which we don't want
                messageBytes = messageBytes.Skip(3).ToArray();
            }
            return messageBytes;
        }

        public static bool IsFcsDataBusMessage(this ServiceBusReceivedMessage message)
        {
            return message.ApplicationProperties.ContainsKey(VeryLargeMessageHeaderKey);
        }
        public static string GetFcsDataBusKey(this ServiceBusReceivedMessage message)
        {
            return message.ApplicationProperties[VeryLargeMessageHeaderKey].ToString();
        }

        private static string GetMessageType(this ServiceBusReceivedMessage message)
        {
            return message.ApplicationProperties["NServiceBus.EnclosedMessageTypes"].ToString().Split(',')[0];
        }

        private static string GetNServiceBusProperty(this ServiceBusReceivedMessage message, string propertyName)
        {
            return message.ApplicationProperties.GetStringValueOrDefault(propertyName, "Not Present");
        }

        private static string GetBusinessKeyFromMessage(string messageText)
        {
            const int columnLength = 80;
            var jsonToken = JToken.Parse(messageText);
            var businessKeysWithValues = BusinessKeyAttributes.Select(a => new { Attribute = a, Values = jsonToken.SelectTokens($"..{a}").FirstOrDefault() })
                .Where(bk => bk.Values != null)
                .Select(bk => $"{bk.Attribute}={bk.Values}")
                .ToList();
            var businessKey = string.Join(", ", businessKeysWithValues);
            var length = businessKey.Length > columnLength ? columnLength : businessKey.Length;

            var key = businessKey.Substring(0, length);

            return string.IsNullOrEmpty(key) ? "None available" : key;
        }

        /*
        private static byte[] ConvertObjectToBytes(object obj)
        {
            BinaryFormatter bf = new BinaryFormatter();
            using MemoryStream ms = new MemoryStream();
            bf.Serialize(ms, obj);
            return ms.ToArray();
        }*/
        private static byte[] ConvertObjectToBytes(object obj)
        {
            string jsonString = JsonSerializer.Serialize(obj);
            return System.Text.Encoding.UTF8.GetBytes(jsonString);
        }

        private static string GetStringFromBytes(byte[] bytes)
        {
            using MemoryStream ms = new MemoryStream(bytes);
            using (StreamReader sr = new StreamReader(ms))
            {
                return sr.ReadToEnd();
            }
        }

        private static byte[] GetUnZippedBytes(byte[] messageBytes)
        {
            if (messageBytes.IsZipped())
            {
                using GZipStream bigStream = new GZipStream(new MemoryStream(messageBytes), CompressionMode.Decompress);
                MemoryStream unZippedStream = new MemoryStream();
                bigStream.CopyToAsync(unZippedStream).Wait();

                return unZippedStream.ToArray();
            }

            return messageBytes;
        }
    }
}
