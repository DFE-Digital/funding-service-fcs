namespace AllocationDeliveryDomain.DcActualsPull.WebJob
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
            var endpointConfiguration = new EndpointConfiguration("WebJobs");

            // ✅ Mark as send-only endpoint
            endpointConfiguration.SendOnly();

            // ✅ Command conventions
            endpointConfiguration.Conventions()
                .DefiningCommandsAs(t => t == typeof(TCommand));

            // ✅ Exclude assemblies (keep your logic)
            string[] assembliesToExclude = Directory.EnumerateFiles(AppDomain.CurrentDomain.BaseDirectory, "*.dll")
                .Select(Path.GetFileName)
                .ToArray();

            var scanner = endpointConfiguration.AssemblyScanner();
            scanner.ExcludeAssemblies(assembliesToExclude);
            scanner.ThrowExceptions = false;

            // ✅ Get connection string (old ConfigurationManager still works if referenced)
            var connectionString = ConfigurationManager
                .ConnectionStrings["NServiceBus/Transport"]?.ConnectionString;

            // ✅ NEW transport configuration (MANDATORY)
            var transport = new AzureServiceBusTransport(
                connectionString,
                TopicTopology.Default
            );

            endpointConfiguration.UseTransport(transport);

            // ✅ Serializer fix
            endpointConfiguration.UseSerialization<NewtonsoftJsonSerializer>();

            // ✅ Start endpoint
            return Endpoint.Start(endpointConfiguration)
                .GetAwaiter()
                .GetResult();
        }

    }
}
