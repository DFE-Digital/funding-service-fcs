
namespace FCT.Operations.MessageReplay.Endpoint.Tests
{
    using System;
    using System.Threading.Tasks;
    using NServiceBus;
    using NServiceBus.Transport.AzureServiceBus;
    using SFA.FCT.Operations.Common.Services;

    public class MessageReplayBus : IMessageReplayBus
    {
        public void Publish(string endpointName, object message)
        {
            PublishAsync(endpointName, message).GetAwaiter().GetResult();
        }

        public void Send(string endpointName, object message)
        {
            SendAsync(endpointName, message).GetAwaiter().GetResult();
        }

        public void Send<T>(string endpointName, Action<T> messageConstructor)
        {
            SendAsync(endpointName, messageConstructor).GetAwaiter().GetResult();
        }

        // ✅ Async implementations (required in modern NSB)
        private async Task PublishAsync(string endpointName, object message)
        {
            var endpoint = await CreateEndpoint(endpointName);
            await endpoint.Publish(message);
            await endpoint.Stop();
        }

        private async Task SendAsync(string endpointName, object message)
        {
            var endpoint = await CreateEndpoint(endpointName);
            await endpoint.Send(endpointName, message);
            await endpoint.Stop();
        }

        private async Task SendAsync<T>(string endpointName, Action<T> messageConstructor)
        {
            var endpoint = await CreateEndpoint(endpointName);
            await endpoint.Send(endpointName, messageConstructor);
            await endpoint.Stop();
        }

        private static async Task<IEndpointInstance> CreateEndpoint(string endpointName)
        {
            var configuration = new EndpointConfiguration(endpointName);

            configuration.SendOnly();

            // ✅ Serializer (fixed)
            configuration.UseSerialization<SystemJsonSerializer>();

            // ✅ Transport (REQUIRED)
            var transport = new AzureServiceBusTransport(
                "UseDevelopmentStorage=true", // replace with real connection string if needed
                TopicTopology.Default);

            configuration.UseTransport(transport);

            configuration.EnableInstallers();

            return await Endpoint.Start(configuration);
        }
    }
}
