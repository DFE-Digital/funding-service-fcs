namespace FundingAllocation.Endpoints.UpdateFundingAllocation
{
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Microsoft.Extensions.Configuration;
    using Repositories;
    using Services;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class WindsorInstaller : IWindsorInstaller
    {
        private readonly ILogger _logger;
        private readonly IConfigurationRoot _appConfiguration;

        public WindsorInstaller(ILogger logger, IConfigurationRoot appConfiguration)
        {
            _logger = logger;
            _appConfiguration = appConfiguration;
        }

        public void Install(IWindsorContainer container, IConfigurationStore store)
        {
            container.Register(
                Component.For<ILogger>().Instance(_logger),
                Component.For<IConfigurationRoot>().Instance(_appConfiguration),
                Component.For<IFundingAllocationRepository>().ImplementedBy<FundingAllocationRepository>().LifestyleTransient(),
                Component.For<IReleaseGroupRepository>().ImplementedBy<ReleaseGroupRepository>().LifestyleTransient(),
                Component.For<ICfsToFcsCodeMappingService>().ImplementedBy<CfsToFcsCodeMappingService>().LifestyleTransient(),
                Component.For<IProviderCategoryRepository>().ImplementedBy<ProviderCategoryRepository>().LifestyleTransient(),
                Component.For<ICrmReleaseGroupRepository>().ImplementedBy<CrmReleaseGroupRepository>().LifestyleTransient(),
                Component.For<ICrmFundingAllocationRepository>().ImplementedBy<CrmFundingAllocationRepository>().LifestyleTransient(),
                Component.For<IContractTypeRepository>().ImplementedBy<ContractTypeRepository>().LifestyleTransient(),
                Component.For<ICrmProviderRepository>().ImplementedBy<CrmProviderRepository>().LifestyleSingleton(),
                Component.For<ICrmPolicyConfigRepository>().ImplementedBy<CrmPolicyConfigRepository>().LifestyleSingleton(),
                Component.For<ICrmUpdateFundingAllocationRepository>().ImplementedBy<CrmUpdateFundingAllocationRepository>().LifestyleSingleton(),
                Component.For<IReleaseGroupService>().ImplementedBy<ReleaseGroupService>().LifestyleTransient(),
                Component.For<INonMaterialCheckService>().ImplementedBy<NonMaterialCheckService>().LifestyleTransient(),
                Component.For<IAllocationFundingStreamConfigRepository>().ImplementedBy<AllocationFundingStreamConfigRepository>().LifestyleTransient(),
                Component.For<IAllocationLineConfigRepository>().ImplementedBy<AllocationLineConfigRepository>().LifestyleTransient(),
                Component.For<IConfigValidationService>().ImplementedBy<ConfigValidationService>().LifestyleTransient(),
                Component.For<IPreContractControlService>().ImplementedBy<PreContractControlService>().LifestyleTransient()
            );
        }
    }
}
