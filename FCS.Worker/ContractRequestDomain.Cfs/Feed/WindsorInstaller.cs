namespace ContractRequestDomain.Cfs.Feed
{
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Infrastructure;
    using Repositories;
    using Services;
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
                Component.For<ILogger>().Instance(_loggerFactory.CreateDefaultLogger()),
                Component.For<ISessionConnectionFactory>().ImplementedBy<SessionConnectionFactory>().LifestyleSingleton(),
                Component.For<IAllocationNotificationService>().ImplementedBy<AllocationNotificationService>().LifestyleSingleton(),
                Component.For<IAllocationNotificationRepository>().ImplementedBy<AllocationNotificationRepository>().LifestyleSingleton(),
                Component.For<IAllocationNotificationFeedReader>().ImplementedBy<AllocationNotificationFeedReaderTestImpl>().LifestyleSingleton());
        }
    }
}
