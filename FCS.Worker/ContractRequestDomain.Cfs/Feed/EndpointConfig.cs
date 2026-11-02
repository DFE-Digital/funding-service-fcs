namespace ContractRequestDomain.Cfs.Feed
{
    using SFA.FCS.Worker.Common;
    using System.Collections.Generic;
    using Castle.Windsor;
    using NServiceBus;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class EndpointConfig : IEndpointConfig
    {
        public string NameOfAssembly => "ContractRequestDomain.Cfs.dll";

        public string EndpointName => "ContractRequestDomain.Cfs.Feed";

        public IReadOnlyCollection<Subscription> Subscriptions { get; } = new List<Subscription>();

        public IReadOnlyCollection<CommandRoute> Routes { get; } = new List<CommandRoute>();

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            EndpointConfiguration configuration = new EndpointConfiguration(EndpointName);

            var logger = loggerFactory.CreateDefaultLogger();

            logger.LogInformation(1, $"Started Endpoint {EndpointName} on FCS.Worker");

            configuration.Conventions()
                .DefiningCommandsAs(t => (t.Namespace != null && t.Namespace.EndsWith("Commands")));

            configuration.UseContainer<WindsorBuilder>(customizations: customizations =>
            {
                customizations.ExistingContainer(new WindsorContainer().Install(new WindsorInstaller(loggerFactory)));
            });

            return configuration;
        }
    }
}
