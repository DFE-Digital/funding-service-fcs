
namespace PaymentManagementDomain.PaymentSchedule.PaymentAggregated
{
    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.Extensions.Logging;
    using NServiceBus;
    using PaymentManagementDomain.PaymentSchedule.MissingDeliverablePeriod;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.CrossDomain.Integration.Events;
    using System.Collections.Generic;
    using System.Linq;

    public class EndpointConfig : IEndpointConfig
    {
        private static readonly IReadOnlyCollection<string> EventsUsedInThisEndpoint = new List<string>
        {
            nameof(AllocationPaymentsChangedOnAggregationEvent)
        };

        public string EndpointName =>
            "Xrm.ReceiveForPaymentAggregation";

        public string NameOfAssembly =>
            "PaymentManagementDomain.PaymentSchedule.dll";

        public IReadOnlyCollection<Subscription> Subscriptions =>
            new List<Subscription>
            {
                new Subscription(
                    "PaymentGenerationDomain.AggregatePayment",
                    typeof(AllocationPaymentsChangedOnAggregationEvent))
            };

        public IReadOnlyCollection<CommandRoute> Routes =>
            Enumerable.Empty<CommandRoute>().ToList();

        public EndpointConfiguration GetEndpointConfiguration(
            ILoggerFactory loggerFactory)
        {
            var configuration = new EndpointConfiguration(EndpointName);

            // ✅ Logging (FIXED)
            var logger = loggerFactory.CreateLogger<EndpointConfig>();
            logger.LogInformation("Started Endpoint {EndpointName} on FCS.Worker", EndpointName);

            // ✅ Conventions (FIXED BUG HERE)
            configuration.Conventions()
                .DefiningEventsAs(t =>
                    EventsUsedInThisEndpoint.Any(e => t.Name.EndsWith(e)))
                .DefiningCommandsAs(t =>
                    t?.Namespace != null && t.Namespace.EndsWith("Commands"));

            // ✅ Serialization
            configuration.UseSerialization<SystemJsonSerializer>();

            // ✅ ✅ Local DI
            configuration.RegisterComponents(services =>
            {
                services.AddSingleton(loggerFactory);
                services.AddPaymentAggregatedServices();
            });

            return configuration;
        }
    }
}