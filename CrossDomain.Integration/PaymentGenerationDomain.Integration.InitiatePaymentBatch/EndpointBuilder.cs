namespace PaymentGenerationDomain.Integration.InitiatePaymentBatch
{
    using System;
using System.Configuration;
using System.IO;
using System.Linq;
using NServiceBus;
using NServiceBus.Transport.AzureServiceBus;
    public static class EndpointBuilder
    {
        
        public static IEndpointInstance CreateSendOnlyEndpoint<TCommand>()
        {
            
            var endpointConfiguration = new EndpointConfiguration("WebJobs");

            var topologyOptions = new TopologyOptions();
            var topology = TopicTopology.FromOptions(topologyOptions);

          
            var connectionString = ConfigurationManager
                .ConnectionStrings["NServiceBus/Transport"]
                .ConnectionString;

          
            var asbTransport = new AzureServiceBusTransport(connectionString, topology)
            {
                // Supported by the current transport
                TransportTransactionMode = TransportTransactionMode.ReceiveOnly
            };

            
            endpointConfiguration.UseTransport(asbTransport);

            endpointConfiguration.Conventions()
                .DefiningCommandsAs(t => t == typeof(TCommand));
            var assembliesToExclude = Directory
                .EnumerateFiles(AppDomain.CurrentDomain.BaseDirectory, "*.dll")
                .Select(Path.GetFileName)
                .ToArray();

            var scanner = endpointConfiguration.AssemblyScanner();
            scanner.ExcludeAssemblies(assembliesToExclude);
            scanner.ThrowExceptions = false;
            endpointConfiguration.UseSerialization<NewtonsoftSerializer>();
            endpointConfiguration.SendOnly();

            return Endpoint.Start(endpointConfiguration).GetAwaiter().GetResult();
        }
    }
}
