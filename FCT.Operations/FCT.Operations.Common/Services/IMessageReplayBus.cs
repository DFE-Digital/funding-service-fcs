namespace SFA.FCT.Operations.Common.Services
{
    using System;

    public interface IMessageReplayBus
    {
        void Publish(string endpointName, object message);

        void Send(string endpointName, object message);

        void Send<T>(string endpointName, Action<T> messageConstructor);

    }
}
