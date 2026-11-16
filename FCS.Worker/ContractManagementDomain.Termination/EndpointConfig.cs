
namespace ContractManagementDomain.Termination
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.Extensions.Logging;
    using Microsoft.Extensions.DependencyInjection;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;

    public class EndpointConfig : IEndpointConfig
    {
        private static readonly IReadOnlyCollection<string> EventsUsedInThisEndpoint =
            new List<string>
            {
                nameof(ContractPlacedUnderTerminationForApproveInitiationEvent),
                nameof(ContractPlacedUnderTerminationForUpdatedDetailsEvent),
                nameof(ContractTerminationCancelledEvent),
                nameof(ContractTerminatedEvent),
                nameof(ContractTerminationFailedEvent)
            };

        public string EndpointName =>
            "ContractManagement.ContractTermination";

        public string NameOfAssembly =>
            "ContractManagementDomain.Termination.dll";

        public IReadOnlyCollection<Subscription> Subscriptions =>
            new List<Subscription>();

        public IReadOnlyCollection<CommandRoute> Routes =>
            new List<CommandRoute>
            {
                new CommandRoute(
                    "FundingAllocation.ReleaseGroup",
                    typeof(ReleaseQueuedFundingAllocationsForContractsCommand))
            };

        public EndpointConfiguration GetEndpointConfiguration(
            ILoggerFactory loggerFactory)
        {
            var configuration = new EndpointConfiguration(EndpointName);

            // ✅ Logging FIX (replaces TraceSource)
            var logger = loggerFactory.CreateLogger<EndpointConfig>();
            logger.LogInformation(
                "Started Endpoint {EndpointName} on FCS.Worker",
                EndpointName);

            // ✅ Conventions (preserved exactly)
            configuration.Conventions()
                .DefiningCommandsAs(t =>
                    (t?.Namespace != null && t.Namespace.EndsWith("Commands")) ||
                    t.GetInterfaces().Contains(typeof(ICommand)))
                .DefiningEventsAs(t =>
                    EventsUsedInThisEndpoint.Any(e => t.Name.EndsWith(e)));

            // ✅ Required for .NET 8
            configuration.UseSerialization<SystemJsonSerializer>();

            // ✅ DI
            configuration.RegisterComponents(services =>
            {
                services.AddSingleton(loggerFactory);
                services.AddTerminationServices();
            });

            return configuration;
        }
    }
}
