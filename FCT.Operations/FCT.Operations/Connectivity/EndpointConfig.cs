
namespace FCT.Operations.Connectivity
{
    using System;
    using System.Linq;
    using System.Collections.Generic;
    using Microsoft.Extensions.DependencyInjection;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.CrossDomain.Integration.Messages.Messages;

    public class EndpointConfig : IEndpointConfigWithFcsConfig
    {
        public string EndpointName => "Operations.Connectivity";

        public string NameOfAssembly => "FCT.Operations.dll";

        private static readonly IReadOnlyCollection<string> EventsUsedInThisEndpoint =
            new List<string>();

        private static readonly IReadOnlyCollection<Type> CommandsUsedInThisEndpoint =
            new List<Type>
            {
                typeof(CheckConnectivityReply)
            };

        string IEndpointConfigWithFcsConfig.EndpointName => EndpointName;

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

            // ✅ Conventions
            configuration.Conventions()
                .DefiningCommandsAs(t =>
                    CommandsUsedInThisEndpoint.Contains(t) ||
                    (t.Namespace != null && t.Namespace.EndsWith("Messages")))
                .DefiningEventsAs(t =>
                    EventsUsedInThisEndpoint.Any(e => t.Name.EndsWith(e)));

            // ✅ Serialization (add if missing elsewhere)
            configuration.UseSerialization<SystemJsonSerializer>();

            // ✅ ✅ ✅ NEW DI (replaces Windsor)
            configuration.RegisterComponents(services =>
            {
                services.AddConnectivityServices(logger, appConfiguration);
            });

            return configuration;
        }
    }
}
