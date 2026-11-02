namespace Datafix.Tests.Automation.Releases.R88.Audit
{
    using System;
    using System.Collections.Generic;
    using System.Globalization;
    using System.IO;
    using System.Linq;
    using System.Runtime.Serialization.Formatters.Binary;
    using Microsoft.ServiceBus.Messaging;
    using Newtonsoft.Json.Linq;

    public static class BrokeredMessageExtensions
    {
        private static readonly IReadOnlyCollection<string> BusinessKeyAttributes = new List<string>
            { "ContractNumber", "AllocationNumber", "VersionNumber", "Ukprn" };

        public static FcsMessage ToFcsMessage(this BrokeredMessage message, byte[] messageBytes)
        {
            var text = GetStringFromBytes(messageBytes);
            var timeSentString = message.GetNServiceBusProperty("NServiceBus.TimeSent");
            // e.g 2019-12-16 07:47:59:931312 Z
            var timeSent = DateTime.ParseExact(
                timeSentString,
                "yyyy-MM-dd HH:mm:ss:ffffff 'Z'",
                null,
                DateTimeStyles.AssumeUniversal | DateTimeStyles.AdjustToUniversal);

            return new FcsMessage(
                messageBytes,
                message.GetMessageType(),
                timeSent,
                Guid.Parse(message.MessageId),
                message.GetNServiceBusProperty("NServiceBus.OriginatingEndpoint"),
                message.GetNServiceBusProperty("NServiceBus.ProcessingEndpoint"),
                GetBusinessKeyFromMessage(text),
                ConvertObjectToBytes(message.Properties));
        }
        
        private static string GetMessageType(this BrokeredMessage message)
        {
            return message.Properties["NServiceBus.EnclosedMessageTypes"].ToString().Split(',')[0];
        }

        private static string GetNServiceBusProperty(this BrokeredMessage message, string propertyName)
        {
            return message.Properties.GetStringValueOrDefault(propertyName, "Not Present");
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

        private static byte[] ConvertObjectToBytes(object obj)
        {
            BinaryFormatter bf = new BinaryFormatter();
            using (MemoryStream ms = new MemoryStream())
            {
                bf.Serialize(ms, obj);
                return ms.ToArray();
            }
        }

        private static string GetStringFromBytes(byte[] bytes)
        {
            using (MemoryStream ms = new MemoryStream(bytes))
            {
                using (StreamReader sr = new StreamReader(ms))
                {
                    return sr.ReadToEnd();
                }
            }
        }
    }
}