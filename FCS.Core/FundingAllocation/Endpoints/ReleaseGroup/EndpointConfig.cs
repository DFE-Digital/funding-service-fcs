namespace FundingAllocation.Endpoints.ReleaseGroup
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Castle.Windsor;
    using Castle.Windsor.MsDependencyInjection;
    using Microsoft.Extensions.Configuration;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class EndpointConfig : IEndpointCoreConfig
    {
        public static string Name => "FundingAllocation.ReleaseGroup";

        public string NameOfAssembly => "FundingAllocation.dll";

        public string EndpointName => Name;

        public IReadOnlyCollection<Subscription> Subscriptions => new List<Subscription>();

        public IReadOnlyCollection<CommandRoute> Routes => new List<CommandRoute>
        {
            new CommandRoute("ContractCreateDomain.EnrichForDocumentation", typeof(EnrichContractForDocumentationCommand)),
            new CommandRoute("ContractCreateDomain.UpdateContract", typeof(UpdateContractFromFundingCommand)),
            new CommandRoute("FundingAllocation.ReleaseGroupSetToReleased", typeof(CheckReleaseGroupsCanBeReleasedCommand))
        };

        private static readonly IReadOnlyCollection<Type> MessagesPublishedFromThisEndpoint =
            new List<Type>
            {
                typeof(FundingAllocationReleaseInProgressEvent)
            };

        public EndpointConfiguration GetEndpointConfiguration(ILogger logger, IConfigurationRoot appConfiguration)
        {
            EndpointConfiguration configuration = new EndpointConfiguration(EndpointName);

            logger.LogInformation(1, $"Started Endpoint {EndpointName} on FundingAllocation");

            configuration.Conventions()
                .DefiningCommandsAs(t => t.Namespace != null && t.Namespace.EndsWith("Commands"))
                .DefiningEventsAs(t => MessagesPublishedFromThisEndpoint.Select(t => t.Name).Any(eventName => t.Name.EndsWith(eventName)));

            ContainerSettings<IWindsorContainer> containerSettings = configuration.UseContainer(new WindsorServiceProviderFactory());
            containerSettings.ConfigureContainer(c => c.Install(new WindsorInstaller(logger, appConfiguration)));

            return configuration;
        }
    }
}
