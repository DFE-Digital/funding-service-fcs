namespace SFA.FCT.Operations.Common.Services
{
    public interface IMessageReplayService
    {
        void ReplayMessage(string messageId, string description);

        void ReplayMessage(string messageType, object message, string endpointName);
    }
}
