namespace FundingAllocation.Endpoints.CreateFundingAllocationInCrm
{
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Repositories;
    using Microsoft.Extensions.Configuration;
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
                Component.For<ICrmFundingAllocationRepository>().ImplementedBy<CrmFundingAllocationRepository>().LifestyleSingleton(),
                Component.For<ICrmPolicyConfigRepository>().ImplementedBy<CrmPolicyConfigRepository>().LifestyleSingleton(),
                Component.For<ICrmProviderRepository>().ImplementedBy<CrmProviderRepository>().LifestyleSingleton(),
                Component.For<IFundingAllocationRepository>().ImplementedBy<FundingAllocationRepository>().LifestyleTransient(),
                Component.For<ICrmReleaseGroupRepository>().ImplementedBy<CrmReleaseGroupRepository>().LifestyleSingleton(),
                Component.For<IReleaseGroupRepository>().ImplementedBy<ReleaseGroupRepository>().LifestyleTransient(),
                Component.For<IReleaseGroupService>().ImplementedBy<ReleaseGroupService>().LifestyleTransient(),
                Component.For<IProcessedMessageRepository>().ImplementedBy<ProcessedMessageRepository>().LifestyleTransient());
        }
    }
}
