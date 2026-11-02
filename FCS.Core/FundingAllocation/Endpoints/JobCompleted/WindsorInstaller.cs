namespace FundingAllocation.Endpoints.JobCompleted
{
    using FundingAllocation.Services;
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using CheckForReadComplete;
    using Repositories;
    using Microsoft.Extensions.Configuration;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Slack;

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
                Component.For<IJobCompleteRepository>().ImplementedBy<JobCompleteRepository>().LifestyleTransient(),
                Component.For<IFundingIdService>().ImplementedBy<FundingIdService>().LifestyleTransient(),
                Component.For<IFundingAllocationRepository>().ImplementedBy<FundingAllocationRepository>().LifestyleTransient(),
                Component.For<IValidationOrchestrator>().ImplementedBy<ValidationOrchestrator>().LifestyleTransient(),
                Component.For<ICheckForReadCompleteNotificationService>().ImplementedBy<CheckForReadCompleteNotificationService>().LifestyleTransient(),
                Component.For<ISlackMessageSender>().ImplementedBy<SlackMessageSender>().LifestyleSingleton(),
                Component.For<IPreContractControlService>().ImplementedBy<PreContractControlService>().LifestyleTransient(),
                Component.For<INonMaterialCheckService>().ImplementedBy<NonMaterialCheckService>().LifestyleTransient(),
                Component.For<ICfsToFcsCodeMappingService>().ImplementedBy<CfsToFcsCodeMappingService>().LifestyleTransient(),
                Component.For<IContractTypeRepository>().ImplementedBy<ContractTypeRepository>().LifestyleTransient(),
                Component.For<IProviderCategoryRepository>().ImplementedBy<ProviderCategoryRepository>().LifestyleTransient(),
                Component.For<IAllocationFundingStreamConfigRepository>().ImplementedBy<AllocationFundingStreamConfigRepository>().LifestyleTransient(),
                Component.For<IAllocationLineConfigRepository>().ImplementedBy<AllocationLineConfigRepository>().LifestyleTransient(),
                Component.For<IConfigValidationService>().ImplementedBy<ConfigValidationService>().LifestyleTransient(),
                Component.For<ICheckForReadCompleteFundingAllocationRepository>().ImplementedBy<CheckForReadCompleteFundingAllocationRepository>().LifestyleTransient(),
                Component.For<IConfigurationRoot>().Instance(_appConfiguration));
        }
    }
}