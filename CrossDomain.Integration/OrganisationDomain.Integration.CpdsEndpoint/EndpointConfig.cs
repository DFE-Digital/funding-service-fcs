
namespace OrganisationDomain.Integration.CpdsEndpoint
{
    using Ioc;
    using Messages.Commands;
    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.Extensions.Logging;
    using NServiceBus;
    using OrganisationDomain.Integration.CpdsEndpoint.IoC;
    using SFA.FCS.Worker.Common;
    using System.Collections.Generic;
    using System.Linq;

    public class EndpointConfig : IEndpointConfig
    {
        public string NameOfAssembly =>
            "OrganisationDomain.Integration.CpdsEndpoint.dll";

        public string EndpointName => "OrgService.CPDS";

        public IReadOnlyCollection<Subscription> Subscriptions =>
            new List<Subscription>();

        public IReadOnlyCollection<CommandRoute> Routes => new List<CommandRoute>
        {
            new CommandRoute("OrgService.Main", typeof(ProcessProviderSummary)),
            new CommandRoute("OrgService.Main", typeof(ProcessOrganisationDetails))
        };

        public EndpointConfiguration GetEndpointConfiguration(
            ILoggerFactory loggerFactory)
        {
            var configuration = new EndpointConfiguration(EndpointName);

            // ✅ Logging FIXED
            var logger = loggerFactory.CreateLogger<EndpointConfig>();
            logger.LogInformation("Started Endpoint {EndpointName} on CrossDomain.Integration", EndpointName);

            // ✅ Conventions (preserved)
            configuration.Conventions()
                .DefiningCommandsAs(t =>
                    t?.Namespace != null && t.Namespace.EndsWith("Commands"))
                .DefiningEventsAs(t =>
                    Subscriptions.Select(s => s.EventType.Name)
                        .Any(e => t.Name.EndsWith(e)));

            // ✅ Serialization
            configuration.UseSerialization<SystemJsonSerializer>();

            // ✅ ✅ DI
            configuration.RegisterComponents(services =>
            {
                services.AddSingleton(loggerFactory);
                services.AddCpdsEndpointServices();
            });

            return configuration;
        }
    }
}
