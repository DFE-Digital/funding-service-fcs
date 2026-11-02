namespace ContractManagementDomain.Endpoint.DeleteContract
{
    using System.Collections.Generic;
    using System.Linq;
    using Castle.Windsor;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class EndpointConfig : IEndpointConfig
    {
        public string NameOfAssembly => "ContractManagementDomain.Endpoint.dll";

        public string EndpointName => "ContractManagement.DeleteContract";

        private static readonly IReadOnlyCollection<string> EventsUsedInThisEndpoint = new[]
        {
            nameof(DraftContractDeletedEvent)
        };

        public IReadOnlyCollection<Subscription> Subscriptions => new List<Subscription>();

        public IReadOnlyCollection<CommandRoute> Routes => new List<CommandRoute>
        {
            new CommandRoute(EndpointName, typeof(DeleteDocumentsForContractCommand)),
            new CommandRoute(EndpointName, typeof(DeleteContractCommand)),
            new CommandRoute(EndpointName, typeof(DeleteMasterContractsCommand)),
            new CommandRoute("ContractManagementDomain.IssueNotification.Xrm", typeof(IssueCrmNotificationCommand))
        };

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            EndpointConfiguration configuration = new EndpointConfiguration(EndpointName);

            var logger = loggerFactory.CreateDefaultLogger();

            logger.LogInformation(1, $"Started Endpoint {EndpointName} on FCS.Worker");

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