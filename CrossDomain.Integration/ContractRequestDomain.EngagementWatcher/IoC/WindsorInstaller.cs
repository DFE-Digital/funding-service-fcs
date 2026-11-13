namespace SFA.FCT.ContractRequestDomain.EngagementWatcher.IoC
{
    using System.Configuration;
    using Castle.MicroKernel;
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Repositories;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;

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
                Component.For<IDasRequestService>().ImplementedBy<DasRequestService>().LifestyleScoped(),
                Component.For<IEngagementEventRepository>().ImplementedBy<EngagementEventRepository>().LifestyleScoped(),
                Component.For<IContractManagementDbContext>().ImplementedBy<ContractManagementDbContext>().LifestyleScoped(),
                Component.For<IFundingTypeFundingPeriodQueryRepository>().ImplementedBy<FundingTypeFundingPeriodQueryRepository>().LifestyleScoped(),
                Component.For(typeof(IEntityCache<,>)).ImplementedBy(typeof(EntityCache<,>)).LifestyleSingleton(),
                Component.For<IAzureTableStore>().ImplementedBy<AzureTableStore>().LifestyleSingleton(),
                Component.For<IEnvironmentContext>().ImplementedBy<EnvironmentContext>().LifestyleSingleton(),
                Component.For<IDasEventsApiAdapter>().UsingFactoryMethod(GetDasEventsApiAdapter).LifestyleSingleton(),
                Component.For<IOAuthAccessTokenFactory>().ImplementedBy<OAuthAccessTokenFactory>().LifestyleSingleton(),
                Component.For<ISessionConnectionFactory>().ImplementedBy<SessionConnectionFactory>().LifestyleScoped(),
                Component.For<ILogger>().Instance(_loggerFactory.CreateLogger("ContractManagementDomain")));
        }

        private IDasEventsApiAdapter GetDasEventsApiAdapter(IKernel kernel)
        {
            bool useStub = ConfigurationManager.AppSettings["DasEngagements.UseStub"] == "true";

            if (useStub)
            {
                return new DasEventsApiAdapterTestImpl(kernel.Resolve<IAzureTableStore>(), kernel.Resolve<IEnvironmentContext>());
            }

            return new DasEventsApiAdapter(kernel.Resolve<IOAuthAccessTokenFactory>());
        }
    }
}
