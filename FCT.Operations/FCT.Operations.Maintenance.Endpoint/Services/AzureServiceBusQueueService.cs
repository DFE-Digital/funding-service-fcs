namespace SFA.FCT.Operations.Maintenance.Endpoint.Services
{
    using FCS.Worker.Common;
    using System.Threading.Tasks;
    using Azure.Messaging.ServiceBus;
    using Azure.Messaging.ServiceBus.Administration;

    public class AzureServiceBusQueueService : IAzureServiceBusQueueService
    {
        private readonly IFcsConfiguration _configuration;

        public AzureServiceBusQueueService(IFcsConfiguration configuration)
        {
            _configuration = configuration;
        }

        public async Task<long> GetQueueSizeInBytes(string queueName)
        {
            var client = new ServiceBusAdministrationClient(AzureServiceBusConnectionString);
            var runtimeProperties = (await client.GetQueueRuntimePropertiesAsync(queueName)).Value;
            
            return runtimeProperties.ActiveMessageCount;
        }

        public async Task DeleteMessagesFromQueue(string queueName, int numberOfMessagesToDelete)
        {
            var receiver = GetServiceBusReceiver(queueName);
            await receiver.ReceiveMessagesAsync(numberOfMessagesToDelete);
        }

        private ServiceBusReceiver GetServiceBusReceiver(string queueName)
        {
            var options = new ServiceBusReceiverOptions {ReceiveMode = ServiceBusReceiveMode.ReceiveAndDelete};

            return new ServiceBusClient(AzureServiceBusConnectionString).CreateReceiver(queueName, options);
        }

        private string AzureServiceBusConnectionString => _configuration["ConnectionStrings:NServiceBus/Transport"];
    }
}
