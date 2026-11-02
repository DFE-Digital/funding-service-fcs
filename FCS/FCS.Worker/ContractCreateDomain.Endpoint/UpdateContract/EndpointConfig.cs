namespace ContractCreateDomain.Endpoint.UpdateContract
{
    using System.Collections.Generic;
    using Castle.Windsor;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class EndpointConfig : IEndpointConfig
    {
        public string NameOfAssembly => "ContractCreateDomain.Endpoint.dll";
        public string EndpointName => "ContractCreateDomain.UpdateContract";

        public IReadOnlyCollection<Subscription> Subscriptions => new List<Subscription>();

        public IReadOnlyCollection<CommandRoute> Routes => new List<CommandRoute>
        {
            new CommandRoute("DocumentsDomain.GenerateDocument", typeof(DocumentGenerationCommand)),
            new CommandRoute("ContractRequestDomain.BulkUpload", typeof(ContractRequestProcessedCommand)),
            new CommandRoute("ContractCreateDomain.XrmService", typeof(UpdateContractCommand)),
            new CommandRoute("ContractCreateDomain.EnrichForDocumentation", typeof(EnrichContractForDocumentationCommand))
        };

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            EndpointConfiguration configuration = new EndpointConfiguration(EndpointName);

            var logger = loggerFactory.CreateDefaultLogger();

            logger.LogInformation(1, $"Started Endpoint {EndpointName} on FCS.Worker");

            configuration.Conventions()
                .DefiningCommandsAs(t => t.Namespace != null && t.Namespace.EndsWith("Commands"))
                .DefiningMessagesAs(t => t.Namespace != null && t.Namespace.EndsWith("Messages"));

            configuration.UseContainer<WindsorBuilder>(customizations: customizations =>
            {
                customizations.ExistingContainer(new WindsorContainer().Install(new WindsorInstallerForSagas(loggerFactory)));
            });

            return configuration;
        }
    }
}
