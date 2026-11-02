namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentAggregation
{
    using System;
    using Castle.Windsor;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.CrossDomain.Integration.Events;
    using Framework.Logging.Interfaces;
    using IoC;
    using System.Collections.Generic;
    using System.Linq;

    public class PaymentAggregationEndpointConfig : IEndpointConfig
    {
        public string NameOfAssembly => "PaymentManagementDomain.Integration.PaymentAggregation.dll";

        public string EndpointName => "PaymentManagementDomain.PaymentAggregation";

        public IReadOnlyCollection<Subscription> Subscriptions => new[]
        {
            new Subscription("PaymentManagementDomain.PaymentSchedule", typeof(PaymentScheduleEvent))
        };

        public IReadOnlyCollection<Type> TypesPublished = new List<Type>
        {
            typeof(PaymentAggregatedEvent)
        };

        public IReadOnlyCollection<CommandRoute> Routes => new List<CommandRoute>();

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            var configuration = new EndpointConfiguration(EndpointName);

            var logger = loggerFactory.CreateDefaultLogger();

            logger.LogInformation(1, $"Started Endpoint {EndpointName} on CDI");

            configuration.Conventions()
                .DefiningEventsAs(t => Subscriptions.Select(s => s.EventType.Name).Any(e => t.Name.EndsWith(e)) || TypesPublished.Contains(t));

            configuration.UseContainer<WindsorBuilder>(customizations: customizations =>
            {
                customizations.ExistingContainer(new WindsorContainer().Install(new WindsorInstaller(loggerFactory)));
            });

            return configuration;
        }
    }
}
