namespace Datafix.Tests.Infrastructure
{
    using Azure.Messaging.ServiceBus.Administration;
    using System;
    using System.Configuration;
    using System.Threading.Tasks;
    
    public static class AzureServiceBusService
    {
        private static readonly string ConnectionString = ConfigurationManager.ConnectionStrings["NServiceBus/Transport"].ConnectionString;


        public static async Task<long> GetQueueMessageCount(string queueName)
        {
            var client = new ServiceBusAdministrationClient(ConnectionString);

            var properties = await client.GetQueueRuntimePropertiesAsync(queueName);

            return properties.Value.ActiveMessageCount;
        }


        public static async Task<bool> WaitTillQueueIsEmpty(string queue)
        {
            int numChecks = 0;
            const int maxNumChecks = 60;
            const int waitIntervalSeconds = 5;
            bool isQueueEmpty = false;
            while (numChecks < maxNumChecks)
            {
                var count = await GetQueueMessageCount(queue);
                if (count == 0)
                {
                    isQueueEmpty = true;
                    break;
                }

                if (++numChecks < maxNumChecks)
                {
                    Task.Delay(TimeSpan.FromSeconds(waitIntervalSeconds)).Wait();
                }
            }
            return isQueueEmpty;
        }
    }
}
