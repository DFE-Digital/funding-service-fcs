namespace ContractManagementDomain.Termination.Xrm
{
    using System.Collections.Generic;
    using System.Linq;
    using Castle.Windsor;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class EndpointConfig : IEndpointConfig
    {
        private static readonly IReadOnlyCollection<string> EventsUsedInThisEndpoint = new List<string>
        {
            nameof(ContractTerminationCancelledEvent),
            nameof(ContractTerminatedEvent),
            nameof(ContractTerminationFailedEvent)
        };

        public string NameOfAssembly => "ContractManagementDomain.Termination.Xrm.dll";
        public string EndpointName => "ContractManagement.ContractTermination.Xrm";
        public IReadOnlyCollection<Subscription> Subscriptions => new List<Subscription>
        {
            new Subscription("ContractManagement.ContractTermination", typeof(ContractTerminationCancelledEvent)),
            new Subscription("ContractManagement.ContractTermination", typeof(ContractTerminatedEvent)),
            new Subscription("ContractManagement.ContractTermination", typeof(ContractTerminationFailedEvent))
        };

        public IReadOnlyCollection<CommandRoute> Routes => new List<CommandRoute>
        {
            new CommandRoute("ContractManagementDomain.IssueNotification.Xrm", typeof(IssueCrmNotificationCommand))
        };

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            EndpointConfiguration configuration = new EndpointConfiguration(EndpointName);

            var logger = new Logger(new System.Diagnostics.TraceSource("WorkerRole"));

            logger.LogInformation(1, $"Started Endpoint {EndpointName} on FCS.Worker");

            configuration.Conventions()
                .DefiningCommandsAs(t => (t.Namespace != null && t.Namespace.EndsWith("Commands")) || t.GetInterfaces().Contains(typeof(ICommand)))
                .DefiningEventsAs(t => EventsUsedInThisEndpoint.Any(e => t.Name.EndsWith(e)));

            configuration.UseContainer<WindsorBuilder>(customizations: customizations =>
            {
                customizations.ExistingContainer(new WindsorContainer().Install(new WindsorInstaller(loggerFactory)));
            });

            return configuration;
        }
    }
}
