namespace SFA.FCT.Operations.Maintenance.Endpoint.Services
{
    using System.Threading.Tasks;

    public interface IAzureServiceBusQueueService
    {
        Task<long> GetQueueSizeInBytes(string queueName);
        Task DeleteMessagesFromQueue(string queueName, int numberOfMessagesToDelete);
    }
}