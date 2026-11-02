namespace Datafix.Tests.Services
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.IO;
    using System.Linq;
    using Microsoft.ServiceBus.Messaging;
    using Newtonsoft.Json;

    public static class AzureServiceBusSender
    {
        public static void SendMessage(string queueName, string message, string propertiesJson)
        {
            var client = GetQueueClient(queueName);
            var headerProperties = JsonConvert.DeserializeObject<Dictionary<string, string>>(propertiesJson);
            BrokeredMessage brokeredMessage = new BrokeredMessage(GenerateStreamFromString(message));
            headerProperties.Keys.ToList().ForEach(key =>
            {
                brokeredMessage.Properties.Add(key, headerProperties[key]);
            });

            client.Send(brokeredMessage);
        }
        private static QueueClient GetQueueClient(string queueName) => QueueClient.CreateFromConnectionString(AzureServiceBusConnectionString, queueName);

        private static string AzureServiceBusConnectionString => ConfigurationManager.ConnectionStrings["NServiceBus/Transport"].ConnectionString;

        public static Stream GenerateStreamFromString(string s)
        {
            var stream = new MemoryStream();
            var writer = new StreamWriter(stream);
            writer.Write(s);
            writer.Flush();
            stream.Position = 0;

            return stream;
        }
    }
}
