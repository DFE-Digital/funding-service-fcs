namespace SFA.FCT.PMD.Integration.EvidenceEndpoint.AllocationActualsVerified
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using NServiceBus;
    using CrossDomain.Integration.Common;
    using Framework.Logging;
    using Framework.Logging.Interfaces;
    using Ioc;
    using SFA.FCT.CrossDomain.Integration.Events;
    using NServiceBus.Config;

    /*
        This class configures this endpoint as a Server. More information about how to configure the NServiceBus host
        can be found here: http://particular.net/articles/the-nservicebus-host
    */

    public class EndpointConfig : AsA_FctEndpoint, IConfigureThisEndpoint
    {
        public static string EndpointName
        {
            get { return FctEndpoint.GenerateEndpointName("PaymentManagement.AllocationActualsVerified"); }
        }

        public void Customize(BusConfiguration configuration)
        {
            ILoggerFactory factory = new LoggerFactory();
            Customize(configuration, factory);
        }

        public void Customize(BusConfiguration configuration, ILoggerFactory loggerFactory)
        {
            configuration.UsePersistence<InMemoryPersistence>();

            configuration.EndpointName(EndpointName);
            configuration.UseDataBus<AzureDataBus>();
            configuration.UseTransport<AzureServiceBusTransport>();
            configuration.Conventions()
                .DefiningEventsAs(t => null != t.Namespace && t.Namespace.EndsWith("Events"))
                .DefiningCommandsAs(t => null != t.Namespace && t.Namespace.EndsWith("Commands"))
                .DefiningMessagesAs(t => null != t.Namespace && t.Namespace.EndsWith("Messages"))
                .DefiningDataBusPropertiesAs(t => t.Name.EndsWith("Databus"));

            configuration.UseSerialization<JsonSerializer>();

            configuration.UseContainer<WindsorBuilder>(c => c.ExistingContainer(Bootstrapper.CreateContainer(loggerFactory)));

            configuration.CustomConfigurationSource(new CustomConfigurationProvider(
                new Dictionary<Type, string>
                {
                    { typeof(IAllocationActualsVerified), AllocationDeliveryDomain.Common.EndpointName.AllocationDeliveryDomainValidation }
                }));
        }
    }
}
