namespace FundingAllocation.Endpoints.UnParkFundingAllocation
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
                Component.For<IAllocationFundingStreamConfigRepository>().ImplementedBy<AllocationFundingStreamConfigRepository>().LifestyleTransient(),
                Component.For<IContractTypeRepository>().ImplementedBy<ContractTypeRepository>().LifestyleTransient(),
                Component.For<IFundingAllocationRepository>().ImplementedBy<FundingAllocationRepository>().LifestyleTransient(),
                Component.For<IProviderCategoryRepository>().ImplementedBy<ProviderCategoryRepository>().LifestyleTransient(),
                Component.For<IAllocationLineConfigRepository>().ImplementedBy<AllocationLineConfigRepository>().LifestyleTransient(),
                Component.For<INonMaterialCheckService>().ImplementedBy<NonMaterialCheckService>().LifestyleTransient(),
                Component.For<IConfigValidationService>().ImplementedBy<ConfigValidationService>().LifestyleTransient(),
                Component.For<IPreContractControlService>().ImplementedBy<PreContractControlService>().LifestyleTransient());
        }
    }
}
