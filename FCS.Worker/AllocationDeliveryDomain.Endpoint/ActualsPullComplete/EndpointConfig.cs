
namespace AllocationDeliveryDomain.Endpoint.ActualsPullComplete
{
    using System.Collections.Generic;
    using System.Linq;
    using AllocationDelivery.Messages.Commands;
    using Microsoft.Extensions.Logging;
    using Microsoft.Extensions.DependencyInjection;
    using NServiceBus;
    using SFA.FCS.Worker.Common;

    public class EndpointConfig : IEndpointConfig
    {
        public string EndpointName => "AllocationDeliveryDomain.ActualsPullComplete";

        public string NameOfAssembly => "AllocationDeliveryDomain.Endpoint.dll";

        public IReadOnlyCollection<CommandRoute> Routes => new List<CommandRoute>
        {
            new CommandRoute(
                "AllocationDeliveryDomain.Routing",
                typeof(ReportedActualsRoutingCommand))
        };

        public IReadOnlyCollection<Subscription> Subscriptions =>
            Enumerable.Empty<Subscription>().ToList();

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
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

            // ✅ DI (replaces Windsor)
            configuration.RegisterComponents(services =>
            {
                services.AddSingleton(loggerFactory);
                services.AddActualsPullCompleteServices();
            });

            return configuration;
        }
    }
}
