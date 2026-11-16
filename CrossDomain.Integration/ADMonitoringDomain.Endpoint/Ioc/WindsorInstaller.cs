namespace ADMonitoringDomain.Endpoint.Ioc
{
    using Castle.MicroKernel.SubSystems.Configuration;
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
    using Infrastructure;
    using PaymentGenerationDomain.BusinessLogic;
    using PaymentGenerationDomain.Integration.DataStore;
    using PaymentGenerationDomain.Integration.DataStore.Repositories;
    using Repositories;
    using SFA.FCT.AllocationDelivery.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.CrossDomain.Integration.Common.SchemaValidator;
    using SFA.FCT.CrossDomain.Integration.Events;
    using Microsoft.Extensions.Logging;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;

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
                Component.For<IAllocationDeliveryCommencedEvent>().ImplementedBy<AllocationDeliveryCommencedEvent>().LifeStyle.Transient,
                Component.For<IRulesEngine>().ImplementedBy<RulesEngine>().LifestyleScoped(),
                Component.For<IAtomGenerator>().ImplementedBy<AtomGenerator>().LifestyleScoped(),
                Component.For<IAllocationDeliveryDbContext>().ImplementedBy<AllocationDeliveryDbContext>().LifestyleScoped(),
                Component.For<IAtomItemCreator>().ImplementedBy<AtomItemCreator>().LifestyleScoped(),
                Component.For<IPaymentSchedulePolicyContext>().ImplementedBy<PaymentSchedulePolicyContext>().LifestyleScoped(),
                Component.For<PaymentGenerationDbContext>().ImplementedBy<PaymentGenerationDbContext>().LifestyleScoped(),
                Component.For<IPaymentManagementPolicyContext>().ImplementedBy<PaymentManagementPolicyContext>().LifestyleScoped(),
                Component.For<IMonitoringDeliverablesDbContext>().ImplementedBy<MonitoringDeliverablesDbContext>().LifestyleScoped(),
                Component.For<IAllocationDeliveryMonitoringDbContext>().ImplementedBy<AllocationDeliveryMonitoringDbContext>().LifestyleScoped(),
                Component.For<IADMonitoringDeliveryEventStore>().ImplementedBy<ADMonitoringDeliveryEventStore>().LifestyleScoped(),
                Component.For<IDataAccessManager>().ImplementedBy<DataAccessManager>().LifestyleScoped(),
                Component.For<IAllocationDeliveryMonitoringRepository>().ImplementedBy<AllocationDeliveryMonitoringRepository>().LifestyleScoped(),
                Component.For<IAllocationDeliveryPerformanceMapper>().ImplementedBy<AllocationDeliveryPerformanceMapper>().LifestyleScoped(),
                Component.For<ILogger>().Instance(_loggerFactory.CreateLogger("ADMonitoringDomain")),
                Component.For<ISchemaValidator>().ImplementedBy<SchemaValidator>().LifestyleScoped(),
                ParseDateRegistration(),
                Component.For<IOverrideDateDBContext>().ImplementedBy<OverrideDateDBContext>().LifestyleScoped(),
                Component.For<ISubnominalAggregationRepository>().ImplementedBy<SubnominalAggregationRepository>().LifestyleScoped(),
                Component.For<IApprovedContractRepository>().ImplementedBy<ApprovedContractRepository>().LifestyleScoped(),
                Component.For<IContractManagementDbContext>().ImplementedBy<ContractManagementDbContext>().LifestyleScoped(),
                Component.For<IAllocationDeliverablePeriodActualAuditRepository>().ImplementedBy<AllocationDeliverablePeriodActualAuditRepository>().LifestyleScoped(),
                Component.For<ISessionConnectionFactory>().ImplementedBy<SessionConnectionFactory>().LifestyleSingleton()
                );

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
