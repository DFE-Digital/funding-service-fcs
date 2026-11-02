namespace SFA.FCT.AllocationDeliveryDomain.MDEnrich.Endpoint
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Castle.Windsor;
    using CrossDomain.Integration.Events;
    using Framework.Logging.Interfaces;
    using Ioc;
    using NServiceBus;
    using SFA.FCS.Worker.Common;

    public class EndpointConfig : IEndpointConfig
    {
        public string NameOfAssembly => "AllocationDeliveryDomain.MDEnrich.dll";

        public string EndpointName => "AllocationDelivery.MonitoringDeliverablesEnrichment";

        public IReadOnlyCollection<Subscription> Subscriptions => new[]
        {
            new Subscription("ContractManagementDomain.ContractApproved", typeof(ContractApprovedEvent)),
            new Subscription("ContractManagementDomain.ContractClosure", typeof(ContractClosedEvent))
        };

        public IReadOnlyCollection<CommandRoute> Routes => new List<CommandRoute>();

        private IReadOnlyCollection<Type> TypesPublished = new List<Type>
        {
            typeof(AllocationDeliveryCommencedEvent)
        };

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            var configuration = new EndpointConfiguration(EndpointName);

            var logger = loggerFactory.CreateDefaultLogger();

            logger.LogInformation(1, $"Started Endpoint {EndpointName} on CDI");

            configuration.Conventions()
                .DefiningEventsAs(t => Subscriptions.Select(s => s.EventType.Name).Any(e => t.Name.EndsWith(e)) || TypesPublished.Contains(t));

            configuration.UseContainer<WindsorBuilder>(customizations: customizations =>
            {
                customizations.ExistingContainer(new WindsorContainer().Install(new ComponentInstaller(loggerFactory)));
            });

            return configuration;
        }
    }
}
