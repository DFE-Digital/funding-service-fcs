namespace FundingAllocation.Endpoints.CreateFundingAllocationInCrm
{
    using System.Collections.Generic;
    using System.Linq;
    using Castle.Windsor;
    using Castle.Windsor.MsDependencyInjection;
    using Microsoft.Extensions.Configuration;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class EndpointConfig : IEndpointCoreConfig
    {
        public static string Name => "FundingAllocation.CreateFundingAllocationInCrm";

        public string NameOfAssembly => "FundingAllocation.dll";

        public string EndpointName => Name;

        public IReadOnlyCollection<Subscription> Subscriptions => Enumerable.Empty<Subscription>().ToArray();

        public IReadOnlyCollection<CommandRoute> Routes => new List<CommandRoute>
        {
            new CommandRoute("FundingAllocation.UpdateFundingAllocation", typeof(UpdateFundingAllocationWithReleaseGroupCommand)),
            new CommandRoute("FundingAllocation.CheckForJobComplete", typeof(CheckForJobCompleteCommand))
        };
        
        public EndpointConfiguration GetEndpointConfiguration(ILogger logger, IConfigurationRoot appConfiguration)
        {
            EndpointConfiguration configuration = new EndpointConfiguration(EndpointName);

            logger.LogInformation(1, $"Started Endpoint {EndpointName} on FundingAllocation");

            configuration.Conventions()
                .DefiningCommandsAs(t => t.Namespace != null && t.Namespace.EndsWith("Commands"))
                .DefiningEventsAs(t => t.Namespace != null && t.Name.EndsWith("Events"));

            ContainerSettings<IWindsorContainer> containerSettings = configuration.UseContainer(new WindsorServiceProviderFactory());
            containerSettings.ConfigureContainer(c => c.Install(new WindsorInstaller(logger, appConfiguration)));

            return configuration;
        }
    }
}
