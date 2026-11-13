
namespace SFA.FCT.ContractManagementService.NSB
{
    using IoC;
    using NServiceBus;
    using NServiceBus.Serialization;
    using NServiceBus.Transport.AzureServiceBus;
    using System;
    using System.IO;
    using System.Linq;

    public static class ServiceBus
    {
        public static ISendOnlyBus Bus { get; set; } = new FctServicesSendOnlyBus();

        private class FctServicesSendOnlyBus : ISendOnlyBus
        {
            private readonly Lazy<IEndpointInstance> endpoint =
                new Lazy<IEndpointInstance>(CreateSendOnlyEndpoint);

            public void Send<T>(string destination, T message)
            {
                endpoint.Value.Send(destination, message)
                    .GetAwaiter()
                    .GetResult();
            }

            public void Send<T>(string destination, Action<T> messageConstructor)
                where T : new()
            {
                var message = new T();
                messageConstructor(message);

                endpoint.Value.Send(destination, message)
                    .GetAwaiter()
                    .GetResult();
            }

            private static IEndpointInstance CreateSendOnlyEndpoint()
            {
                var endpointConfiguration =
                    new EndpointConfiguration("contractmanagementdomain.integration");

                endpointConfiguration.SendOnly();

                endpointConfiguration.Conventions()
                    .DefiningCommandsAs(t =>
                        t.Namespace != null &&
                        t.Namespace.EndsWith("Commands"));

                var connectionString =
                    IoCSetup.FcsConfiguration["ConnectionStrings:NServiceBus/Transport"];

                // ✅ Modern Azure Service Bus transport
                var transport = new AzureServiceBusTransport(
                    connectionString,
                    TopicTopology.Default
                );

                endpointConfiguration.UseTransport(transport);

                // Assembly scanning rules (kept exactly as requested)
                var assembliesToExclude = Directory
                    .EnumerateFiles(AppDomain.CurrentDomain.BaseDirectory, "*.dll")
                    .Select(Path.GetFileName)
                    .ToArray();

                var scanner = endpointConfiguration.AssemblyScanner();
                scanner.ExcludeAssemblies(assembliesToExclude);
                scanner.ThrowExceptions = false;

                endpointConfiguration.UseSerialization<NewtonsoftJsonSerializer>();

                return Endpoint.Start(endpointConfiguration)
                    .GetAwaiter()
                    .GetResult();
            }
        }
    }
}
