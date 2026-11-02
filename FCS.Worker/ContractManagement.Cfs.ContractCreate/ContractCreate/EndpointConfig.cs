namespace ContractManagement.Cfs.ContractCreate
{
    using System.Collections.Generic;
    using Castle.Windsor;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Messages;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.Messages;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class EndpointConfig : IEndpointConfig
    {
        public string NameOfAssembly => "ContractManagement.Cfs.dll";

        public string EndpointName => "ContractManagement.Cfs.CreateContract";

        public IReadOnlyCollection<Subscription> Subscriptions { get; } = new List<Subscription>();

        public IReadOnlyCollection<CommandRoute> Routes { get; } = new List<CommandRoute>
        {
            new CommandRoute("ContractCreateDomain.XrmService", typeof(CreateContractCommand))
        };

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            EndpointConfiguration configuration = new EndpointConfiguration(EndpointName);

            var logger = loggerFactory.CreateDefaultLogger();

            logger.LogInformation(1, $"Started Endpoint {EndpointName} on FCS.Worker");

            configuration.Conventions()
                .DefiningCommandsAs(t => t.Namespace != null && t.Namespace.EndsWith("Commands")
                    || t.Name.EndsWith(nameof(DocumentGenerationComplete))
                    || t.Name.EndsWith(nameof(NewContractCreated)));

            configuration.UseContainer<WindsorBuilder>(customizations: customizations =>
            {
                customizations.ExistingContainer(new WindsorContainer().Install(new WindsorInstaller(loggerFactory)));
            });

            return configuration;
        }
    }
}
