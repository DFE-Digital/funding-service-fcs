
namespace SFA.FCT.Operations.Maintenance.Endpoint
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.Extensions.DependencyInjection;
    using Framework.Logging.Interfaces;
    using NServiceBus;
    using SFA.FCS.Worker.Common;

    public class EndpointConfig : IEndpointConfigWithFcsConfig
    {
        public string NameOfAssembly => "FCT.Operations.Maintenance.Endpoint.dll";

        public string EndpointName => "Operations.Maintenance";

        public IReadOnlyCollection<Subscription> Subscriptions =>
            new List<Subscription>();

        public IReadOnlyCollection<CommandRoute> Routes =>
            new List<CommandRoute>();

        public EndpointConfiguration GetEndpointConfiguration(
            ILogger logger,
            IFcsConfiguration appConfiguration)
        {
            var configuration = new EndpointConfiguration(EndpointName);

            logger.LogInformation(1, $"Started Endpoint {EndpointName} on Ops.Worker");

            configuration.Conventions()
                .DefiningCommandsAs(t =>
                    (t.Namespace != null && t.Namespace.EndsWith("Commands")) ||
                    t.GetInterfaces().Contains(typeof(ICommand)));

            // ✅ Serialization (optional but recommended)
            configuration.UseSerialization<SystemJsonSerializer>();

            // ✅ ✅ ✅ DI replacement
            configuration.RegisterComponents(services =>
            {
                services.AddMaintenanceServices(logger, appConfiguration);
            });

            return configuration;
        }
    }
}
