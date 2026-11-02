namespace ContractRequestDomain.EngagementWatcherWebJob
{
    using System;
    using System.Configuration;
    using System.IO;
    using System.Linq;
    using NServiceBus;

    public static class EndpointBuilder
    {
        public static IEndpointInstance CreateSendOnlyEndpoint<TCommand>()
        {
            EndpointConfiguration endpointConfiguration = new EndpointConfiguration("WebJobs");
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
            transport.ConnectionString(ConfigurationManager.ConnectionStrings["NServiceBus/Transport"].ConnectionString);

            endpointConfiguration.UseSerialization<NewtonsoftSerializer>();

            return Endpoint.Start(endpointConfiguration).GetAwaiter().GetResult();
        }
    }
}
