namespace OrganisationDomain.Web
{
    using System;
    using System.Configuration;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Common.MessageMutators;

    public static class ServiceBus
    {
        public static IBus Bus { get; set; }

        public static void Init()
        {
            var configuration = new BusConfiguration();

            configuration.EndpointName(FctEndpoint.GenerateEndpointName("OrgService.Web"));
            //// TODO: disable installers and replace transport for production
            configuration.EnableInstallers();

            configuration.UseTransport<AzureServiceBusTransport>();

            configuration.UsePersistence<InMemoryPersistence>();
            configuration.UseSerialization<JsonSerializer>();

            configuration.Conventions()
                .DefiningCommandsAs(t => null != t.Namespace && t.Namespace.StartsWith("OrganisationDomain.Integration.Messages.Commands"))
                .DefiningMessagesAs(t => null != t.Namespace && t.Namespace.StartsWith("OrganisationDomain.Integration.Messages.Messages"))
                .DefiningEventsAs(t => null != t.Namespace && t.Namespace.StartsWith("OrganisationDomain.Integration.Messages.Events"))
                .DefiningTimeToBeReceivedAs(t => (null != t.Namespace && t.Namespace.StartsWith("OrganisationDomain.Integration.Messages.Messages.Expires") 
                    ? TimeSpan.FromSeconds(double.Parse(ConfigurationManager.AppSettings["GetOrgAsyncWaitTimeInSeconds"])) 
                    : TimeSpan.MaxValue));
            configuration.CustomConfigurationSource(new CustomConfigurationSource());

            configuration.RegisterComponents(components =>
            {
                components.ConfigureComponent<TransportMessageCompressionMutator>(DependencyLifecycle.SingleInstance);
            });

            Bus = NServiceBus.Bus.Create(configuration).Start();
        }
    }
}