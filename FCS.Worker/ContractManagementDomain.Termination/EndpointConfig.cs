namespace ContractManagementDomain.Termination
{
    using System.Collections.Generic;
    using System.Linq;
    using Castle.Windsor;
    using SFA.FCS.Worker.Common;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class EndpointConfig : IEndpointConfig
    {
        private static readonly IReadOnlyCollection<string> EventsUsedInThisEndpoint = new List<string>
        {
            nameof(ContractPlacedUnderTerminationForApproveInitiationEvent),
            nameof(ContractPlacedUnderTerminationForUpdatedDetailsEvent),
            nameof(ContractTerminationCancelledEvent),
            nameof(ContractTerminatedEvent),
            nameof(ContractTerminationFailedEvent)
        };

        public string EndpointName => "ContractManagement.ContractTermination";

        public string NameOfAssembly => "ContractManagementDomain.Termination.dll";

        public IReadOnlyCollection<Subscription> Subscriptions => new List<Subscription>();

        public IReadOnlyCollection<CommandRoute> Routes => new List<CommandRoute>
        {
            new CommandRoute("FundingAllocation.ReleaseGroup", typeof(ReleaseQueuedFundingAllocationsForContractsCommand))
        };

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            EndpointConfiguration configuration = new EndpointConfiguration(EndpointName);

            var logger = new Logger(new System.Diagnostics.TraceSource("WorkerRole"));

            logger.LogInformation(1, $"Started Endpoint {EndpointName} on FCS.Worker");

            configuration.Conventions()
                .DefiningCommandsAs(t => (t.Namespace != null && t.Namespace.EndsWith("Commands")) || t.GetInterfaces().Contains(typeof(ICommand)))
                .DefiningEventsAs(t => EventsUsedInThisEndpoint.Any(e => t.Name.EndsWith(e)));

            // todo
            configuration.UseContainer<WindsorBuilder>(customizations: customizations =>
            {
                customizations.ExistingContainer(new WindsorContainer().Install(new WindsorInstaller(loggerFactory)));
            });

            return configuration;
        }
    }
}
