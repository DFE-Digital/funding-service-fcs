namespace PaymentGenerationDomain.Integration.PaymentGenerationEndpoint.AggregatePaymentEndpoint
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Castle.Windsor;
    using Ioc;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class EndpointConfig : IEndpointConfig
    {
        public string NameOfAssembly => "PaymentGenerationDomain.Integration.PaymentGenerationEndpoint.dll";

        public string EndpointName => "PaymentGenerationDomain.AggregatePayment";

        public IReadOnlyCollection<CommandRoute> Routes => Enumerable.Empty<CommandRoute>().ToArray();

        public IReadOnlyCollection<Subscription> Subscriptions => new []
        {
            new Subscription("PaymentManagementDomain.PaymentAggregation", typeof(PaymentAggregatedEvent)), 
        };

        private static readonly IReadOnlyCollection<Type> PublishedTypes = new List<Type>
        {
            typeof(AllocationPaymentsChangedOnAggregationEvent)
        };

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            EndpointConfiguration configuration = new EndpointConfiguration(EndpointName);

            ILogger logger = loggerFactory.CreateDefaultLogger();

            logger.LogInformation(1, $"Started Endpoint {EndpointName} on CrossDomain.Integration");

            configuration.Conventions()
                .DefiningCommandsAs(t => t.Namespace != null && t.Namespace.EndsWith("Commands"))
                .DefiningEventsAs(t => Subscriptions.Select(s => s.EventType.Name).Any(e => t.Name.EndsWith(e)) || PublishedTypes.Contains(t))
                .DefiningMessagesAs(t => null != t.Namespace && t.Namespace.EndsWith("Messages"));

            configuration.UseContainer<WindsorBuilder>(customizations: customizations =>
            {
                customizations.ExistingContainer(new WindsorContainer().Install(new AggregatePaymentWindsorInstaller(loggerFactory)));
            });

            return configuration;
        }
    }
}
