
namespace AllocationDeliveryDomain.Endpoint.PaymentInstructionValidation
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.Extensions.Logging;
    using Microsoft.Extensions.DependencyInjection;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;

    public class EndpointConfig : IEndpointConfig
    {
        public string EndpointName => "AllocationDeliveryDomain.PaymentInstructionValidation";

        public string NameOfAssembly => "AllocationDeliveryDomain.Endpoint.dll";

        private static readonly IReadOnlyCollection<string> EventsUsedInThisEndpoint = new List<string>
        {
            nameof(IAllocationPaymentInstructionReceivedEvent)
        };

        public IReadOnlyCollection<CommandRoute> Routes => new[]
        {
            new CommandRoute(
                "PaymentSchedule.MissingDeliverablePeriod",
                typeof(AddMissingDeliverablePeriodCommand)),
        };

        public IReadOnlyCollection<Subscription> Subscriptions =>
            Enumerable.Empty<Subscription>().ToList();

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            var configuration = new EndpointConfiguration(EndpointName);

            var logger = loggerFactory.CreateLogger<EndpointConfig>();
            logger.LogInformation("Started Endpoint {EndpointName}", EndpointName);

            // ✅ Preserve custom event logic
            configuration.Conventions()
                .DefiningEventsAs(t =>
                    EventsUsedInThisEndpoint.Any(e => t.Name.EndsWith(e)))
                .DefiningCommandsAs(t =>
                    t.Namespace != null && t.Namespace.EndsWith("Commands"));

            // ✅ Serialization
            configuration.UseSerialization<SystemJsonSerializer>();

            // ✅ DI
            configuration.RegisterComponents(services =>
            {
                services.AddSingleton(loggerFactory);
                services.AddPaymentInstructionValidationServices();
            });

            return configuration;
        }
    }
}
