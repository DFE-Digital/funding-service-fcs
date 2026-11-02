namespace ContractCreateDomain.Endpoint.CreateContractInternal
{
    using System.Collections.Generic;
    using System.Linq;
    using Castle.Windsor;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class EndpointConfig : IEndpointConfig
    {
        private static readonly IReadOnlyCollection<string> EventsUsedInThisEndpoint = new List<string>
        {
            nameof(DasContractRequestProviderNotFoundEvent),
            nameof(DasContractRequestRejectedEvent),
            nameof(DasContractRequestCreatedEvent)
        };

        public string NameOfAssembly => "ContractCreateDomain.Endpoint.dll";
        public string EndpointName => "ContractCreateDomain.CreateContractInternal";
        public IReadOnlyCollection<Subscription> Subscriptions => new List<Subscription>();

        public IReadOnlyCollection<CommandRoute> Routes => new List<CommandRoute>
        {
            new CommandRoute("ContractCreateDomain.XrmService", typeof(CreateContractCommand)),
            new CommandRoute("ContractCreateDomain.XrmService", typeof(CreateNewAmendedContractCommand)),
            new CommandRoute("ContractCreateDomain.XrmService", typeof(UpdateContractCommand)),
            new CommandRoute("ContractCreateDomain.XrmService", typeof(AmendContractCommand)),
            new CommandRoute("DocumentsDomain.GenerateDocument", typeof(DocumentGenerationCommand)), // todo: this can be removed
            new CommandRoute("ContractRequestDomain.BulkUpload", typeof(ContractRequestProcessedCommand))
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
