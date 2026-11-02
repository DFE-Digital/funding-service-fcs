namespace OrganisationDomain.Integration.DataStoreEndpoint
{
    using System.Collections.Generic;
    using Castle.Windsor;
    using Messages.Commands;
    using NServiceBus;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCS.Worker.Common;
    using Ioc;

    /*
        This class configures this endpoint as a Server. More information about how to configure the NServiceBus host
        can be found here: http://particular.net/articles/the-nservicebus-host
    */
    public class EndpointConfig : IEndpointConfig
    {
        public string NameOfAssembly => "OrganisationDomain.Integration.DataStoreEndpoint.dll";

        public string EndpointName => "OrgService.DataStore";

        public IReadOnlyCollection<Subscription> Subscriptions => new List<Subscription>();

        public IReadOnlyCollection<CommandRoute> Routes => new List<CommandRoute>
        {
            new CommandRoute("OrgService.Main", typeof(ProcessUpdatedOrganisations)),
            new CommandRoute("OrgService.Main", typeof(ProcessSavedOrganisation)),
            new CommandRoute("OrgService.XrmEndpoint", typeof(CreateProviderUpdatedNotificationCommand))
        };

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            EndpointConfiguration configuration = new EndpointConfiguration(EndpointName);

            var logger = loggerFactory.CreateDefaultLogger();

            logger.LogInformation(1, $"Started Endpoint {EndpointName} on CrossDomain.Integration");

            configuration.Conventions()
                .DefiningCommandsAs(t => t.Namespace != null && t.Namespace.EndsWith("Commands")
                                         || t.Name.EndsWith(nameof(SaveUpdatedOrganisation))
                                         || t.Name.EndsWith(nameof(GetUpdatedOrganisations)));

            configuration.UseContainer<WindsorBuilder>(customizations: customizations =>
            {
                customizations.ExistingContainer(new WindsorContainer().Install(new ComponentInstaller(loggerFactory)));
            });

            return configuration;
        }
    }
}
