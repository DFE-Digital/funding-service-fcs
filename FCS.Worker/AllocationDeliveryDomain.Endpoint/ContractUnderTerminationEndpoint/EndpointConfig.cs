
namespace AllocationDeliveryDomain.Endpoint.ContractUnderTerminationEndpoint
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.Extensions.Logging;
    using Microsoft.Extensions.DependencyInjection;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.CrossDomain.Integration.Events;
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

        public IReadOnlyCollection<CommandRoute> Routes =>
            Enumerable.Empty<CommandRoute>().ToList();

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            var configuration = new EndpointConfiguration(EndpointName);

            var logger = loggerFactory.CreateLogger<EndpointConfig>();
            logger.LogInformation("Started Endpoint {EndpointName}", EndpointName);

            // ✅ Preserve custom event mapping
            configuration.Conventions()
                .DefiningEventsAs(t =>
                    EventsUsedInThisEndpoint.Any(e => t.Name.EndsWith(e)));

            // ✅ Serialization
            configuration.UseSerialization<SystemJsonSerializer>();

            // ✅ DI (Microsoft DI)
            configuration.RegisterComponents(services =>
            {
                services.AddSingleton(loggerFactory);
                services.AddContractUnderTerminationServices();
            });

            return configuration;
        }
    }
}

