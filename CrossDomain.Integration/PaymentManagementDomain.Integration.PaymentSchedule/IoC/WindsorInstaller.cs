namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.IoC
{
    using System;
    using System.Configuration;
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using ContractCreateDomain.Implementation.Persistence;
    using CrossDomain.Integration.Common;
    using BusinessLogic.FundingClaimReconciliation.Repositories;
    using BusinessLogic.Services;
    using CrossDomain.Integration.Entities.Data;
    using Framework.Logging.Interfaces;
    using PaymentManagementDomain.PaymentSchedule.DataStore;
    using PolicyCache.DataStore;
    using CrossDomain.Integration.OverrideDate;
    using CrossDomain.Integration.OverrideDate.DataStore;
    using Infrastructure;
    using PaymentManagement.Calculation;
    using PaymentManagement.Calculation.Repositories;
    using PaymentManagement.Calculation.Services;
    using PolicyCache.DataStore.Repositories;
    using PaymentManagementDomain.PaymentSchedule.DataStore.Repositories;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Events;

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
                Component.For<IPaymentScheduleAllocationCommandRepository>().ImplementedBy<PaymentScheduleAllocationCommandRepository>().LifestyleSingleton(),
                Component.For<IAllocationRepository>().ImplementedBy<AllocationRepository>().LifestyleSingleton(),
                Component.For<PaymentManagementDomain.PaymentSchedule.DataStore.Repositories.IDeliverablePaymentRepository>().ImplementedBy<PaymentManagementDomain.PaymentSchedule.DataStore.Repositories.DeliverablePaymentRepository>().LifestyleSingleton(),
                Component.For<IOrganisationIdentifierRepository>().ImplementedBy<OrganisationIdentifierRepository>().LifestyleSingleton(),
                Component.For<IPaymentManagementPolicyContext>().ImplementedBy<PaymentManagementPolicyContext>().LifestyleScoped(),
                Component.For<IPayCalcPolicyQueryRepository>().ImplementedBy<PayCalcPolicyQueryRepository>().LifestyleSingleton(),
                Component.For(typeof(IEntityCache<,>)).ImplementedBy(typeof(EntityCache<,>)).LifestyleSingleton(),
                Component.For<IPaymentSchedulePolicyContext>().ImplementedBy<PaymentSchedulePolicyContext>().LifestyleScoped(),
                Component.For<IOverrideDateDBContext>().ImplementedBy<OverrideDateDBContext>().LifeStyle.Transient,
                Component.For<IContractsManager>().ImplementedBy<ContractsManager>().LifeStyle.Transient,
                Component.For<IAllocationDeliveryCommencedEvent>().ImplementedBy<AllocationDeliveryCommencedEvent>().LifeStyle.Transient,
                Component.For<IPaymentScheduleService>().ImplementedBy<PaymentScheduleService>().LifestyleSingleton(),
                Component.For<IProvisionIdentifierRepository>().ImplementedBy<ProvisionIdentifierRepository>().LifestyleSingleton(),
                Component.For<IPreviousPaymentScheduleCopier>().ImplementedBy<PreviousPaymentScheduleCopier>().LifestyleSingleton(),
                Component.For<IPaymentScheduleCreator>().ImplementedBy<NonCalculationPaymentScheduleCreator>().LifestyleSingleton(),
                Component.For<IPublishedPayableFcrAllocationRepository>().ImplementedBy<PublishedPayableFcrAllocationRepository>().LifestyleSingleton(),
                Component.For<IActualValueNullResetService>().ImplementedBy<ActualValueNullResetService>().LifestyleSingleton(),
                Component.For<IActualVolumeApplicator>().ImplementedBy<ActualVolumeApplicator>().LifestyleSingleton(),
                Component.For<IActualVolumeService>().ImplementedBy<ActualVolumeService>().LifestyleSingleton(),
                Component.For<IPaymentValuesCalculationService>().ImplementedBy<PaymentValuesCalculationService>().LifestyleSingleton(),
                Component.For<IPaymentValuesCalculator>().ImplementedBy<PaymentValuesCalculator>().LifestyleSingleton(),
                Component.For<IDateService>().ImplementedBy<DateService>().LifestyleSingleton(),
                Component.For<IPolicyFundingStreamPeriodRepository>().ImplementedBy<PolicyFundingStreamPeriodRepository>().LifestyleSingleton(),
                Component.For<IPaymentTimetableRepository>().ImplementedBy<PaymentTimetableRepository>().LifestyleSingleton(),
                Component.For<PaymentManagement.Calculation.Repositories.IDeliverablePaymentRepository>().ImplementedBy<PaymentManagement.Calculation.Repositories.DeliverablePaymentRepository>().LifestyleSingleton(),
                Component.For<IAllocationQueryRepository>().ImplementedBy<AllocationQueryRepository>().LifestyleSingleton(),
                Component.For<IActualEnrichmentService>().ImplementedBy<CalculationInputActualEnrichmentService>().LifestyleSingleton(),
                Component.For<IBehaviourFactory>().ImplementedBy<BehaviourFactory>().LifestyleSingleton(),
                Component.For<IFundingClaimReconciliationService>().ImplementedBy<FundingClaimReconciliationService>().LifestyleSingleton(),
                Component.For<ILogger>().Instance(_loggerFactory.CreateLogger("PaymentManagementDomain")),
                Component.For<IFcrPaymentValuesCalculationService>().ImplementedBy<FcrPaymentValuesCalculationService>().LifestyleSingleton(),
                Component.For<IOrganisationDetailsRepository>().ImplementedBy<OrganisationDetailsRepository>().LifestyleSingleton(),
                Component.For<ICensusDateService>().ImplementedBy<CensusDateService>().LifestyleSingleton(),
                Component.For<ISessionConnectionFactory>().ImplementedBy<SessionConnectionFactory>().LifestyleSingleton(),
                ParseDateRegistration());
        }

        //// This registration is dependant on the environment:
        //// StaticDate should be used on any environment in which automated tests have to be run
        //// SystemDate should be used for production for performance improvements
        private static IRegistration ParseDateRegistration()
        {
            var useRealDate = Convert.ToBoolean(ConfigurationManager.AppSettings["UseRealDate"]);

            return useRealDate ? Component.For<IDate>().ImplementedBy<SystemDate>().LifestyleSingleton() : Component.For<IDate>().ImplementedBy<StaticDate>().LifestyleSingleton();
        }
    }
}
