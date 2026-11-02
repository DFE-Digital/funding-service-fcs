namespace FundingAllocation.Endpoints.DraftContractDeleted
{
    using System.Linq;
    using Microsoft.Extensions.Configuration;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.Framework.Logging.Interfaces;
    using System.Collections.Generic;
    using Castle.Windsor;
    using Castle.Windsor.MsDependencyInjection;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;

    public class EndpointConfig : IEndpointCoreConfig
    {
        public string NameOfAssembly => "FundingAllocation.dll";

        public string EndpointName => "FundingAllocation.DraftContractDeleted";

        // this is actually wired up via the FctConsole 
        public IReadOnlyCollection<Subscription> Subscriptions => new List<Subscription>
        {
            new Subscription("contractmanagement.deletecontract", typeof(DraftContractDeletedEvent))
        };

        public IReadOnlyCollection<CommandRoute> Routes => new List<CommandRoute>
        {
            new CommandRoute("FundingAllocation.UpdateFundingAllocation",
                typeof(ReturnToSchedulingFundingAllocationCommand)),
            new CommandRoute("FundingAllocation.ReleaseGroup",
                typeof(ReleaseQueuedFundingAllocationsForContractsCommand))
        };

        public EndpointConfiguration GetEndpointConfiguration(ILogger logger, IConfigurationRoot appConfiguration)
        {
            EndpointConfiguration configuration = new EndpointConfiguration(EndpointName);

            logger.LogInformation(1, $"Started Endpoint {EndpointName} on FundingAllocation");

            configuration.Conventions()
                .DefiningCommandsAs(t => t.Namespace != null && t.Namespace.EndsWith("Commands"))
                .DefiningEventsAs(t => Subscriptions.Select(s => s.EventType.Name).Any(eventName => t.Name.EndsWith(eventName)));

            ContainerSettings<IWindsorContainer> containerSettings = configuration.UseContainer(new WindsorServiceProviderFactory());
            containerSettings.ConfigureContainer(c => c.Install(new WindsorInstaller(logger, appConfiguration)));

            Subscriptions.ToList().ForEach(s => configuration.AutoSubscribe().DisableFor(s.EventType));

            return configuration;
        }
    }
}