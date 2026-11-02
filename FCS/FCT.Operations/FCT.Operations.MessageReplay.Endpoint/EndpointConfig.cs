namespace SFA.FCT.Operations.MessageReplay.Endpoint
{
    using System;
    using System.Collections.Generic;
    using Castle.Windsor;
    using NServiceBus;
    using CrossDomain.Integration.Common;
    using Framework.Logging;
    using Framework.Logging.Interfaces;
    using IoC;

    // we need nsb 7 now
    //public class EndpointConfig : AsA_FctEndpoint, IConfigureThisEndpoint
    //{
    //    private const string EndpointNameStr = "Operations.MessageReplay";

    //    public static string EndpointName => FctEndpoint.GenerateEndpointName(EndpointNameStr);

    //    public void Customize(BusConfiguration configuration)
    //    {
    //        ILoggerFactory factory = new LoggerFactory();
    //        Customize(configuration, factory);
    //    }

    //    public void Customize(BusConfiguration configuration, ILoggerFactory loggerFactory)
    //    {
    //        configuration.EndpointName(EndpointName);
    //        configuration.UseDataBus<AzureDataBus>();
    //        configuration.UsePersistence<InMemoryPersistence>();
    //        configuration.UseSerialization<JsonSerializer>();
    //        configuration.UseContainer<WindsorBuilder>(c => c.ExistingContainer(new WindsorContainer().Install(new WindsorInstaller(loggerFactory))));

    //        configuration.Conventions()
    //            .DefiningCommandsAs(t => t.Namespace != null && t.Namespace.EndsWith("Commands"))
    //            .DefiningEventsAs(t => t.Namespace != null && t.Namespace.EndsWith("Events"));

    //        configuration.CustomConfigurationSource(new CustomConfigurationProvider(new Dictionary<Type, string>()));
    //    }
    //}
}