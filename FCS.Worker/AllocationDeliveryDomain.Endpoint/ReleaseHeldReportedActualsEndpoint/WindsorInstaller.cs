namespace AllocationDeliveryDomain.Endpoint.ReleaseHeldReportedActualsEndpoint
{
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Infrastructure;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Services;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.Framework.Logging.Interfaces;
    using ClosedCollectionRepository = SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;

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
                Component.For<ISessionConnectionFactory>().ImplementedBy<SessionConnectionFactory>().LifestyleSingleton(),
                Component.For<IAzureRepository<ActualsCollectionTypeSummary>>().ImplementedBy<AzureRepository<ActualsCollectionTypeSummary>>().LifestyleSingleton(),
                Component.For<IHeldReportedActualGroupQueryRepository, IHeldReportedActualGroupCommandRepository>().ImplementedBy<HeldReportedActualGroupRepository>().LifestyleScoped(),
                Component.For<IClosedCollectionRepository>().ImplementedBy<ClosedCollectionRepository.ClosedCollectionRepository>().LifestyleScoped(),
                Component.For<MonitoringDeliverablesDbContext>().LifestyleScoped(),
                Component.For<IHeldPartitionKeyQueryService>().ImplementedBy<HeldReportedActualGroupService>().LifestyleScoped(),
                Component.For<IHeldFspCollectionConfigRepository>().ImplementedBy<HeldFspCollectionConfigRepository>().LifestyleScoped(),
                Component.For<IAzureTableStore>().ImplementedBy<AzureTableStore>().LifestyleScoped(),
                Component.For<IEnvironmentContext>().ImplementedBy<EnvironmentContext>().LifestyleSingleton()
            );
        }
    }
}