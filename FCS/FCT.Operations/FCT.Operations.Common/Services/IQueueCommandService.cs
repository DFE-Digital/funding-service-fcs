namespace SFA.FCT.Operations.Common.Services
{
    public interface IQueueCommandService
    {
        void DeleteMessagesFromQueue(string queueName, int numberOfMessagesToDelete);
    }
}