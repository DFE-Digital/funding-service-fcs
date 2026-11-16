
namespace PaymentManagementDomain.PaymentSchedule.PaymentScheduleXrm
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.Extensions.Logging;
    using Microsoft.Extensions.DependencyInjection;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Common;

    public class EndpointConfig : IEndpointConfig
    {
        private static readonly IReadOnlyCollection<string> EventsUsedInThisEndpoint = new List<string>
        {
            nameof(PaymentScheduleEvent),
            nameof(IDeferrableEvent)
        };

        public string EndpointName =>
            "Xrm.ReceiveQueueForPaymentSchedule";

        public string NameOfAssembly =>
            "PaymentManagementDomain.PaymentSchedule.dll";

        public IReadOnlyCollection<Subscription> Subscriptions =>
            new List<Subscription>
            {
                new Subscription(
                    "PaymentManagementDomain.PaymentSchedule",
                    typeof(PaymentScheduleEvent))
            };

        public IReadOnlyCollection<CommandRoute> Routes =>
            new List<CommandRoute>
            {
                new CommandRoute(
                    "Xrm.DeliverableAggregation",
                    typeof(AggregateDeliverablesCommand))
            };

        public EndpointConfiguration GetEndpointConfiguration(
            ILoggerFactory loggerFactory)
        {
            var configuration = new EndpointConfiguration(EndpointName);

            // ✅ Logging (FIXED from TraceSource)
            var logger = loggerFactory.CreateLogger<EndpointConfig>();
            logger.LogInformation("Started Endpoint {EndpointName}", EndpointName);

            // ✅ Conventions (FIXED + PRESERVED)
            configuration.Conventions()
                .DefiningEventsAs(t =>
                    EventsUsedInThisEndpoint.Any(e => t.Name.EndsWith(e)))
                .DefiningCommandsAs(t =>
                    (t?.Namespace != null && t.Namespace.EndsWith("Commands")) ||
                    t.GetInterfaces().Contains(typeof(ICommand)));

            // ✅ Serialization
            configuration.UseSerialization<SystemJsonSerializer>();

            // ✅ ✅ Local DI
            configuration.RegisterComponents(services =>
            {
                services.AddSingleton(loggerFactory);
                services.AddPaymentScheduleXrmServices();
            });

            return configuration;
        }
    }
}
