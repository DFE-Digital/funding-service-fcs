namespace AllocationDeliveryDomain.Endpoint.PaymentInstructionValidation
{
    using System;
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using SFA.FCT.Framework.Logging.Interfaces;
    using System.Configuration;
    using Endpoint.Repositories;
    using Services;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Common;
    using Infrastructure;
    using Repositories;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.OverrideDate;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore;

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

                Component.For<IMultiSourceActualRepository>().ImplementedBy<MultiSourceActualRepository>().LifestyleSingleton(),
                Component.For<ISummarisedActualsQueryRepository>().ImplementedBy<SummarisedActualsRepository>().LifestyleSingleton(),
                Component.For<IAzureRepository<ReportedActual>>().ImplementedBy<AzureRepository<ReportedActual>>(),
                Component.For<IAzureTableStore>().ImplementedBy<AzureTableStore>(),
                Component.For<IEnvironmentContext>().ImplementedBy<EnvironmentContext>(),

                Component.For<IMonitoringDeliverableStore>().ImplementedBy<MonitoringDeliverableStore>().LifestyleScoped(),
                Component.For<IReportedPaymentEnricher>().ImplementedBy<ReportedPaymentEnricher>().LifestyleScoped(),
                Component.For<IPaymentInstructionValidator>().ImplementedBy<PaymentInstructionValidator>().LifestyleScoped(),
                Component.For<Repositories.IPaymentInstructionAuditRepository>().ImplementedBy<Repositories.PaymentInstructionAuditRepository>().LifestyleScoped(),
                Component.For<IMonitoringDeliverablesForAllocationService>().ImplementedBy<MonitoringDeliverablesForAllocationService>().LifestyleScoped(),

                Component.For<IOverrideDateDBContext>().ImplementedBy<OverrideDateDBContext>().LifestyleScoped(),
                Component.For<IMonitoringDeliverablesDbContext>().ImplementedBy<MonitoringDeliverablesDbContext>().LifestyleScoped(),
                ParseDateRegistration()
            );
        }

        // This registration is dependent on the environment:
        // StaticDate should be used on any environment in which automated tests have to be run
        // SystemDate should be used for production for performance improvements
        private static IRegistration ParseDateRegistration()
        {
            var useRealDate = Convert.ToBoolean(ConfigurationManager.AppSettings["UseRealDate"]);

            return useRealDate ? Component.For<IDate>().ImplementedBy<SystemDate>().LifestyleSingleton() : Component.For<IDate>().ImplementedBy<StaticDate>().LifestyleScoped();
        }
    }
}