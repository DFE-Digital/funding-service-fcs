namespace SFA.FCT.PerformanceManagementDomain.IoC
{
    using System;
    using System.Configuration;
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Common.Repositories;
    using CrossDomain.Integration.Common;
    using CrossDomain.Integration.OverrideDate;
    using CrossDomain.Integration.OverrideDate.DataStore;
    using DataStore.Repositories;
    using Framework.Logging.Interfaces;
    using FundingClaimImportEndpoint.Services;
    using DataStore;
    using DataStore.Repositories.Atom;
    using PaymentManagementDomain.PolicyCache.DataStore;

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
                Component.For<ILogger>().Instance(_loggerFactory.CreateLogger("PerformanceManagementDomain")));

            container.Register(Component.For<IFundingClaimReconciliationQueryRepository>().ImplementedBy<FundingClaimReconciliationQueryRepository>().LifestyleTransient());

            container.Register(Component.For<IPerformanceManagementDbContext>().ImplementedBy<PerformanceManagementDbContext>().LifestyleScoped());
            // this one below is temporary and can come out when we have a local table
            container.Register(Component.For<IPaymentManagementPolicyContext>().ImplementedBy<PaymentManagementPolicyContext>().LifestyleScoped());
            container.Register(Component.For<IFundingClaimDebatchService>().ImplementedBy<FundingClaimDebatchService>().LifestyleTransient());
            container.Register(Component.For<IFundingClaimRepository>().ImplementedBy<FundingClaimRepository>().LifestyleTransient());
            container.Register(Component.For<IFundingClaimCollectionImportInfoRepository>().ImplementedBy<FundingClaimCollectionImportInfoRepository>().LifestyleTransient());
            container.Register(Component.For<IFspDeliverableClaimRepository>().ImplementedBy<FspDeliverableClaimRepository>().LifestyleTransient());
            container.Register(Component.For<IClaimReconciliationAllocationGroupFspRepository>().ImplementedBy<ClaimReconciliationAllocationGroupFspRepository>().LifestyleScoped());
            container.Register(Component.For<IClaimReconciliationAllocationGroupRepository>().ImplementedBy<ClaimReconciliationAllocationGroupRepository>().LifestyleTransient());
            container.Register(Component.For<IContractAllocationDeliverableRepository>().ImplementedBy<ContractAllocationDeliverableRepository>().LifestyleTransient());
            container.Register(Component.For<IClaimReconciliationBehaviourRepository>().ImplementedBy<ClaimReconciliationBehaviourRepository>().LifestyleScoped());
            container.Register(Component.For<IClaimTypeRepository>().ImplementedBy<ClaimTypeRepository>().LifestyleTransient());
            container.Register(Component.For<IContractAllocationRepository>().ImplementedBy<ContractAllocationRepository>().LifestyleScoped());
            container.Register(Component.For<IDedsSearchProxyServiceChannelFactory>().ImplementedBy<DedsSearchProxyServiceChannelFactory>().LifestyleTransient());
            container.Register(Component.For<IFundingClaimDedsService>().ImplementedBy<FundingClaimDedsService>().LifestyleSingleton());
            container.Register(Component.For<IOverrideDateDBContext>().ImplementedBy<OverrideDateDBContext>().LifestyleScoped());
            container.Register(Component.For<IFundingClaimReconciliationCommandRepository>().ImplementedBy<FundingClaimReconciliationCommandRepository>().LifestyleScoped());
            container.Register(Component.For<IAtomFeedItemQueryRepository>().ImplementedBy<AtomFeedItemQueryRepository>().LifestyleScoped());
            container.Register(Component.For<IClaimReferenceProfileRepository>().ImplementedBy<ClaimReferenceProfileRepository>().LifestyleScoped());
            container.Register(Component.For<IFundingStreamPeriodQueryRepository>().ImplementedBy<FundingStreamPeriodQueryRepository>().LifestyleScoped());
            container.Register(Component.For<IFundingClaimAllocationFilter>().ImplementedBy<FundingClaimAllocationFilter>().LifestyleScoped());

            container.Register(ParseDateRegistration());
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
