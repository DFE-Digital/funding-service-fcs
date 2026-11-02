namespace AllocationDeliveryDomain.Endpoint.ContractUnderTerminationEndpoint
{
    using System.Collections.Generic;
    using System.Linq;
    using Castle.Windsor;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class EndpointConfig : IEndpointConfig
    {
        public string EndpointName => "AllocationDeliveryDomain.ContractUnderTermination";

        public string NameOfAssembly => "AllocationDeliveryDomain.Endpoint.dll";

        private static readonly IReadOnlyCollection<string> EventsUsedInThisEndpoint = new List<string>
        {
            nameof(ContractPlacedUnderTerminationForApproveInitiationEvent),
            nameof(ContractPlacedUnderTerminationForUpdatedDetailsEvent),
            nameof(ContractTerminationCancelledEvent),
            nameof(AllocationActualsUpdated),
            nameof(AllocationActualsVerified)
        };

        public IReadOnlyCollection<Subscription> Subscriptions => new[]
        {
            new Subscription("ContractManagement.ContractTermination", typeof(ContractPlacedUnderTerminationForApproveInitiationEvent)),
            new Subscription("ContractManagement.ContractTermination", typeof(ContractPlacedUnderTerminationForUpdatedDetailsEvent)),
            new Subscription("ContractManagement.ContractTermination", typeof(ContractTerminationCancelledEvent)),
        };

        public IReadOnlyCollection<CommandRoute> Routes => Enumerable.Empty<CommandRoute>().ToList();
        
        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            EndpointConfiguration configuration = new EndpointConfiguration(EndpointName);

            Logger logger = new Logger(new System.Diagnostics.TraceSource("WorkerRole"));

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
