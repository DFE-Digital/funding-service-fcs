namespace SFA.FCT.Operations.MessageReplay.Endpoint.IoC
{
    using System.Configuration;
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Common.Serializers;
    using Common.Services;
 
    using Framework.Logging.Interfaces;
    using Services;
    using Services.Stubs;

    public class WindsorInstaller : IWindsorInstaller
    {
        private readonly ILoggerFactory _loggerFactory;

        public WindsorInstaller(ILoggerFactory loggerFactory)
        {
            _loggerFactory = loggerFactory;
        }

        public void Install(IWindsorContainer container, IConfigurationStore store)
        {
            container.Register(Component.For<ILogger>().Instance(_loggerFactory.CreateLogger("Operations.MessageReplay.Endpoint")));
            container.Register(GetQueueQueryServiceComponentRegistration().LifestyleSingleton());
            container.Register(Component.For<IOperationsJsonSerializer>().ImplementedBy<OperationsJsonSerializer>().LifestyleSingleton());
        }

        private static ComponentRegistration<IQueueQueryService> GetQueueQueryServiceComponentRegistration()
        {
            bool useStubQueueQueryService = bool.Parse(ConfigurationManager.AppSettings["UseStubQueueQueryService"]);

            return useStubQueueQueryService ?
                Component.For<IQueueQueryService>().ImplementedBy<StubQueueQueryService>() :
                Component.For<IQueueQueryService>().ImplementedBy<QueueService>();
        }
    }
}