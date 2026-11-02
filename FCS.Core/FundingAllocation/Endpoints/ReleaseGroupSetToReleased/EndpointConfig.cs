namespace FundingAllocation.Endpoints.ReleaseGroupSetToReleased
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Castle.Windsor;
    using Castle.Windsor.MsDependencyInjection;
    using Microsoft.Extensions.Configuration;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.CrossDomain.Integration.Events;

    public class EndpointConfig : IEndpointCoreConfig
    {
        public string NameOfAssembly => "FundingAllocation.dll";

        public string EndpointName => "FundingAllocation.ReleaseGroupSetToReleased";

        public IReadOnlyCollection<Subscription> Subscriptions => new List<Subscription>();

        public IReadOnlyCollection<CommandRoute> Routes => new List<CommandRoute>();

        private static readonly IReadOnlyCollection<Type> MessagesPublishedFromThisEndpoint =
            new List<Type>
            {
                typeof(FundingAllocationReleaseGroupGroupReleasedEvent)
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

            Subscriptions.ToList().ForEach(s => configuration.AutoSubscribe().DisableFor(s.EventType));

            return configuration;
        }
    }
}