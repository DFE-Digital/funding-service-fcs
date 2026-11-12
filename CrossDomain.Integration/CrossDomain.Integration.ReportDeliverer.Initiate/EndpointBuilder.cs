
namespace CrossDomain.Integration.ReportDeliverer.Initiate
{
    using System;
    using System.Configuration;
    using System.IO;
    using System.Linq;
    using NServiceBus;
    using NServiceBus.Newtonsoft.Json;            // New serializer
    using NServiceBus.Transport.AzureServiceBus;  // New ASB transport

    public static class EndpointBuilder
    {
        public static IEndpointInstance CreateSendOnlyEndpoint<TCommand>()
        {
            var endpointConfiguration = new EndpointConfiguration("WebJobs");
            endpointConfiguration.SendOnly();

            // ----------- NEW AZURE SERVICE BUS TRANSPORT (REQUIRED TOPOLOGY) -----------
            var connectionString =
                ConfigurationManager.ConnectionStrings["NServiceBus/Transport"]?.ConnectionString;

            // New transport must include a chosen topology (Default is fine)
            var topology = TopicTopology.Default;

            var transport = new AzureServiceBusTransport(connectionString, topology)
            {
                TransportTransactionMode = TransportTransactionMode.ReceiveOnly
            };

            endpointConfiguration.UseTransport(transport);

            // ----------- CONVENTIONS -----------
            endpointConfiguration.Conventions()
                .DefiningCommandsAs(t => t == typeof(TCommand));

            // ----------- REMOVE ALL AUTOMATIC SCANNING (YOUR EXISTING LOGIC) -----------
            string[] assembliesToExclude = Directory.EnumerateFiles(
                    AppDomain.CurrentDomain.BaseDirectory, "*.dll")
                .Select(Path.GetFileName)
                .ToArray();

            var scanner = endpointConfiguration.AssemblyScanner();
            scanner.ExcludeAssemblies(assembliesToExclude);
            scanner.ThrowExceptions = false;

            // ----------- SERIALIZATION (NEW JSON.NET SERIALIZER) -----------
            endpointConfiguration.UseSerialization<NewtonsoftJsonSerializer>();

            // ----------- START SEND-ONLY ENDPOINT -----------
            return Endpoint.Start(endpointConfiguration).GetAwaiter().GetResult();
        }
    }
}
