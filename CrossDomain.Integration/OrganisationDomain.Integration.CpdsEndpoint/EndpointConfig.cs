namespace OrganisationDomain.Integration.CpdsEndpoint
{
    using NServiceBus;
    using Ioc;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCS.Worker.Common;
    using System.Collections.Generic;
    using System.Linq;
    using Castle.Windsor;
    using Messages.Commands;

    public class EndpointConfig : IEndpointConfig
    {
        public string NameOfAssembly => "OrganisationDomain.Integration.CpdsEndpoint.dll";

        public string EndpointName => "OrgService.CPDS";

        public IReadOnlyCollection<Subscription> Subscriptions => new List<Subscription>();

        public IReadOnlyCollection<CommandRoute> Routes => new List<CommandRoute>
        {
            new CommandRoute("OrgService.Main", typeof(ProcessProviderSummary)),
            new CommandRoute("OrgService.Main", typeof(ProcessOrganisationDetails))
        };

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            EndpointConfiguration configuration = new EndpointConfiguration(EndpointName);

            var logger = loggerFactory.CreateDefaultLogger();

            logger.LogInformation(1, $"Started Endpoint {EndpointName} on CrossDomain.Integration");

            configuration.Conventions()
                .DefiningCommandsAs(t => t.Namespace != null && t.Namespace.EndsWith("Commands"))
                .DefiningEventsAs(t => Subscriptions.Select(s => s.EventType.Name).Any(e => t.Name.EndsWith(e)));

            configuration.UseContainer<WindsorBuilder>(customizations: customizations =>
            {
                customizations.ExistingContainer(new WindsorContainer().Install(new ComponentInstaller(loggerFactory)));
            });

            return configuration;
        }
    }
}
