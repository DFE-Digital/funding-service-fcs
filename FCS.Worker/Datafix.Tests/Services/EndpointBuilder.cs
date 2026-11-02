namespace Datafix.Tests.Services
{
    using System;
    using System.IO;
    using System.Linq;
    using NServiceBus;

    public class EndpointBuilder
    {
        public static IEndpointInstance CreateSendOnlyEndpoint<TCommand>()
        {
            EndpointConfiguration endpointConfiguration = new EndpointConfiguration("TestSendingEndpoint");
            endpointConfiguration.UseTransport<AzureServiceBusTransport>();
            endpointConfiguration.Conventions()
                .DefiningCommandsAs(t => t == typeof(TCommand));

            // exclude all
            string[] assembliesToExclude = Directory.EnumerateFiles(AppDomain.CurrentDomain.BaseDirectory, "*.dll")
                .Select(Path.GetFileName)
                .ToArray();

            AssemblyScannerConfiguration scanner = endpointConfiguration.AssemblyScanner();
            scanner.ExcludeAssemblies(assembliesToExclude);
            scanner.ThrowExceptions = false;

            AzureServiceBusEndpointOrientedTopologySettings transport = endpointConfiguration.UseTransport<AzureServiceBusTransport>().UseEndpointOrientedTopology();
            transport.Transactions(TransportTransactionMode.ReceiveOnly);

            endpointConfiguration.UseSerialization<NewtonsoftSerializer>();

            return Endpoint.Start(endpointConfiguration).GetAwaiter().GetResult();
        }

        public static IEndpointInstance CreatePublishingEndpoint<TEvent>(string endpointToPublishFrom)
        {
            EndpointConfiguration endpointConfiguration = new EndpointConfiguration(endpointToPublishFrom);
            endpointConfiguration.UseTransport<AzureServiceBusTransport>();
            endpointConfiguration.Conventions()
                .DefiningEventsAs(t => t == typeof(TEvent));

            // exclude all
            string[] assembliesToExclude = Directory.EnumerateFiles(AppDomain.CurrentDomain.BaseDirectory, "*.dll")
                .Select(Path.GetFileName)
                .ToArray();

            AssemblyScannerConfiguration scanner = endpointConfiguration.AssemblyScanner();
            scanner.ExcludeAssemblies(assembliesToExclude);
            scanner.ThrowExceptions = false;

            AzureServiceBusEndpointOrientedTopologySettings transport = endpointConfiguration.UseTransport<AzureServiceBusTransport>().UseEndpointOrientedTopology();
            transport.Transactions(TransportTransactionMode.ReceiveOnly);

            endpointConfiguration.UseSerialization<NewtonsoftSerializer>();

            return Endpoint.Start(endpointConfiguration).GetAwaiter().GetResult();
        }
    }
}
