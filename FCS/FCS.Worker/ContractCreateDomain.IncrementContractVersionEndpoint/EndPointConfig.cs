namespace ContractCreateDomain.IncrementContractVersionEndpoint
{
    using System.Collections.Generic;
    using System.Linq;
    using Castle.Windsor;
    using IoC;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Commands;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Messages;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.Messages;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class EndPointConfig : IEndpointConfig
    {
        public string NameOfAssembly => "ContractCreateDomain.IncrementContractVersionEndpoint.dll";

        public string EndpointName => "ContractCreateDomain.IncrementContractVersion";

        public IReadOnlyCollection<Subscription> Subscriptions => new List<Subscription>();

        public IReadOnlyCollection<CommandRoute> Routes => new[]
        {
            new CommandRoute("ContractCreateDomain.XrmService", typeof(AmendContractCommand)),
            new CommandRoute("DocumentsDomain.GenerateDocument", typeof(DocumentGenerationCommand))
        };

        private static readonly IReadOnlyCollection<string> RelevantCommands = new List<string>
        {
            nameof(IncrementContractVersionCommand),
            nameof(DocumentGenerationComplete),
            nameof(AmendContractUnsuccessful),
            nameof(ContractAmended),
            nameof(AmendContractCommand),
            nameof(DocumentGenerationCommand),
        };

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            EndpointConfiguration configuration = new EndpointConfiguration(EndpointName);

            ILogger logger = loggerFactory.CreateDefaultLogger();

            logger.LogInformation(1, $"Started Endpoint {EndpointName} on FCS.Worker");

            configuration.Conventions()
                .DefiningCommandsAs(t => t.Namespace != null && t.Namespace.EndsWith("Commands"))
                .DefiningCommandsAs(t => RelevantCommands.Any(c => t.Name.EndsWith(c)));

            configuration.UseContainer<WindsorBuilder>(customizations: customizations =>
            {
                customizations.ExistingContainer(new WindsorContainer().Install(new WindsorInstaller(loggerFactory)));
            });

            return configuration;
        }
    }
}