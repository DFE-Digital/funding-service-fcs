
namespace PaymentGenerationDomain.Endpoint.PaymentPostedEndpoint
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.Extensions.Logging;
    using Microsoft.Extensions.DependencyInjection;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.CrossDomain.Integration.Events;

    public class EndpointConfig : IEndpointConfig
    {
        public string EndpointName =>
            "PaymentGenerationDomain.PaymentPostedEndpoint";

        public string NameOfAssembly =>
            "PaymentGenerationDomain.Endpoint.dll";

        public IReadOnlyCollection<Subscription> Subscriptions =>
            new List<Subscription>
            {
                new Subscription(
                    "PaymentGenerationDomain.ProcessPaymentComplete",
                    typeof(PaymentPostedEvent))
            };

        public IReadOnlyCollection<CommandRoute> Routes =>
            Enumerable.Empty<CommandRoute>().ToList();

        public EndpointConfiguration GetEndpointConfiguration(
            ILoggerFactory loggerFactory)
        {
            var configuration = new EndpointConfiguration(EndpointName);

            var logger = loggerFactory.CreateLogger<EndpointConfig>();
            logger.LogInformation("Started Endpoint {EndpointName}", EndpointName);

            // ✅ Keep your custom event convention
            configuration.Conventions()
                .DefiningEventsAs(t =>
                    Subscriptions
                        .Select(s => s.EventType.Name)
                        .Any(e => t.Name.EndsWith(e)));

            // ✅ Serialization
            configuration.UseSerialization<SystemJsonSerializer>();

            // ✅ MS DI (replaces Windsor)
            configuration.RegisterComponents(services =>
            {
                services.AddSingleton(loggerFactory);
                services.AddPaymentPostedServices();
            });

            return configuration;
        }
    }
}
