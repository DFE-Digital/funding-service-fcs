namespace ContractCreateDomain.Endpoint.CreateContract
{
    using System.Collections.Generic;
    using System.Linq;
    using Castle.Windsor;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class EndpointConfig : IEndpointConfig
    {
        private static readonly IReadOnlyCollection<string> EventsUsedInThisEndpoint = new List<string>
        {
            nameof(DasContractRequestProviderNotFoundEvent),
            nameof(DasContractRequestRejectedEvent)
        };

        public string NameOfAssembly => "ContractCreateDomain.Endpoint.dll";
        public string EndpointName => "ContractCreateDomain.CreateContract";

        public IReadOnlyCollection<Subscription> Subscriptions => new List<Subscription>();

        public IReadOnlyCollection<CommandRoute> Routes => new List<CommandRoute>
        {
            new CommandRoute("DocumentsDomain.GenerateDocument", typeof(DocumentGenerationCommand)),
            new CommandRoute("ContractRequestDomain.BulkUpload", typeof(ContractRequestProcessedCommand)),
            new CommandRoute("ContractCreateDomain.XrmService", typeof(CreateContractCommand))
        };

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            EndpointConfiguration configuration = new EndpointConfiguration(EndpointName);

            var logger = loggerFactory.CreateDefaultLogger();

            logger.LogInformation(1, $"Started Endpoint {EndpointName} on FCS.Worker");

            configuration.Conventions()
                .DefiningCommandsAs(t => t.Namespace != null && t.Namespace.EndsWith("Commands"))
                .DefiningMessagesAs(t => t.Namespace != null && t.Namespace.EndsWith("Messages"))
                .DefiningEventsAs(t => EventsUsedInThisEndpoint.Any(e => t.Name.EndsWith(e)));

            configuration.UseContainer<WindsorBuilder>(customizations: customizations =>
            {
                customizations.ExistingContainer(new WindsorContainer().Install(new WindsorInstallerForSagas(loggerFactory)));
            });

            return configuration;
        }
    }
}
