namespace SFA.FCT.AllocationDeliveryDomain.MDEnrich.Endpoint.Ioc
{
    using BusinessLogic;
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Common.DataStore;
    using Microsoft.Extensions.Logging;
    using Infrastructure;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    
    public class ComponentInstaller : IWindsorInstaller
    {
        private readonly ILoggerFactory _loggerFactory;

        public ComponentInstaller(ILoggerFactory loggerFactory)
        {
            _loggerFactory = loggerFactory;
        }

        public void Install(IWindsorContainer container, IConfigurationStore store)
        {
            container.Register(
                Component.For<ILogger>().Instance(_loggerFactory.CreateLogger("AllocationDeliveryDomain")),
                Component.For<IContractAllocationTransformer>().ImplementedBy<ContractAllocationTransformer>(),
                Component.For<IMonitoringDeliverableStore>().ImplementedBy<MonitoringDeliverableStore>().LifestyleTransient(),
                Component.For<IMonitoringDeliverableEnrichment>().ImplementedBy<MonitoringDeliverableEnrichment>().LifestyleTransient(),
                Component.For<IMonitoringDeliverablesDbContext>().ImplementedBy<MonitoringDeliverablesDbContext>().LifestyleScoped(),
                Component.For<IInactiveAllocationRepository>().ImplementedBy<InactiveAllocationRepository>().LifestyleScoped(),
                Component.For<ISessionConnectionFactory>().ImplementedBy<SessionConnectionFactory>().LifestyleSingleton());
        }
    }
}