namespace Datafix.Tests.Services
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using System.Text;
    using System.Threading.Tasks;
    using Azure.Messaging.ServiceBus;
    using Newtonsoft.Json;

    public static class AzureServiceBusSender
    {
        public static async Task SendMessage(string queueName, string message, string propertiesJson)
        {
            var client = new ServiceBusClient(AzureServiceBusConnectionString);
            var sender = client.CreateSender(queueName);

            var headerProperties =
                JsonConvert.DeserializeObject<Dictionary<string, string>>(propertiesJson);

            // ✅ Replace BrokeredMessage with ServiceBusMessage
            var serviceBusMessage = new ServiceBusMessage(Encoding.UTF8.GetBytes(message));

            // ✅ Replace Properties → ApplicationProperties
            headerProperties?.Keys.ToList().ForEach(key =>
            {
                serviceBusMessage.ApplicationProperties[key] = headerProperties[key];
            });

            await sender.SendMessageAsync(serviceBusMessage);
        }

        private static string AzureServiceBusConnectionString =>
            ConfigurationManager.ConnectionStrings["NServiceBus/Transport"].ConnectionString;
    }
}