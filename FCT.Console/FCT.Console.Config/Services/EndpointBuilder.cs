namespace FCT.Console.Config.Services
{
    using System;
    using System.IO;
    using System.Linq;
    using NServiceBus;
    using NServiceBus.Transport.AzureServiceBus;
    using System.Text.Json;
    using System.Configuration;

    public class EndpointBuilder
    {
        public static IEndpointInstance CreateSendOnlyEndpoint<TCommand>()
        {
            var endpointConfiguration = new EndpointConfiguration("TestSendingEndpoint");
            endpointConfiguration.SendOnly();

            // 1) Instantiate the modern ASB transport with topology
            var transport = new AzureServiceBusTransport(
                ConfigurationManager.ConnectionStrings["NServiceBus/Transport"].ConnectionString,
                TopicTopology.Default
            );
            // 2) Register the transport
            endpointConfiguration.UseTransport(transport);
            endpointConfiguration.Conventions()
                .DefiningCommandsAs(t => t == typeof(TCommand));

            // Your existing scanner settings
            var assembliesToExclude = Directory.EnumerateFiles(AppDomain.CurrentDomain.BaseDirectory, "*.dll")
                .Select(Path.GetFileName)
                .ToArray();

            var scanner = endpointConfiguration.AssemblyScanner();
            scanner.ExcludeAssemblies(assembliesToExclude);
            scanner.ThrowExceptions = false;

            endpointConfiguration.UseSerialization<SystemJsonSerializer>();

            return Endpoint.Start(endpointConfiguration).GetAwaiter().GetResult();
        }
    }
}