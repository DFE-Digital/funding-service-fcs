namespace PerformanceManagementDomain.XrmEndpoint
{
    using System.Collections.Generic;
    using System.Linq;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Castle.Windsor;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Events;

    public class EndpointConfig : IEndpointConfig
    {
        public string NameOfAssembly => FctEndpoint.GenerateEndpointName("PerformanceManagementDomain.XrmEndpoint.dll");

        public string EndpointName => "PerformanceManagementDomain.XrmEndpoint";

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

        public IReadOnlyCollection<CommandRoute> Routes => new List<CommandRoute>();

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            EndpointConfiguration configuration = new EndpointConfiguration(EndpointName);

            var logger = loggerFactory.CreateDefaultLogger();

            logger.LogInformation(1, $"Started Endpoint {EndpointName} on FCS.Worker");

            configuration.Conventions()
                .DefiningEventsAs(t => EventsUsedInThisEndpoint.Any(e => t.Name.EndsWith(e)));


            configuration.UseContainer<WindsorBuilder>(customizations: customizations =>
            {
                customizations.ExistingContainer(new WindsorContainer().Install(new WindsorInstaller(loggerFactory)));
            });

            return configuration;
        }
    }
}