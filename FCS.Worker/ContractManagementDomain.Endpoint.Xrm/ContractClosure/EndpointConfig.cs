namespace ContractManagementDomain.Endpoint.Xrm.ContractClosure
{
    using System.Collections.Generic;
    using System.Linq;
    using Castle.Windsor;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class EndpointConfig : IEndpointConfig
    {
        public string NameOfAssembly => "ContractManagementDomain.Endpoint.Xrm.dll";

        public string EndpointName => "ContractManagementDomain.ContractClosure.Xrm";

        private static readonly IReadOnlyCollection<string> EventsUsedInThisEndpoint = new[]
        {
            nameof(ContractClosedEvent)
        };

        public IReadOnlyCollection<Subscription> Subscriptions => new []
        {
            new Subscription("ContractManagementDomain.ContractClosure", typeof(ContractClosedEvent)) 
        };

        public IReadOnlyCollection<CommandRoute> Routes => Enumerable.Empty<CommandRoute>().ToArray();

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
