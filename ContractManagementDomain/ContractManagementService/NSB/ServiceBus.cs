namespace SFA.FCT.ContractManagementService.NSB
{
    using System;
    using System.IO;
    using System.Linq;
    using IoC;
    using NServiceBus;

    public static class ServiceBus
    {
        public static ISendOnlyBus Bus { get; set; } = new FctServicesSendOnlyBus();

        private class FctServicesSendOnlyBus : ISendOnlyBus
        {
            private readonly Lazy<IEndpointInstance> _endpoint = new Lazy<IEndpointInstance>(CreateSendOnlyEndpoint);

            public void Send<T>(string destination, T message)
            {
                _endpoint.Value.Send(destination, message).Wait();
            }

            public void Send<T>(string destination, Action<T> messageConstructor) where T : new()
            {
                T message = new T();
                messageConstructor(message);

                _endpoint.Value.Send(destination, message).Wait();
            }

            private static IEndpointInstance CreateSendOnlyEndpoint()
            {
                EndpointConfiguration endpointConfiguration = new EndpointConfiguration("contractmanagementdomain.integration");
                endpointConfiguration.UseTransport<AzureServiceBusTransport>();
                endpointConfiguration.Conventions().DefiningCommandsAs(t => null != t.Namespace && t.Namespace.EndsWith("Commands"));

                // exclude all
                string[] assembliesToExclude = Directory.EnumerateFiles(AppDomain.CurrentDomain.BaseDirectory, "*.dll")
                    .Select(Path.GetFileName)
                    .ToArray();

                AssemblyScannerConfiguration scanner = endpointConfiguration.AssemblyScanner();
                scanner.ExcludeAssemblies(assembliesToExclude);
                scanner.ThrowExceptions = false;

                var transport = endpointConfiguration.UseTransport<AzureServiceBusTransport>();
                transport.Transactions(TransportTransactionMode.ReceiveOnly);
                transport.ConnectionString(IoCSetup.FcsConfiguration["ConnectionStrings:NServiceBus/Transport"]);

                endpointConfiguration.UseSerialization<NewtonsoftSerializer>();

                return Endpoint.Start(endpointConfiguration).GetAwaiter().GetResult();
            }
        }
    }
}