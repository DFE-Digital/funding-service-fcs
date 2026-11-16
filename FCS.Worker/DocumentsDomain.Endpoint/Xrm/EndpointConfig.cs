
namespace DocumentsDomain.Endpoint.Xrm
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.Extensions.Logging;
    using Microsoft.Extensions.DependencyInjection;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.DocumentsDomain.Common.Commands;

    public class EndpointConfig : IEndpointConfig
    {
        public string NameOfAssembly => "DocumentsDomain.Endpoint.dll";

        public string EndpointName => "DocumentsDomain.XrmHandler";

        private static readonly IReadOnlyCollection<string> EventsUsedInThisEndpoint = new List<string>
        {
            nameof(ContractReadyToPublishEvent),
            nameof(ContractNotificationPublishedToProviderEvent)
        };

        public IReadOnlyCollection<Subscription> Subscriptions => new[]
        {
            new Subscription(
                "ContractManagementDomain.ConfirmPublicationToProvider",
                typeof(ContractReadyToPublishEvent))
        };

        public IReadOnlyCollection<CommandRoute> Routes => new[]
        {
            new CommandRoute(
                "DocumentsDomain.DeleteDocument",
                typeof(GetDocumentsForDeleteCommand))
        };

        public EndpointConfiguration GetEndpointConfiguration(
            ILoggerFactory loggerFactory)
        {
            var configuration = new EndpointConfiguration(EndpointName);

            // ✅ Logging (fixed)
            var logger = loggerFactory.CreateLogger<EndpointConfig>();
            logger.LogInformation("Started Endpoint {EndpointName}", EndpointName);

            // ✅ Conventions (preserved)
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
                services.AddDocumentsXrmServices();
            });

            return configuration;
        }
    }
}
