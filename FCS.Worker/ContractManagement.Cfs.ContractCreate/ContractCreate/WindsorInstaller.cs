namespace ContractManagement.Cfs.ContractCreate
{
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Cfs.Repositories;
    using Infrastructure;
    using Microsoft.Xrm.Sdk;
    using Repositories;
    using Services;
    using SFA.FCT.Framework.Logging.Interfaces;
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
            container.Register(
                Component.For<ILogger>().Instance(_loggerFactory.CreateDefaultLogger()).LifestyleSingleton(),
                Component.For<ISessionConnectionFactory>().ImplementedBy<SessionConnectionFactory>().LifestyleSingleton(),
                Component.For<IFundingTypeFundingPeriodEnrichmentService>().ImplementedBy<FundingTypeFundingPeriodEnrichmentService>().LifestyleSingleton(),
                Component.For<IFundingTypeFundingPeriodQueryRepository>().ImplementedBy<FundingTypeFundingPeriodQueryRepository>().LifestyleSingleton(),
                Component.For<IContractCfsAllocationRetrievalService>().ImplementedBy<ContractCfsAllocationRetrievalService>().LifestyleSingleton(),
                Component.For<IOrganizationService>().UsingFactoryMethod(k => CrmConnectionFactory.GetOrganizationService()).LifestyleScoped(),
                Component.For<IAllocationRepository>().ImplementedBy<AllocationRepository>().LifestyleScoped(),
                Component.For<IContractRepository>().ImplementedBy<ContractRepository>().LifestyleScoped()
            );
        }
    }
}
