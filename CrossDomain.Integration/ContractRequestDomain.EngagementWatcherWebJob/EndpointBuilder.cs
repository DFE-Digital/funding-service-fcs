namespace ContractRequestDomain.EngagementWatcherWebJob
{
    using System;
    using System.Configuration;
    using System.IO;
    using System.Linq;
    using NServiceBus;
    using NServiceBus.Newtonsoft.Json;             // New serializer
   
    public static class EndpointBuilder
    {
        public static IEndpointInstance CreateSendOnlyEndpoint<TCommand>()
        {
            var endpointConfiguration = new EndpointConfiguration("WebJobs");
            endpointConfiguration.SendOnly();

            // ---------- NEW AZURE SERVICE BUS TRANSPORT (REQUIRED TOPOLOGY) ----------
            var connectionString =
                ConfigurationManager.ConnectionStrings["NServiceBus/Transport"]?.ConnectionString;

            // New ASB transport requires a topology (Default topology is OK)
            var topology = TopicTopology.Default;

            var transport = new AzureServiceBusTransport(connectionString, topology)
            {
                TransportTransactionMode = TransportTransactionMode.ReceiveOnly
            };

            endpointConfiguration.UseTransport(transport);

            // ---------- CONVENTIONS ----------
            endpointConfiguration.Conventions()
                .DefiningCommandsAs(t => t == typeof(TCommand));

            // ---------- REMOVE ALL AUTOMATIC TYPE SCANNING ----------
            string[] assembliesToExclude =
                Directory.EnumerateFiles(AppDomain.CurrentDomain.BaseDirectory, "*.dll")
                        .Select(Path.GetFileName)
                        .ToArray();

            var scanner = endpointConfiguration.AssemblyScanner();
            scanner.ExcludeAssemblies(assembliesToExclude);
            scanner.ThrowExceptions = false;

            // ---------- SERIALIZER (NEW JSON.NET SERIALIZER) ----------
            endpointConfiguration.UseSerialization<NewtonsoftJsonSerializer>();

            // ---------- START SEND-ONLY ENDPOINT ----------
            return Endpoint.Start(endpointConfiguration).GetAwaiter().GetResult();
        }
    }
}
