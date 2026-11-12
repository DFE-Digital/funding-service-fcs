
namespace OrganisationDomain.Integration.DataStoreEndpoint
{
    using System.Collections.Generic;
    using Microsoft.Extensions.Logging;
    using Microsoft.Extensions.DependencyInjection;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using Messages.Commands;
    using Ioc;

    public class EndpointConfig : IEndpointConfig
    {
        public string NameOfAssembly =>
            "OrganisationDomain.Integration.DataStoreEndpoint.dll";

        public string EndpointName => "OrgService.DataStore";

        public IReadOnlyCollection<Subscription> Subscriptions =>
            new List<Subscription>();

        public IReadOnlyCollection<CommandRoute> Routes => new List<CommandRoute>
        {
            new CommandRoute("OrgService.Main", typeof(ProcessUpdatedOrganisations)),
            new CommandRoute("OrgService.Main", typeof(ProcessSavedOrganisation)),
            new CommandRoute("OrgService.XrmEndpoint", typeof(CreateProviderUpdatedNotificationCommand))
        };

        public EndpointConfiguration GetEndpointConfiguration(
            ILoggerFactory loggerFactory)
        {
            var configuration = new EndpointConfiguration(EndpointName);

            // ✅ Logging
            var logger = loggerFactory.CreateLogger<EndpointConfig>();
            logger.LogInformation("Started Endpoint {EndpointName} on CrossDomain.Integration", EndpointName);

            // ✅ Conventions (preserved exactly)
            configuration.Conventions()
                .DefiningCommandsAs(t =>
                    (t?.Namespace != null && t.Namespace.EndsWith("Commands")) ||
                    t.Name.EndsWith(nameof(SaveUpdatedOrganisation)) ||
                    t.Name.EndsWith(nameof(GetUpdatedOrganisations)))
                .DefiningEventsAs(t =>
                    t?.Namespace != null && t.Namespace.EndsWith("Events"));

            // ✅ Serialization
            configuration.UseSerialization<SystemJsonSerializer>();

            // ✅ ✅ Local DI
            configuration.RegisterComponents(services =>
            {
                services.AddSingleton(loggerFactory);
                services.AddOrganisationDataStoreServices();
            });

            return configuration;
        }
    }
}
