
namespace OrganisationDomain.Endpoint.Xrm
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.Extensions.Logging;
    using Microsoft.Extensions.DependencyInjection;
    using NServiceBus;
    using SFA.FCS.Worker.Common;

    public class EndpointConfig : IEndpointConfig
    {
        // ✅ Assembly name
        public string NameOfAssembly =>
            "OrganisationDomain.Endpoint.dll";

        // ✅ Endpoint name
        public string EndpointName =>
            "OrgService.XrmEndpoint";

        // ✅ Subscriptions (empty if not event-driven)
        public IReadOnlyCollection<Subscription> Subscriptions =>
            Enumerable.Empty<Subscription>().ToList();

        // ✅ Routes (empty if not command routing)
        public IReadOnlyCollection<CommandRoute> Routes =>
            Enumerable.Empty<CommandRoute>().ToList();

        // ✅ Main configuration
        public EndpointConfiguration GetEndpointConfiguration(
            ILoggerFactory loggerFactory)
        {
            var configuration = new EndpointConfiguration(EndpointName);

            // ✅ Logging (standardised)
            var logger = loggerFactory.CreateLogger<EndpointConfig>();
            logger.LogInformation(
                "Started Endpoint {EndpointName} on FCS.Worker",
                EndpointName);

            // ✅ Conventions
            configuration.Conventions()
                .DefiningCommandsAs(t =>
                    t?.Namespace != null &&
                    t.Namespace.EndsWith("Commands"))
                .DefiningEventsAs(t =>
                    t?.Namespace != null &&
                    t.Namespace.EndsWith("Events"));

            // ✅ Serialization (REQUIRED for .NET 8)
            configuration.UseSerialization<SystemJsonSerializer>();

            // ✅ Dependency Injection (Microsoft DI)
            configuration.RegisterComponents(services =>
            {
                services.AddSingleton(loggerFactory);
                services.AddOrganisationXrmServices();
            });

            return configuration;
        }
    }
}
