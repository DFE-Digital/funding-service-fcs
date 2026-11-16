
namespace ContractCreateDomain.Endpoint.Organisation
{    
    using Microsoft.Extensions.DependencyInjection;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.CrossDomain.Integration.Events;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.Extensions.Logging;

    public class EndpointConfig : IEndpointConfig
    {
        private static readonly IReadOnlyCollection<string> EventsUsedInThisEndpoint = new List<string>
        {
            nameof(OrganisationDetailsChanged)
        };

        public string NameOfAssembly => "ContractCreateDomain.Endpoint.dll";

        public string EndpointName => "ContractCreateDomain.Organisation";

        public IReadOnlyCollection<Subscription> Subscriptions => new List<Subscription>
        {
            new Subscription("OrgService.Main", typeof(OrganisationDetailsChanged))
        };

        public IReadOnlyCollection<CommandRoute> Routes =>
            new List<CommandRoute>();

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            var configuration = new EndpointConfiguration(EndpointName);

            // ✅ Logging
            var logger = loggerFactory.CreateLogger<EndpointConfig>();
            logger.LogInformation("Started Endpoint {EndpointName}", EndpointName);

            // ✅ Conventions
            configuration.Conventions()
                .DefiningCommandsAs(t =>
                    t?.Namespace != null && t.Namespace.EndsWith("Commands"))
                .DefiningEventsAs(t =>
                    EventsUsedInThisEndpoint.Any(e => t.Name.EndsWith(e)));

            // ✅ Serialization
            configuration.UseSerialization<SystemJsonSerializer>();

            // ✅ ✅ Local DI
            configuration.RegisterComponents(services =>
            {
                services.AddSingleton(loggerFactory);
                services.AddOrganisationServices();
            });

            return configuration;
        }
    }
}
