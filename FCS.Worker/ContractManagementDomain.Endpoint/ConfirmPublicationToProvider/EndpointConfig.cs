namespace ContractManagementDomain.Endpoint.ConfirmPublicationToProvider
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Castle.Windsor;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class EndpointConfig : IEndpointConfig
    {
        public string NameOfAssembly => "ContractManagementDomain.Endpoint.dll";

        public string EndpointName => "ContractManagementDomain.ConfirmPublicationToProvider";

        public IReadOnlyCollection<Subscription> Subscriptions => Enumerable.Empty<Subscription>().ToList();

        public IReadOnlyCollection<CommandRoute> Routes => new[]
        {
            new CommandRoute("DocumentsDomain.MoveDocument", typeof (DocumentMoveCommand))
        };

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            EndpointConfiguration configuration = new EndpointConfiguration(EndpointName);

            ILogger logger = loggerFactory.CreateDefaultLogger();

            var recoverability = configuration.Recoverability();
            recoverability.Immediate(
                        immediate =>
                        {
                            immediate.NumberOfRetries(3);
                        });

            recoverability.Delayed(
                delayed =>
                {
                    delayed.NumberOfRetries(2);
                    delayed.TimeIncrease(TimeSpan.FromMinutes(5));
                });

            logger.LogInformation(1, $"Started Endpoint {EndpointName} on FCS.Worker");

            configuration.Conventions()
                .DefiningCommandsAs(t => t.Namespace != null && t.Namespace.EndsWith("Commands"))
                .DefiningEventsAs(t => t.Namespace != null && t.Namespace.EndsWith("Events"))
                .DefiningMessagesAs(t => t.Namespace != null && t.Namespace.EndsWith("Messages"));

            configuration.UseContainer<WindsorBuilder>(customizations: customizations =>
            {
                customizations.ExistingContainer(new WindsorContainer().Install(new WindsorInstaller(loggerFactory)));
            });

            return configuration;
        }
    }
}
