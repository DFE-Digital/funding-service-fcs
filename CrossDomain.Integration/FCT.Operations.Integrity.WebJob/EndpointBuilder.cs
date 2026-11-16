namespace FCT.Operations.Integrity.WebJob
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
            endpointConfiguration.SendOnly();
            var transport = new AzureServiceBusTransport(
                ConfigurationManager.ConnectionStrings["NServiceBus/Transport"].ConnectionString,
                TopicTopology.Default
            );
            endpointConfiguration.UseTransport(transport);
            endpointConfiguration.Conventions()
                .DefiningCommandsAs(t => t == typeof(TCommand));


            var assembliesToExclude = Directory.EnumerateFiles(AppDomain.CurrentDomain.BaseDirectory, "*.dll")
                .Select(Path.GetFileName)
                .ToArray();

            var scanner = endpointConfiguration.AssemblyScanner();
            scanner.ExcludeAssemblies(assembliesToExclude);
            scanner.ThrowExceptions = false;

            endpointConfiguration.UseSerialization<NewtonsoftSerializer>();

            return Endpoint.Start(endpointConfiguration).GetAwaiter().GetResult();
        }
    }
}
