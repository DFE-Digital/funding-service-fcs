namespace FCT.Operations.Connectivity
{
    using System;
    using NServiceBus;
    using System.Linq;
    using Castle.Windsor;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.Framework.Logging.Interfaces;
    using System.Collections.Generic;
    using SFA.FCT.CrossDomain.Integration.Messages.Messages;

    public class EndpointConfig : IEndpointConfigWithFcsConfig
    {
        public string EndpointName => "Operations.Connectivity";

        public string NameOfAssembly => "FCT.Operations.dll";

        private static readonly IReadOnlyCollection<string> EventsUsedInThisEndpoint = new List<string>();

        private static readonly IReadOnlyCollection<Type> CommandsUsedInThisEndpoint = new List<Type>
        {
            typeof(CheckConnectivityReply)
        };
        string IEndpointConfigWithFcsConfig.EndpointName => EndpointName;

        public IReadOnlyCollection<Subscription> Subscriptions => new List<Subscription>();

        public IReadOnlyCollection<CommandRoute> Routes => new List<CommandRoute>();

        public EndpointConfiguration GetEndpointConfiguration(ILogger logger, IFcsConfiguration appConfiguration)
        {
            EndpointConfiguration configuration = new EndpointConfiguration(EndpointName);

            logger.LogInformation(1, $"Started Endpoint {EndpointName} on Ops.Worker");

            configuration.Conventions()
                .DefiningCommandsAs(t => CommandsUsedInThisEndpoint.Contains(t) || t.Namespace != null && t.Namespace.EndsWith("Messages"))
                .DefiningEventsAs(t => EventsUsedInThisEndpoint.Any(e => t.Name.EndsWith(e)));

            configuration.UseContainer<WindsorBuilder>(customizations: customizations =>
            {
                customizations.ExistingContainer(new WindsorContainer().Install(new WindsorInstaller(logger, appConfiguration)));
            });

            return configuration;
        }
    }
}