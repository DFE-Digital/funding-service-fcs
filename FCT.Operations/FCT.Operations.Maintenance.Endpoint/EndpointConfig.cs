namespace SFA.FCT.Operations.Maintenance.Endpoint
{
    using System.Collections.Generic;
    using System.Linq;
    using Castle.Windsor;
    using Framework.Logging.Interfaces;
    using IoC;
    using NServiceBus;
    using SFA.FCS.Worker.Common;

    public class EndpointConfig : IEndpointConfigWithFcsConfig
    {
        public string NameOfAssembly => "FCT.Operations.Maintenance.Endpoint.dll";
        public string EndpointName => "Operations.Maintenance";
        public IReadOnlyCollection<Subscription> Subscriptions => new List<Subscription>();
        public IReadOnlyCollection<CommandRoute> Routes => new List<CommandRoute>();
        public EndpointConfiguration GetEndpointConfiguration(ILogger logger, IFcsConfiguration appConfiguration)
        {
            EndpointConfiguration configuration = new EndpointConfiguration(EndpointName);

            logger.LogInformation(1, $"Started Endpoint {EndpointName} on Ops.Worker");

            configuration.Conventions()
                .DefiningCommandsAs(t => (t.Namespace != null && t.Namespace.EndsWith("Commands")) || t.GetInterfaces().Contains(typeof(ICommand)));

            configuration.UseContainer<WindsorBuilder>(customizations: customizations =>
            {
                customizations.ExistingContainer(new WindsorContainer().Install(new WindsorInstaller(logger, appConfiguration)));
            });

            return configuration;
        }
    }
}
