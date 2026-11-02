namespace PerformanceManagementDomain.ReconciliationCalculationEndpoint
{
    using System;
    using System.Configuration;
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using CrmRepositories;
    using Microsoft.Xrm.Client;
    using Microsoft.Xrm.Client.Services;
    using Microsoft.Xrm.Sdk;
    using Infrastructure;
    using PerformanceManagementDomain.Services;
    using Services;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Repositories;
    using SFA.FCS.Worker.Common.Crm;

    public class WindsorInstaller : IWindsorInstaller
    {
        private readonly ILoggerFactory _loggerFactory;

        public WindsorInstaller(ILoggerFactory loggerFactory)
        {
            _loggerFactory = loggerFactory;
        }

        public void Install(IWindsorContainer container, IConfigurationStore store)
        {
            // Infrastructure
            container.Register(Component.For<ILogger>().Instance(_loggerFactory.CreateLogger("PerformanceManagementDomain")));
            container.Register(Component.For<ISessionConnectionFactory>().ImplementedBy<SessionConnectionFactory>().LifestyleSingleton());

            // CRM
            container.Register(Component.For<IOrganizationService>()
                .UsingFactoryMethod(k => CrmConnectionFactory.GetOrganizationService()).LifestyleScoped());
            container.Register(Component.For<ICrmFundingClaimReconciliationRepository>().ImplementedBy<CrmFundingClaimReconciliationRepository>().LifestyleScoped());

            // Assembly services
            container.Register(Component.For<ICalculationService>().ImplementedBy<CalculationService>().LifestyleScoped());
            container.Register(Component.For<IDeliverableGroupAmountSummaryCreator>().ImplementedBy<DeliverableGroupAmountSummaryCreator>().LifestyleScoped());
            container.Register(Component.For<IFcrRecalculationRequiredChecker>().ImplementedBy<FcrRecalculationRequiredChecker>().LifestyleScoped());
            container.Register(Component.For<IFundingClaimDebatchService>().ImplementedBy<FundingClaimDebatchService>().LifestyleTransient());
            container.Register(Component.For<IFcrUpdateService>().ImplementedBy<FcrUpdateService>().LifestyleScoped());
            container.Register(Component.For<IFundingClaimEnrichmentService>().ImplementedBy<FundingClaimEnrichmentService>().LifestyleScoped());
            container.Register(Component.For<IPolicyDeliverableRepository>().ImplementedBy<PolicyDeliverableRepository>().LifestyleScoped());
            container.Register(Component.For<Repositories.IContractAllocationDeliverableRepository>().ImplementedBy<Repositories.ContractAllocationDeliverableRepository>().LifestyleTransient());
            container.Register(Component.For<Repositories.IClaimReconciliationAllocationGroupFspRepository>().ImplementedBy<Repositories.ClaimReconciliationAllocationGroupFspRepository>().LifestyleTransient());

            // Datastore repositories
            container.Register(Component.For<Repositories.IFspDeliverableClaimRepository>().ImplementedBy<Repositories.FspDeliverableClaimRepository>().LifestyleTransient());
            container.Register(Component.For<Repositories.IClaimReconciliationAllocationGroupRepository>().ImplementedBy<Repositories.ClaimReconciliationAllocationGroupRepository>().LifestyleTransient());
            container.Register(Component.For<Repositories.IClaimReconciliationBehaviourRepository>().ImplementedBy<Repositories.ClaimReconciliationBehaviourRepository>().LifestyleScoped());
            container.Register(Component.For<Repositories.IClaimTypeRepository>().ImplementedBy<Repositories.ClaimTypeRepository>().LifestyleTransient());
            container.Register(Component.For<Repositories.IContractAllocationRepository>().ImplementedBy<Repositories.ContractAllocationRepository>().LifestyleScoped());
            container.Register(Component.For<Repositories.IClaimReferenceProfileRepository>().ImplementedBy<Repositories.ClaimReferenceProfileRepository>().LifestyleScoped());
            container.Register(Component.For<Repositories.IFundingClaimRepository>().ImplementedBy<Repositories.FundingClaimRepository>().LifestyleTransient());
            container.Register(Component.For<Repositories.IFundingStreamPeriodQueryRepository>().ImplementedBy<Repositories.FundingStreamPeriodQueryRepository>().LifestyleTransient());

            container.Register(Component.For<IParentDeliverableResolver>().ImplementedBy<ParentDeliverableResolver>().LifestyleSingleton());
        }
    }
}