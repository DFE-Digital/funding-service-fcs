namespace ContractRequestDomain.Cfs.Detail
{
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using ContractRequestDomain.Cfs.Detail.Repositories;
    using ContractRequestDomain.Cfs.Detail.Services;
    using Infrastructure;
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
                Component.For<IProcessNewAllocationNotificationsService>().ImplementedBy<ProcessNewAllocationNotificationsService>().LifestyleSingleton(),
                Component.For<IAllocationDetailService>().ImplementedBy<AllocationDetailServiceTestImpl>().LifestyleSingleton(),
                Component.For<IAllocationNotificationRepository>().ImplementedBy<AllocationNotificationRepository>().LifestyleSingleton(),
                Component.For<ISessionConnectionFactory>().ImplementedBy<SessionConnectionFactory>().LifestyleSingleton());
        }
    }
}
