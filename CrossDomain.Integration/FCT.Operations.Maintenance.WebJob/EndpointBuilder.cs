namespace FCT.Operations.Maintenance.WebJob
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

            // ✅ Assembly scanning (keep your logic)
            string[] assembliesToExclude = Directory.EnumerateFiles(
                    AppDomain.CurrentDomain.BaseDirectory, "*.dll")
                .Select(Path.GetFileName)
                .ToArray();

            var scanner = endpointConfiguration.AssemblyScanner();
            scanner.ExcludeAssemblies(assembliesToExclude);
            scanner.ThrowExceptions = false;

            // ✅ Get connection string (still ok if using ConfigurationManager)
            var connectionString = ConfigurationManager
                .ConnectionStrings["NServiceBus/Transport"]?.ConnectionString;

            // ✅ NEW transport configuration (REQUIRED)
            var transport = new AzureServiceBusTransport(
                connectionString,
                TopicTopology.Default
            );

            endpointConfiguration.UseTransport(transport);

            // ✅ OPTIONAL: remove if not needed (recommended)
            // endpointConfiguration.UseSerialization<NewtonsoftJsonSerializer>();

            return Endpoint.Start(endpointConfiguration)
                .GetAwaiter()
                .GetResult();
        }

    }
}
