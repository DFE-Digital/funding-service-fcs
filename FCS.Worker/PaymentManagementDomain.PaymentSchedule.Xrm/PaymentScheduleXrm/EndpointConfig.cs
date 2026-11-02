namespace PaymentManagementDomain.PaymentSchedule.PaymentScheduleXrm
{
    using System.Collections.Generic;
    using System.Linq;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Microsoft.Xrm.Sdk;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.Xrm.Integration.IoC;

    public class EndpointConfig : IEndpointConfig
    {
        private static readonly IReadOnlyCollection<string> EventsUsedInThisEndpoint = new List<string>
        {
            nameof(PaymentScheduleEvent),
            nameof(IDeferrableEvent)
        };

        public string EndpointName => "Xrm.ReceiveQueueForPaymentSchedule";

        public string NameOfAssembly => "PaymentManagementDomain.PaymentSchedule.dll";

        public IReadOnlyCollection<Subscription> Subscriptions =>
            new List<Subscription>
            {
                new Subscription("PaymentManagementDomain.PaymentSchedule", typeof(PaymentScheduleEvent))                
            };

        public IReadOnlyCollection<CommandRoute> Routes => 
        new List<CommandRoute>
        {
            new CommandRoute("Xrm.DeliverableAggregation", typeof(AggregateDeliverablesCommand))
        };

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            EndpointConfiguration configuration = new EndpointConfiguration(EndpointName);

            var logger = new Logger(new System.Diagnostics.TraceSource("WorkerRole"));

            logger.LogInformation(1, $"Started Endpoint {EndpointName} on FCS.Worker");

            configuration.Conventions()
                .DefiningEventsAs(t => EventsUsedInThisEndpoint.Any(t.Name.EndsWith))
                .DefiningCommandsAs(t => (t.Namespace != null && t.Namespace.EndsWith("Commands")) || t.GetInterfaces().Contains(typeof(ICommand)));

            var container = new WindsorContainer();
            container.Install(new WindsorInstaller(loggerFactory));
            
            configuration.UseContainer<WindsorBuilder>(customizations: customizations =>
            {
                customizations.ExistingContainer(container);
            });

            return configuration;
        }
    }
}
