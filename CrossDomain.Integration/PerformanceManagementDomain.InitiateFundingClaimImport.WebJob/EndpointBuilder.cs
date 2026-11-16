namespace PerformanceManagementDomain.InitiateFundingClaimImport.WebJob
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

            // ✅ Mark as send-only
            endpointConfiguration.SendOnly();

            // ✅ Command conventions
            endpointConfiguration.Conventions()
                .DefiningCommandsAs(t => t == typeof(TCommand));

            // ✅ Assembly scanning (preserved)
            string[] assembliesToExclude = Directory.EnumerateFiles(
                    AppDomain.CurrentDomain.BaseDirectory, "*.dll")
                .Select(Path.GetFileName)
                .ToArray();

            var scanner = endpointConfiguration.AssemblyScanner();
            scanner.ExcludeAssemblies(assembliesToExclude);
            scanner.ThrowExceptions = false;

            // ✅ Get connection string
            var connectionString = ConfigurationManager
                .ConnectionStrings["NServiceBus/Transport"]?.ConnectionString;

            // ✅ NEW transport configuration (mandatory now)
            var transport = new AzureServiceBusTransport(
                connectionString,
                TopicTopology.Default
            );

            endpointConfiguration.UseTransport(transport);

            // ✅ OPTIONAL (recommended to REMOVE unless required)
            // using NServiceBus.Newtonsoft.Json;
            // endpointConfiguration.UseSerialization<NewtonsoftJsonSerializer>();

            // ✅ Start endpoint
            return Endpoint.Start(endpointConfiguration)
                .GetAwaiter()
                .GetResult();

        }
    }
    }
