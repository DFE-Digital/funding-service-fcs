using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.IO.Compression;
using System.Linq;
using Azure.Messaging.ServiceBus;
using Datafix.Tests.Automation.Releases.R77.Audit;
using Newtonsoft.Json.Linq;
using Operations.DataStore.Extensions;

public static class BrokeredMessageExtensions
{
    private static readonly IReadOnlyCollection<string> BusinessKeyAttributes = new List<string>
    {
        "ContractNumber", "AllocationNumber", "VersionNumber", "Ukprn"
    };

    public static FcsMessage ToFcsMessage(this ServiceBusReceivedMessage message)
    {
        // ✅ FIX: Get body correctly
        var messageBytes = message.Body.ToArray();

        var unZippedBytes = GetUnZippedBytes(messageBytes);
        var text = GetStringFromBytes(unZippedBytes);

        var timeSentString = GetNServiceBusProperty(message, "NServiceBus.TimeSent");

        var timeSent = DateTime.ParseExact(
            timeSentString,
            "yyyy-MM-dd HH:mm:ss:ffffff 'Z'",
            null,
            DateTimeStyles.AssumeUniversal | DateTimeStyles.AdjustToUniversal);

        return new FcsMessage(
            messageBytes,
            GetMessageType(message),
            timeSent,
            Guid.Parse(message.MessageId),
            GetNServiceBusProperty(message, "NServiceBus.OriginatingEndpoint"),
            GetNServiceBusProperty(message, "NServiceBus.ProcessingEndpoint"),
            GetBusinessKeyFromMessage(text),
            ConvertObjectToBytes(message.ApplicationProperties)  // ✅ updated
        );
    }

    private static string GetMessageType(ServiceBusReceivedMessage message)
    {
        return message.ApplicationProperties["NServiceBus.EnclosedMessageTypes"]
            .ToString()
            .Split(',')[0];
    }

    private static string GetNServiceBusProperty(ServiceBusReceivedMessage message, string propertyName)
    {
        return message.ApplicationProperties.TryGetValue(propertyName, out var value)
            ? value?.ToString()
            : "Not Present";
    }

    private static string GetBusinessKeyFromMessage(string messageText)
    {
        const int columnLength = 80;

        var jsonToken = JToken.Parse(messageText);

        var businessKeysWithValues = BusinessKeyAttributes
            .Select(a => new
            {
                Attribute = a,
                Values = jsonToken.SelectTokens($"..{a}").FirstOrDefault()
            })
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
        return System.Text.Encoding.UTF8.GetBytes(obj.ToString());
    }

    private static string GetStringFromBytes(byte[] bytes)
    {
        using var ms = new MemoryStream(bytes);
        using var sr = new StreamReader(ms);
        return sr.ReadToEnd();
    }

    private static byte[] GetUnZippedBytes(byte[] messageBytes)
    {
        if (messageBytes.IsZipped())
        {
            using var bigStream = new GZipStream(new MemoryStream(messageBytes), CompressionMode.Decompress);
            using var unZippedStream = new MemoryStream();

            bigStream.CopyTo(unZippedStream);

            return unZippedStream.ToArray();
        }

        return messageBytes;
    }
}