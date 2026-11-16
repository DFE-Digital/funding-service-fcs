
namespace AllocationDeliveryDomain.Endpoint.MonthEndCheck
{
    using IoC;
    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.Extensions.Logging;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.AllocationDeliveryDomain.Common.Commands;
    using System;
    using System.Collections.Generic;
    using System.Linq;

    public class MonthEndCheckConfig : IEndpointConfig
    {
        public string NameOfAssembly => "AllocationDeliveryDomain.Endpoint.dll";

        public string EndpointName => "AllocationDeliveryDomain.MonthEndCheck";

        public IReadOnlyCollection<CommandRoute> Routes => new List<CommandRoute>
        {
            new CommandRoute("AllocationDeliveryDomain.ReleaseHeldReportedActuals", typeof(ReleaseHeldReportedActualsCommand))
        };

        public IReadOnlyCollection<Subscription> Subscriptions =>
            Enumerable.Empty<Subscription>().ToList();

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            var configuration = new EndpointConfiguration(EndpointName);

            var logger = loggerFactory.CreateLogger<MonthEndCheckConfig>();
            logger.LogInformation("Started Endpoint {EndpointName}", EndpointName);

            // ✅ Conventions only
            configuration.Conventions()
                .DefiningCommandsAs(t =>
                    (t?.Namespace != null && t.Namespace.EndsWith("Commands")) ||
                    typeof(ICommand).IsAssignableFrom(t))
                .DefiningEventsAs(t =>
                    t?.Namespace != null && t.Namespace.EndsWith("Events"));

            // ✅ Serialization
            configuration.UseSerialization<SystemJsonSerializer>();

            // ✅ DI only
            configuration.RegisterComponents(services =>
            {
                services.AddSingleton(loggerFactory);

                services.AddAllocationDomainServices(loggerFactory);
            });

            return configuration;
        }
    }
}
