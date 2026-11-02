namespace FCT.Operations.MessageReplay.Endpoint.Tests
{
    using System;
    using NServiceBus;
    using SFA.FCT.Operations.Common.Services;

    public class MessageReplayBus : IMessageReplayBus
    {
        public void Publish(string endpointName, object message)
        {
            IBus bus = CreateBus(endpointName);
            bus.Publish(message);
        }

        public void Send(string endpointName, object message)
        {
            IBus bus = CreateBus(endpointName);
            bus.Send(message);
        }

        public void Send<T>(string endpointName, Action<T> messageConstructor)
        {
            IBus bus = CreateBus(endpointName);
            bus.Send(endpointName, messageConstructor);
        }

        private static IBus CreateBus(string endpointName)
        {
            BusConfiguration configuration = new BusConfiguration();
            configuration.EndpointName(endpointName);
            configuration.UseTransport<AzureServiceBusTransport>();
            configuration.UsePersistence<InMemoryPersistence>();
            configuration.UseSerialization<JsonSerializer>();

            configuration.Conventions()
                .DefiningCommandsAs(t => t.Namespace != null && t.Namespace.EndsWith("Commands"))
                .DefiningEventsAs(t => t.Namespace != null && t.Namespace.EndsWith("Events"));

            configuration.EnableInstallers();

            return Bus.Create(configuration);
        }
    }
}
