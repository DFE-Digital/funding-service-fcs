
namespace ADMonitoringDomain.Endpoint
{
    using Microsoft.Extensions.Logging;
    using NServiceBus;
    using NServiceBus.Transport.AzureServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.CrossDomain.Integration.Events;
    using System;
    using System.Collections.Generic;
    using System.Linq;

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
            var configuration = new EndpointConfiguration(EndpointName);

            // ✅ Logging
            var logger = loggerFactory.CreateLogger<EndpointConfig>();
            logger.LogInformation("Starting Endpoint {EndpointName}", EndpointName);

            // ✅ Azure Service Bus Transport (NEW API - FIXED)
            var connectionString = Environment.GetEnvironmentVariable("AzureServiceBusConnection");

            if (string.IsNullOrWhiteSpace(connectionString))
            {
                throw new InvalidOperationException(
                    "AzureServiceBusConnection environment variable is not set.");
            }

            // ✅ Correct for your version
            var transport = configuration.UseTransport(
                new AzureServiceBusTransport(
                    connectionString,
                    TopicTopology.Default));

            // ✅ Persistence (Dev-friendly; replace with SQL in prod)
            configuration.UsePersistence<LearningPersistence>();

            // ✅ Installers
            configuration.EnableInstallers();

            // ✅ Recoverability
            configuration.Recoverability()
                .Immediate(i => i.NumberOfRetries(3))
                .Delayed(d => d.NumberOfRetries(3));

            // ✅ Event conventions (robust)
            configuration.Conventions()
                .DefiningEventsAs(t =>
                    Subscriptions.Any(s => s.EventType.IsAssignableFrom(t)));

            // ✅ Serialization
            configuration.UseSerialization<SystemJsonSerializer>();

            return configuration;
        }
    }
}
