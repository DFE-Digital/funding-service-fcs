namespace Operations.Web.Repositories
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using Dtos;
    using Operations.Web.Infrastructure;

    public interface IAzureServiceBusQueueService
    {
        Task<long> GetQueueSizeInBytes(string queueName);
        Task DeleteMessagesFromQueue(string queueName, List<ErrorMessage>  messageId);
        Task<ErrorQueueContract> FetchMessagesFromQueue(string queueName, int numberOfMessagesToFetch);
        Task ReRunFailedMessagesFromQueue(ErrorQueueContract FaledMessages, ITransportMessageSender messageSender);
    }
}