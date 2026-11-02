namespace ContractManagementDomain.Integration
{
    using Castle.Windsor;
    using IoC;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class EndpointConfig : IConfigureThisEndpoint, AsA_FctEndpoint
    {
        private const string EndpointName = "ContractManagementDomain.Integration";

        public void Customize(BusConfiguration configuration)
        {
            ILoggerFactory factory = new LoggerFactory();
            Customize(configuration, factory);
        }

        public void Customize(BusConfiguration configuration, ILoggerFactory loggerFactory)
        {
            configuration.EndpointName(EndpointName);

            configuration.UseSerialization<JsonSerializer>();
            configuration.UsePersistence<NHibernatePersistence>();
            configuration.UseDataBus<AzureDataBus>();
            IWindsorContainer iwcContainer = new WindsorContainer().Install(new WindsorInstaller(loggerFactory));
            configuration.UseContainer<WindsorBuilder>(c => c.ExistingContainer(iwcContainer));
        }
    }
}
