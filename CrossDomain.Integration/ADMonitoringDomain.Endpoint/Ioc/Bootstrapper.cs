namespace ADMonitoringDomain.Endpoint.Ioc
{
    using System;
    using System.Configuration;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.OverrideDate;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore;
    using BusinessLogic;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Repositories;
    using DataStore;
    using PaymentGenerationDomain.BusinessLogic;
    using PaymentGenerationDomain.Integration.DataStore;
    using PaymentGenerationDomain.Integration.DataStore.Repositories;
    using Repositories;
    using SFA.FCT.AllocationDelivery.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.CrossDomain.Integration.Common.SchemaValidator;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;

    public static class Bootstrapper
    {
        public static IWindsorContainer CreateContainer(ILoggerFactory factory)
        {
            var container = new WindsorContainer();

            //return container.Register(
            //    Component.For<IAllocationDeliveryCommencedEvent>().ImplementedBy<AllocationDeliveryCommencedEvent>().LifeStyle.Transient,
            //    Component.For<IRulesEngine>().ImplementedBy<RulesEngine>().LifestyleScoped(),
            //    Component.For<IAtomGenerator>().ImplementedBy<AtomGenerator>().LifestyleScoped(),
            //    Component.For<IAllocationDeliveryDbContext>().UsingFactoryMethod(kernel => new AllocationDeliveryDbContext(kernel.Resolve<NHibernateStorageContext>().Connection)).LifestyleScoped(),
            //    Component.For<IAtomItemCreator>().ImplementedBy<AtomItemCreator>().LifestyleScoped(),
            //    Component.For<IPaymentSchedulePolicyContext>().UsingFactoryMethod(kernel => new PaymentSchedulePolicyContext(kernel.Resolve<NHibernateStorageContext>().Connection)).LifestyleScoped(),
            //    Component.For<PaymentGenerationDbContext>().UsingFactoryMethod(kernel => new PaymentGenerationDbContext(kernel.Resolve<NHibernateStorageContext>().Connection)).LifestyleScoped(),
            //    Component.For<IPaymentManagementPolicyContext>().UsingFactoryMethod(kernel => new PaymentManagementPolicyContext(kernel.Resolve<NHibernateStorageContext>().Connection)).LifestyleScoped(),
            //    Component.For<IMonitoringDeliverablesDbContext>().UsingFactoryMethod(kernel=> new MonitoringDeliverablesDbContext(kernel.Resolve<NHibernateStorageContext>().Connection)).LifestyleScoped(),
            //    Component.For<IAllocationDeliveryMonitoringDbContext>().UsingFactoryMethod(kernel => new AllocationDeliveryMonitoringDbContext(kernel.Resolve<NHibernateStorageContext>().Connection)).LifestyleScoped(),
            //    Component.For<IADMonitoringDeliveryEventStore>().ImplementedBy<ADMonitoringDeliveryEventStore>().LifestyleScoped(),
            //    Component.For<IDataAccessManager>().ImplementedBy<DataAccessManager>().LifestyleScoped(),               
            //    Component.For<IAllocationDeliveryMonitoringRepository>().ImplementedBy<AllocationDeliveryMonitoringRepository>().LifestyleScoped(),
            //    Component.For<IAllocationDeliveryPerformanceMapper>().ImplementedBy<AllocationDeliveryPerformanceMapper>().LifestyleScoped(),
            //    Component.For<ILogger>().Instance(factory.CreateLogger("ADMonitoringDomain")),
            //    Component.For<ISchemaValidator>().ImplementedBy<SchemaValidator>().LifestyleScoped(),
            //    ParseDateRegistration(),
            //    Component.For<IOverrideDateDBContext>().UsingFactoryMethod(kernel => new OverrideDateDBContext(kernel.Resolve<NHibernateStorageContext>().Connection)).LifestyleScoped(),
            //    Component.For<ISubnominalAggregationRepository>().ImplementedBy<SubnominalAggregationRepository>().LifestyleScoped(),
            //    Component.For<IApprovedContractRepository>().ImplementedBy<ApprovedContractRepository>().LifestyleScoped(),
            //    Component.For<IContractManagementDbContext>().UsingFactoryMethod(kernel => new ContractManagementDbContext(kernel.Resolve<NHibernateStorageContext>().Connection)).LifestyleScoped(),
            //    Component.For<IAllocationDeliverablePeriodActualAuditRepository>().ImplementedBy<AllocationDeliverablePeriodActualAuditRepository>().LifestyleScoped());
            return null;
        }

        // This registration is dependant on the environment:
        // StaticDate should be used on any environment in which automated tests have to be run
        // SystemDate should be used for production for performance improvements
        private static IRegistration ParseDateRegistration()
        {
            var useRealDate = Convert.ToBoolean(ConfigurationManager.AppSettings["UseRealDate"]);

            return useRealDate ? Component.For<IDate>().ImplementedBy<SystemDate>().LifestyleSingleton() : Component.For<IDate>().ImplementedBy<StaticDate>().LifestyleScoped();
        }
    }
}
