namespace FundingAllocation.Endpoints.CheckForReadComplete
{
    using System.Collections.Generic;
    using System.Linq;
    using Castle.Windsor;
    using Castle.Windsor.MsDependencyInjection;
    using Microsoft.Extensions.Configuration;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class EndpointConfig : IEndpointCoreConfig
    {
        public string NameOfAssembly => "FundingAllocation.dll";

        public string EndpointName => "FundingAllocation.CheckForReadComplete";

        public IReadOnlyCollection<Subscription> Subscriptions => new List<Subscription>();

        public IReadOnlyCollection<CommandRoute> Routes => new List<CommandRoute>
        {
            new CommandRoute("ContractCreateDomain.CreateProvidersIfNecessary", typeof(CreateProvidersIfNecessaryCommand)),
            new CommandRoute("FundingAllocation.CheckForJobComplete", typeof(CheckForJobCompleteCommand))
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
