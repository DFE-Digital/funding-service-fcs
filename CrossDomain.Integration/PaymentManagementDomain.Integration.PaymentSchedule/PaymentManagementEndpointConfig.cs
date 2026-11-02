namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Castle.Windsor;
    using NServiceBus;
    using CrossDomain.Integration.Events;
    using Framework.Logging.Interfaces;
    using IoC;
    using FCS.Worker.Common;

    public class PaymentManagementEndpointConfig : IEndpointConfig
    {
        public string NameOfAssembly => "PaymentManagementDomain.Integration.PaymentSchedule.dll";

        public string EndpointName => "PaymentManagementDomain.PaymentSchedule";

        public IReadOnlyCollection<CommandRoute> Routes => Enumerable.Empty<CommandRoute>().ToArray();

        public IReadOnlyCollection<Subscription> Subscriptions => new[]
        {
            new Subscription("AllocationDelivery.MonitoringDeliverablesEnrichment", typeof(AllocationDeliveryCommencedEvent)),
            new Subscription("AllocationDeliveryDomain.Validation", typeof(AllocationActualsVerified)),
            new Subscription("AllocationDeliveryDomain.ContractUnderTermination", typeof(AllocationActualsUpdated)),
            new Subscription("PerformanceManagementDomain.ReconciliationPublication", typeof(FundingClaimReconciliationPublishedEvent)),
            new Subscription("AllocationDeliveryDomain.PaymentInstructionValidation", typeof(IAllocationPaymentInstructionReceivedEvent))
        };

        private IReadOnlyCollection<Type> PublishedTypes = new List<Type>
        {
            typeof(PaymentScheduleEvent)
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
                customizations.ExistingContainer(new WindsorContainer().Install(new WindsorInstaller(loggerFactory)));
            });

            return configuration;
        }
    }
}