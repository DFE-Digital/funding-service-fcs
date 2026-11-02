namespace AllocationDeliveryDomain.Endpoint.ActualsPullComplete
{
    
    using ActualsPull.Repositories;
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Infrastructure;
    using Repositories;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class WindsorInstaller : IWindsorInstaller
    {
        private readonly ILoggerFactory _loggerFactory;

        public WindsorInstaller(ILoggerFactory loggerFactory)
        {
            _loggerFactory = loggerFactory;
        }

        public void Install(IWindsorContainer container, IConfigurationStore store)
        {
            container.Register(
                Component.For<ILogger>().Instance(_loggerFactory.CreateLogger("AllocationDeliveryDomain")),
                Component.For<ISessionConnectionFactory>().ImplementedBy<SessionConnectionFactory>()
                    .LifestyleSingleton(),
                Component.For<IClosedCollectionCompleteRepository>().ImplementedBy<ClosedCollectionRepository>().LifestyleSingleton(),
                Component.For<ISummarisedActualsQueryRepository>().ImplementedBy<SummarisedActualsRepository>().LifestyleSingleton());
        }
    }
}
