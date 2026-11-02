namespace FundingAllocation.Endpoints.DocumentGenerationComplete
{
    using System.Collections.Generic;
    using Castle.Windsor;
    using Castle.Windsor.MsDependencyInjection;
    using Microsoft.Extensions.Configuration;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class EndpointConfig : IEndpointCoreConfig
    {
        public string NameOfAssembly => "FundingAllocation.dll";

        public string EndpointName => "FundingAllocation.DocumentGenerationComplete";

        public IReadOnlyCollection<Subscription> Subscriptions => new List<Subscription>();

        public IReadOnlyCollection<CommandRoute> Routes => new List<CommandRoute>
        {
            new CommandRoute("ContractCreateDomain.XrmService", typeof(CreateContractCommand)),
            new CommandRoute("ContractCreateDomain.XrmService", typeof(UpdateContractCommand)),
            new CommandRoute("ContractCreateDomain.XrmService", typeof(CreateNewAmendedContractCommand)),
            new CommandRoute("ContractCreateDomain.XrmService", typeof(AmendContractCommand)),
            new CommandRoute("FundingAllocation.ReleaseGroupSetToReleased", typeof(CheckReleaseGroupsCanBeReleasedCommand)),
        };

        public EndpointConfiguration GetEndpointConfiguration(ILogger logger, IConfigurationRoot appConfiguration)
        {
            EndpointConfiguration configuration = new EndpointConfiguration(EndpointName);

            logger.LogInformation(1, $"Started Endpoint {EndpointName} on FundingAllocation");

            configuration.Conventions()
                .DefiningCommandsAs(t => t.Namespace != null && (t.Namespace.EndsWith("Commands") || t.Namespace.EndsWith("Messages")))
                .DefiningEventsAs(t => t.Namespace != null && t.Name.EndsWith("Events"));

            ContainerSettings<IWindsorContainer> containerSettings = configuration.UseContainer(new WindsorServiceProviderFactory());
            containerSettings.ConfigureContainer(c => c.Install(new WindsorInstaller(logger, appConfiguration)));

            return configuration;
        }
    }
}
