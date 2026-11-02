namespace SFA.FCT.DocumentsDomain.Integration.DocumentGenerationEndpoint
{
    using System.Collections.Generic;
    using System.Linq;
    using Castle.Windsor;
    using Common.Commands;
    using DocumentGeneration.IoC;
    using FCS.Worker.Common;
    using NServiceBus;
    using Framework.Logging.Interfaces;
    using WindsorInstallerForDocumentGenerator = IoC.WindsorInstallerForDocumentGenerator;

    public class DocumentGenerationEndpointConfig : IEndpointConfig
    {
        public string NameOfAssembly => "DocumentsDomain.Integration.DocumentGenerationEndpoint.dll";

        public string EndpointName => "DocumentsDomain.GenerateDocument";

        public IReadOnlyCollection<CommandRoute> Routes => new[]
        {
            new CommandRoute("DocumentsDomain.SaveDocument", typeof(DocumentSaveCommand))
        };

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
                customizations.ExistingContainer(new WindsorContainer().Install(new WindsorInstallerForDocumentGenerator(loggerFactory)));
            });

            return configuration;
        }
    }
}
