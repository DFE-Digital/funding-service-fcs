namespace DocumentsDomain.Endpoint.Xrm
{
    using System.Collections.Generic;
    using System.Linq;
    using Castle.Windsor;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.DocumentsDomain.Common.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class EndpointConfig : IEndpointConfig
    {
        public string NameOfAssembly => "DocumentsDomain.Endpoint.dll";

        public string EndpointName => "DocumentsDomain.XrmHandler";

        private static readonly IReadOnlyCollection<string> EventsUsedInThisEndpoint = new List<string>
        {
            nameof(ContractReadyToPublishEvent),
            nameof(ContractNotificationPublishedToProviderEvent)
        };

        public IReadOnlyCollection<Subscription> Subscriptions => new[]
        {
            new Subscription("ContractManagementDomain.ConfirmPublicationToProvider", typeof(ContractReadyToPublishEvent)),
        };

        public IReadOnlyCollection<CommandRoute> Routes => new[]
        {
            new CommandRoute("DocumentsDomain.DeleteDocument", typeof(GetDocumentsForDeleteCommand)), 
        };

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            EndpointConfiguration configuration = new EndpointConfiguration(EndpointName);

            var logger = loggerFactory.CreateDefaultLogger();

            logger.LogInformation(1, $"Started Endpoint {EndpointName} on FCS.Worker");

            configuration.Conventions()
                .DefiningCommandsAs(t => t.Namespace != null && t.Namespace.EndsWith("Commands"))
                .DefiningEventsAs(t => EventsUsedInThisEndpoint.Any(e => t.Name.EndsWith(e)));

            configuration.UseContainer<WindsorBuilder>(customizations: customizations =>
            {
                customizations.ExistingContainer(new WindsorContainer().Install(new WindsorInstaller(loggerFactory)));
            });

            return configuration;
        }
    }
}
