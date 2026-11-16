
namespace PaymentGenerationDomain.Endpoint.ProcessPaymentRunEndpoint
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.Extensions.Logging;
    using Microsoft.Extensions.DependencyInjection;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;

    public class EndpointConfig : IEndpointConfig
    {
        public string EndpointName => "PaymentGenerationDomain.ProcessPaymentRun";

        public string NameOfAssembly => "PaymentGenerationDomain.Endpoint.dll";

        public IReadOnlyCollection<Subscription> Subscriptions =>
            Enumerable.Empty<Subscription>().ToList();

        public IReadOnlyCollection<CommandRoute> Routes => new[]
        {
            new CommandRoute(
                "PaymentGenerationDomain.ProcessPaymentComplete",
                typeof(ProcessPaymentRunCompleteCommand)),

            new CommandRoute(
                "PaymentGenerationDomain.ProcessPaymentError",
                typeof(ProcessPaymentRunErrorCommand))
        };

        public EndpointConfiguration GetEndpointConfiguration(
            ILoggerFactory loggerFactory)
        {
            var configuration = new EndpointConfiguration(EndpointName);

            var logger = loggerFactory.CreateLogger<EndpointConfig>();
            logger.LogInformation("Started Endpoint {EndpointName}", EndpointName);

            // ✅ Conventions
            configuration.Conventions()
                .DefiningCommandsAs(t =>
                    t.Namespace != null && t.Namespace.EndsWith("Commands"))
                .DefiningEventsAs(t =>
                    t.Namespace != null && t.Namespace.EndsWith("Events"));

            // ✅ Serialization
            configuration.UseSerialization<SystemJsonSerializer>();

            // ✅ DI
            configuration.RegisterComponents(services =>
            {
                services.AddSingleton(loggerFactory);
                services.AddProcessPaymentRunServices();
            });

            return configuration;
        }
    }
}