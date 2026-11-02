namespace PerformanceManagementDomain.ReconciliationCalculationEndpoint
{
    using System.Collections.Generic;
    using System.Linq;
    using Castle.Windsor;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.PerformanceManagementDomain.Common.Commands;

    public class EndPointConfig : IEndpointConfig
    {
        public string NameOfAssembly => "PerformanceManagementDomain.dll";

        public string EndpointName => "PerformanceManagementDomain.ReconciliationCalculation";

        private static readonly IReadOnlyCollection<string> EventsUsedInThisEndpoint = new[]
        {
            nameof(FundingClaimDebatchedEvent),
            nameof(ProposedReconciliationCalculatedEvent),
            nameof(ContractApprovedEvent)
        };

        public IReadOnlyCollection<Subscription> Subscriptions => new[]
        {
            new Subscription("PerformanceManagementDomain.FundingClaimImport", typeof(FundingClaimDebatchedEvent)),
            new Subscription("ContractManagementDomain.ContractApproved", typeof(ContractApprovedEvent))
        };

        public IReadOnlyCollection<CommandRoute> Routes => new[]
        {
            new CommandRoute(EndpointName, typeof(RecalculateFundingClaimReconciliationCommand))
        };

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            EndpointConfiguration configuration = new EndpointConfiguration(EndpointName);

            ILogger logger = loggerFactory.CreateDefaultLogger();

            logger.LogInformation(1, $"Started Endpoint {EndpointName} on FCS.Worker");

            configuration.Conventions()
                .DefiningCommandsAs(t => t.Namespace != null && t.Namespace.EndsWith("Commands"))
                .DefiningEventsAs(t => EventsUsedInThisEndpoint.Any(e => t.Name.EndsWith(e)));

            configuration.UseContainer<WindsorBuilder>(customizations: customizations =>
            {
                customizations.ExistingContainer(new WindsorContainer().Install(new WindsorInstaller(loggerFactory)));
            });

            return configuration;
        }
    }
}