namespace SFA.FCT.AllocationDeliveryDomain.MDEnrich.Endpoint
{
    using CrossDomain.Integration.Events;
    using Microsoft.Extensions.Logging;
    using Ioc;
    using Microsoft.Extensions.DependencyInjection;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using System;
    using System.Collections.Generic;
    using System.Linq;

    public class EndpointConfig : IEndpointConfig
    {
        public string NameOfAssembly => "AllocationDeliveryDomain.MDEnrich.dll";

        public string EndpointName => "AllocationDelivery.MonitoringDeliverablesEnrichment";

        public IReadOnlyCollection<Subscription> Subscriptions => new[]
        {
            new Subscription("ContractManagementDomain.ContractApproved", typeof(ContractApprovedEvent)),
            new Subscription("ContractManagementDomain.ContractClosure", typeof(ContractClosedEvent))
        };

        public IReadOnlyCollection<CommandRoute> Routes =>
            new List<CommandRoute>();

        private IReadOnlyCollection<Type> TypesPublished = new List<Type>
        {
            typeof(AllocationDeliveryCommencedEvent)
        };

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            var configuration = new EndpointConfiguration(EndpointName);

            var logger = loggerFactory.CreateLogger<EndpointConfig>();
            logger.LogInformation("Started Endpoint {EndpointName}", EndpointName);

            // ✅ Conventions only
            configuration.Conventions()
                .DefiningCommandsAs(t =>
                    (t?.Namespace != null && t.Namespace.EndsWith("Commands")) ||
                    typeof(ICommand).IsAssignableFrom(t))
                .DefiningEventsAs(t =>
                    Subscriptions.Any(s => s.EventType.IsAssignableFrom(t)) ||
                    TypesPublished.Contains(t));

            // ✅ Serialization
            configuration.UseSerialization<SystemJsonSerializer>();

            // ✅ DI only
            configuration.RegisterComponents(services =>
            {
                services.AddSingleton(loggerFactory);

                services.AddAllocationDeliveryServices(loggerFactory);
            });

            return configuration;
        }
    }
}
