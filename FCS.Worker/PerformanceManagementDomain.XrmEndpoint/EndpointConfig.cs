
namespace PerformanceManagementDomain.XrmEndpoint
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.Extensions.Logging;
    using Microsoft.Extensions.DependencyInjection;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Events;

    public class EndpointConfig : IEndpointConfig
    {
        public string NameOfAssembly =>
            FctEndpoint.GenerateEndpointName("PerformanceManagementDomain.XrmEndpoint.dll");

        public string EndpointName =>
            "PerformanceManagementDomain.XrmEndpoint";

        private static readonly IReadOnlyCollection<string> EventsUsedInThisEndpoint = new[]
        {
            nameof(FundingClaimReconciliationPublishedEvent),
            nameof(FundingClaimReconciliationFailedPublicationEvent),
            nameof(ProposedReconciliationCalculatedEvent)
        };

        public IReadOnlyCollection<Subscription> Subscriptions => new[]
        {
            new Subscription("PerformanceManagementDomain.ReconciliationPublication", typeof(FundingClaimReconciliationPublishedEvent)),
            new Subscription("PerformanceManagementDomain.ReconciliationPublication", typeof(FundingClaimReconciliationFailedPublicationEvent)),
            new Subscription("PerformanceManagementDomain.ReconciliationCalculation", typeof(ProposedReconciliationCalculatedEvent))
        };

        public IReadOnlyCollection<CommandRoute> Routes =>
            new List<CommandRoute>();

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            var configuration = new EndpointConfiguration(EndpointName);

            // ✅ Logging
            var logger = loggerFactory.CreateLogger<EndpointConfig>();
            logger.LogInformation("Started Endpoint {EndpointName}", EndpointName);

            // ✅ Conventions (event-based endpoint)
            configuration.Conventions()
                .DefiningEventsAs(t =>
                    EventsUsedInThisEndpoint.Any(e => t.Name.EndsWith(e)));

            // ✅ Serialization
            configuration.UseSerialization<SystemJsonSerializer>();

            // ✅ ✅ Local DI
            configuration.RegisterComponents(services =>
            {
                services.AddSingleton(loggerFactory);
                services.AddPerformanceXrmServices();
            });

            return configuration;
        }
    }
}
