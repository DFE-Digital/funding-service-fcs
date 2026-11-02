namespace SFA.FCT.ContractManagementDomain.Integration.PublishContractWithdrawalEndpoint
{
    using System.Collections.Generic;
    using System.Linq;
    using Castle.Windsor;
    using ContractManagementService.Common.Commands;
    using CrossDomain.Integration.Events;
    using FCS.Worker.Common;
    using Framework.Logging.Interfaces;
    using IoC;
    using NServiceBus;

    public class EndpointConfig : IEndpointConfig
    {
        private static readonly IReadOnlyCollection<string> EventsUsedInThisEndpoint = new List<string>
        {
            nameof(ContractWithdrawnEvent)
        };

        public string NameOfAssembly => "ContractManagementDomain.Integration.dll";

        public string EndpointName => "ContractManagementDomain.PublishContractWithdrawal";

        public IReadOnlyCollection<Subscription> Subscriptions => new List<Subscription>
        {
            new Subscription("ContractManagementDomain.InitiateContractWithdrawal", typeof(ContractWithdrawnEvent))
        };

        public IReadOnlyCollection<CommandRoute> Routes => new List<CommandRoute>
        {
            new CommandRoute("ContractCreateDomain.IncrementContractVersion", typeof(IncrementContractVersionCommand))
        };

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            EndpointConfiguration configuration = new EndpointConfiguration(EndpointName);

            var logger = loggerFactory.CreateDefaultLogger();

            logger.LogInformation(1, $"Started Endpoint {EndpointName} on CDI");

            configuration.Conventions()
                .DefiningCommandsAs(t => t.Namespace != null && t.Namespace.EndsWith("Commands"))
                .DefiningEventsAs(t => EventsUsedInThisEndpoint.Any(e => t.Name.EndsWith(e)));

            configuration.UseContainer<WindsorBuilder>(customizations: customizations =>
            {
                customizations.ExistingContainer(new WindsorContainer().Install(new WindsorInstaller(loggerFactory)));
            });

            return configuration;
        }
    }
}
