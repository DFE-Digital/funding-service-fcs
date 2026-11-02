namespace SFA.FCT.DocumentsDomain.Integration.DocumentGenerationEndpoint.DocumentSaverEndpoint
{
    using System.Collections.Generic;
    using System.Linq;
    using Castle.Windsor;
    using FCS.Worker.Common;
    using Framework.Logging.Interfaces;
    using IoC;
    using NServiceBus;

    public class DocumentSaverEndpointConfig : IEndpointConfig
    {
        public string NameOfAssembly => "DocumentsDomain.Integration.DocumentGenerationEndpoint.dll";

        public string EndpointName => "DocumentsDomain.SaveDocument";

        public IReadOnlyCollection<CommandRoute> Routes => Enumerable.Empty<CommandRoute>().ToList();

        public IReadOnlyCollection<Subscription> Subscriptions => Enumerable.Empty<Subscription>().ToList();

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            EndpointConfiguration configuration = new EndpointConfiguration(EndpointName);

            ILogger logger = loggerFactory.CreateDefaultLogger();

            logger.LogInformation(1, $"Started Endpoint {EndpointName} on CrossDomain.Integration");

            configuration.Conventions()
                .DefiningCommandsAs(t => t.Namespace != null && t.Namespace.EndsWith("Commands"))
                .DefiningEventsAs(t => null != t.Namespace && t.Namespace.EndsWith("Events"))
                .DefiningMessagesAs(t => null != t.Namespace && t.Namespace.EndsWith("Messages"));

            configuration.UseContainer<WindsorBuilder>(customizations: customizations =>
            {
                customizations.ExistingContainer(new WindsorContainer().Install(new WindsorInstallerForDocumentSaver(loggerFactory)));
            });

            return configuration;
        }
    }
}
