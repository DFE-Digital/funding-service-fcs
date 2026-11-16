
namespace ContractCreateDomain.Endpoint.EnrichForDocumentation
{
    using System.Collections.Generic;
    using Microsoft.Extensions.Logging;
    using Microsoft.Extensions.DependencyInjection;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;

    public class EndpointConfig : IEndpointConfig
    {
        public string NameOfAssembly => "ContractCreateDomain.Endpoint.dll";

        public string EndpointName => "ContractCreateDomain.EnrichForDocumentation";

        public IReadOnlyCollection<Subscription> Subscriptions =>
            new List<Subscription>();

        public IReadOnlyCollection<CommandRoute> Routes => new List<CommandRoute>
        {
            new CommandRoute(
                "DocumentsDomain.GenerateDocument",
                typeof(DocumentGenerationCommand))
        };

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            var configuration = new EndpointConfiguration(EndpointName);

            // ✅ Logging (aligned)
            var logger = loggerFactory.CreateLogger<EndpointConfig>();
            logger.LogInformation("Started Endpoint {EndpointName}", EndpointName);

            // ✅ Conventions (aligned across all endpoints)
            configuration.Conventions()
                .DefiningCommandsAs(t =>
                    t?.Namespace != null && t.Namespace.EndsWith("Commands"))
                .DefiningEventsAs(t =>
                    t?.Namespace != null && t.Namespace.EndsWith("Events"));

            // ✅ Serialization (aligned)
            configuration.UseSerialization<SystemJsonSerializer>();

            // ✅ ✅ DI (aligned with other non-saga endpoints)
            configuration.RegisterComponents(services =>
            {
                services.AddSingleton(loggerFactory);
                services.AddEnrichForDocumentationServices();
            });

            return configuration;
        }
    }
}
