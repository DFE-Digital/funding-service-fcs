namespace ADMonitoringDomain.Endpoint
{
    using System.Collections.Generic;
    using System.Linq;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Castle.Windsor;
    using SFA.FCS.Worker.Common;

    public class EndpointConfig : IEndpointConfig
    {
        public string NameOfAssembly => "ADMonitoringDomain.Endpoint.dll";
        public string EndpointName => "ADMonitoringDomain.Endpoint";

        public IReadOnlyCollection<Subscription> Subscriptions => new[]
        {
            new Subscription("AllocationDeliveryDomain.Validation", typeof(AllocationActualsVerified)),
            new Subscription("AllocationDeliveryDomain.ContractUnderTermination", typeof(AllocationActualsUpdated)),
            new Subscription("PaymentManagementDomain.PaymentAggregation", typeof(PaymentAggregatedEvent)),

            new Subscription("PaymentGenerationDomain.ProcessPaymentComplete", typeof(IPaymentPostedEvent)),
            new Subscription("PaymentManagementDomain.PaymentSchedule", typeof(PaymentScheduleEvent)),
            new Subscription("AllocationDelivery.MonitoringDeliverablesEnrichment", typeof(AllocationDeliveryCommencedEvent)),
        };

        public IReadOnlyCollection<CommandRoute> Routes => new List<CommandRoute>();

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            EndpointConfiguration configuration = new EndpointConfiguration(EndpointName);

            var logger = loggerFactory.CreateDefaultLogger();

            logger.LogInformation(1, $"Started Endpoint {EndpointName} on CDI");

            configuration.Conventions()
                .DefiningEventsAs(t => Subscriptions.Select(s => s.EventType.Name).Any(e => t.Name.EndsWith(e)));


            configuration.UseContainer<WindsorBuilder>(customizations: customizations =>
            {
                customizations.ExistingContainer(new WindsorContainer().Install(new ADMonitoringDomain.Endpoint.Ioc.WindsorInstaller(loggerFactory)));
            });

            return configuration;
        }
    }
}
