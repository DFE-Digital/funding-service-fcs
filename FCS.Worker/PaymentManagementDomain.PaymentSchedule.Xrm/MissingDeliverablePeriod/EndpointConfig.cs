
namespace PaymentManagementDomain.PaymentSchedule.MissingDeliverablePeriod
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.Extensions.Logging;
    using Microsoft.Extensions.DependencyInjection;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.CrossDomain.Integration.Common;

    public class EndpointConfig : IEndpointConfig
    {
        public string EndpointName =>
            "PaymentSchedule.MissingDeliverablePeriod";

        public string NameOfAssembly =>
            "PaymentManagementDomain.PaymentSchedule.dll";

        public IReadOnlyCollection<Subscription> Subscriptions =>
            new List<Subscription>();

        public IReadOnlyCollection<CommandRoute> Routes =>
            new List<CommandRoute>();

        public EndpointConfiguration GetEndpointConfiguration(
            ILoggerFactory loggerFactory)
        {
            var configuration = new EndpointConfiguration(EndpointName);

            // ✅ Logging (FIXED TraceSource)
            var logger = loggerFactory.CreateLogger<EndpointConfig>();
            logger.LogInformation("Started Endpoint {EndpointName} on FCS.Worker", EndpointName);

            // ✅ Conventions (preserved)
            configuration.Conventions()
                .DefiningCommandsAs(t =>
                    (t?.Namespace != null && t.Namespace.EndsWith("Commands")) ||
                    t.GetInterfaces().Contains(typeof(ICommand)));

            // ✅ Serialization
            configuration.UseSerialization<SystemJsonSerializer>();

            // ✅ ✅ Local DI
            configuration.RegisterComponents(services =>
            {
                services.AddSingleton(loggerFactory);
                services.AddMissingDeliverablePeriodServices();
            });

            return configuration;
        }
    }
}
