namespace Datafix.Tests.Infrastructure
{
    using System;
    using System.Configuration;
    using System.Threading.Tasks;
    using Microsoft.ServiceBus;

    public static class AzureServiceBusService
    {
        private static readonly string ConnectionString = ConfigurationManager.ConnectionStrings["NServiceBus/Transport"].ConnectionString;
        public static long GetQueueMessageCount(string queueName)
        {
            NamespaceManager namespaceManager = NamespaceManager.CreateFromConnectionString(ConnectionString);
            
            return namespaceManager.GetQueue(queueName).MessageCount;
        }

        public static bool WaitTillQueueIsEmpty(string queue)
        {
            int numChecks = 0;
            const int maxNumChecks = 60;
            const int waitIntervalSeconds = 5;
            bool isQueueEmpty = false;
            while (numChecks < maxNumChecks)
            {
                if (GetQueueMessageCount(queue) == 0)
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
