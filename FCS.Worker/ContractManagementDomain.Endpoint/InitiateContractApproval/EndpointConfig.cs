
namespace ContractManagementDomain.Endpoint.InitiateContractApproval
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.Extensions.Logging;
    using Microsoft.Extensions.DependencyInjection;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Events;

    public class EndpointConfig : IEndpointConfig
    {
        // ✅ Assembly
        public string NameOfAssembly =>
            "ContractManagementDomain.Endpoint.dll";

        // ✅ Endpoint name
        public string EndpointName =>
            "ContractManagementDomain.InitiateContractApproval";

        // ✅ Events used (only when needed)
        private static readonly IReadOnlyCollection<string> EventsUsedInThisEndpoint =
            new List<string>
            {
                nameof(ContractNotificationPublishedToProviderEvent)
            };

        // ✅ Subscriptions
        public IReadOnlyCollection<Subscription> Subscriptions => new[]
        {
            new Subscription(
                "DocumentsDomain.XrmHandler",
                typeof(ContractNotificationPublishedToProviderEvent))
        };

        // ✅ Command routes
        public IReadOnlyCollection<CommandRoute> Routes => new[]
        {
            new CommandRoute(
                "ContractManagementDomain.ContractApproved",
                typeof(PublishApprovedContractCommand))
        };

        // ✅ Endpoint configuration
        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            var configuration = new EndpointConfiguration(EndpointName);

            // ✅ Logging (standard)
            var logger = loggerFactory.CreateLogger<EndpointConfig>();
            logger.LogInformation(
                "Started Endpoint {EndpointName} on FCS.Worker",
                EndpointName);

            // ✅ Conventions (standardised)
            configuration.Conventions()
                .DefiningCommandsAs(t =>
                    t?.Namespace != null &&
                    t.Namespace.EndsWith("Commands"))
                .DefiningEventsAs(t =>
                    EventsUsedInThisEndpoint.Any(e => t.Name.EndsWith(e)));

            // ✅ Serialization (mandatory for .NET 8)
            configuration.UseSerialization<SystemJsonSerializer>();

            // ✅ Dependency Injection (clean call)
            configuration.RegisterComponents(services =>
            {
                services.AddSingleton(loggerFactory);
                services.AddInitiateContractApprovalServices();
            });

            return configuration;
        }
    }
}
