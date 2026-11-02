namespace AllocationDeliveryDomain.Endpoint.Services
{
    public interface IAzureServiceBusQueryService
    {
        long GetQueueMessageCount(string queueName);

        long GetTopicMessageCount(string topicName);
    }
}
