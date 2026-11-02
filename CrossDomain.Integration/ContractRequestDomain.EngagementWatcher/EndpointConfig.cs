namespace ContractRequestDomain.EngagementWatcher
{
    using Castle.Windsor;
    using NServiceBus;
    using SFA.FCT.Framework.Logging.Interfaces;
    using System.Collections.Generic;
    using System.Linq;
    using IoC;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.ContractRequestDomain.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Events;

    public class EndpointConfig : IEndpointConfig
    {
        public string EndpointName => "ContractRequestDomain.EngagementWatcher";

        public string NameOfAssembly => "ContractRequestDomain.EngagementWatcher.dll";

        public IReadOnlyCollection<Subscription> Subscriptions => new List<Subscription>
        {
            new Subscription("ContractCreateDomain.CreateContract", typeof(DasContractRequestProviderNotFoundEvent)),
            new Subscription("ContractCreateDomain.CreateContract", typeof(DasContractRequestRejectedEvent)),
            new Subscription("ContractCreateDomain.CreateContractInternal", typeof(DasContractRequestCreatedEvent))
        };

        public IReadOnlyCollection<CommandRoute> Routes => new List<CommandRoute>
        {
            new CommandRoute("ContractRequestDomain.BulkUpload", typeof(NewDasContractRequestCommand)),
            new CommandRoute(EndpointName, typeof(InitiateEngagementPollingCommand)),
        };

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            EndpointConfiguration configuration = new EndpointConfiguration(EndpointName);

            var logger = loggerFactory.CreateDefaultLogger();

            logger.LogInformation(1, $"Started Endpoint {EndpointName} on CDI");

            configuration.Conventions()
                .DefiningCommandsAs(t => t.Namespace != null && t.Namespace.EndsWith("Commands"))
                .DefiningMessagesAs(t => t.Namespace != null && t.Namespace.EndsWith("Messages"))
                .DefiningEventsAs(t => Subscriptions.Select(s => s.EventType.Name).Any(e => t.Name.EndsWith(e)));

            configuration.UseContainer<WindsorBuilder>(customizations: customizations =>
            {
                customizations.ExistingContainer(new WindsorContainer().Install(new WindsorInstaller(loggerFactory)));
            });

            return configuration;
        }
    }
}