namespace FundingAllocation.Endpoints.ReleaseGroup
{
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using FundingAllocation.Repositories;
    using FundingAllocation.Services;
    using Infrastructure;
    using Microsoft.Extensions.Configuration;
    using Repositories;
    using Slack;
    using Services;
    using SFA.FCT.Framework.Logging.Interfaces;
    using FundingAllocationRepository = FundingAllocation.Repositories.FundingAllocationRepository;
    using ICrmReleaseGroupRepository = Repositories.ICrmReleaseGroupRepository;
    using IReleaseGroupFundingAllocationRepository = Repositories.IReleaseGroupFundingAllocationRepository;
    using IReleaseGroupService = Services.IReleaseGroupService;

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
                Component.For<IContractStorage>().ImplementedBy<ContractStorage>().LifestyleSingleton(),
                Component.For<IFundingAllocationsToContractTransformer>()
                    .ImplementedBy<FundingAllocationsToContractTransformer>().LifestyleTransient(),
                Component.For<IReleaseGroupFundingAllocationRepository>()
                    .ImplementedBy<Repositories.ReleaseGroupFundingAllocationRepository>().LifestyleTransient(),
                Component.For<IExtendedContractTypeTransformer>().ImplementedBy<ExtendedContractTypeTransformer>()
                    .LifestyleSingleton(),
                Component.For<IContractNumberQueryRepository>().ImplementedBy<ContractNumberQueryRepository>()
                    .LifestyleTransient(),
                Component.For<IContractCommandRepository>().ImplementedBy<ContractCommandRepository>()
                    .LifestyleTransient(),
                Component.For<IProviderCategoryRepository>().ImplementedBy<ProviderCategoryRepository>()
                    .LifestyleTransient(),
                Component.For<ICfsToFcsCodeMappingService>().ImplementedBy<CfsToFcsCodeMappingService>()
                    .LifestyleTransient(),
                Component.For<IProcessedMessageRepository>().ImplementedBy<ProcessedMessageRepository>()
                    .LifestyleTransient(),
                Component.For<IFundingTypeRepository>().ImplementedBy<FundingTypeRepository>().LifestyleTransient(),
                Component.For<IFundingAllocationGroupingService>().ImplementedBy<FundingAllocationGroupingService>()
                    .LifestyleTransient(),
                Component.For<Repositories.IReleaseGroupRepository>()
                    .ImplementedBy<Repositories.ReleaseGroupRepository>().LifestyleTransient(),
                Component.For<IContractTypeRepository>().ImplementedBy<ContractTypeRepository>().LifestyleTransient(),
                Component.For<IIntentService>().ImplementedBy<IntentService>().LifestyleTransient(),
                Component.For<IFundingTypeFundingPeriodRepository>().ImplementedBy<FundingTypeFundingPeriodRepository>().LifestyleTransient(),
                Component.For<ICrmContractRepository>().ImplementedBy<CrmContractRepository>().LifestyleSingleton(),
                Component.For<FundingAllocation.Services.IReleaseGroupService>().ImplementedBy<FundingAllocation.Services.ReleaseGroupService>().LifestyleTransient(),
                Component.For<FundingAllocation.Repositories.ICrmReleaseGroupRepository>().ImplementedBy<FundingAllocation.Repositories.CrmReleaseGroupRepository>().LifestyleSingleton(),
                Component.For<IFundingAllocationRepository>().ImplementedBy<FundingAllocationRepository>().LifestyleTransient(),
                Component.For<IContractRepository>().ImplementedBy<ContractRepository>().LifestyleTransient(),
                Component.For<FundingAllocation.Repositories.IReleaseGroupRepository>().ImplementedBy<FundingAllocation.Repositories.ReleaseGroupRepository>().LifestyleTransient(),
                Component.For<ICrmFundingAllocationRepository>().ImplementedBy<CrmFundingAllocationRepository>().LifestyleTransient(),
                Component.For<ICrmPolicyConfigRepository>().ImplementedBy<CrmPolicyConfigRepository>().LifestyleTransient(),
                Component.For<ICrmProviderRepository>().ImplementedBy<CrmProviderRepository>().LifestyleTransient(),
                Component.For<IAllocationFundingStreamConfigRepository>().ImplementedBy<AllocationFundingStreamConfigRepository>().LifestyleTransient(),
                Component.For<IAllocationLineConfigRepository>().ImplementedBy<AllocationLineConfigRepository>().LifestyleTransient(),
                Component.For<IContractNumbersAndVersionIntentService>().ImplementedBy<ContractNumbersAndVersionIntentService>().LifestyleTransient(),
                Component.For<IFundingStreamPeriodRepository>().ImplementedBy<FundingStreamPeriodRepository>().LifestyleTransient(),
                Component.For<IAmendmentTypeService>().ImplementedBy<AmendmentTypeService>().LifestyleTransient(),
                Component.For<IAmendmentTypeServiceChecks>().ImplementedBy<AmendmentTypeServiceChecks>().LifestyleTransient(),
                Component.For<IReleaseGroupService>().ImplementedBy<Services.ReleaseGroupService>().LifestyleTransient(),
                Component.For<ICrmReleaseGroupRepository>().ImplementedBy<Repositories.CrmReleaseGroupRepository>().LifestyleSingleton(),
                Component.For<IConfigurationRoot>().Instance(_appConfiguration),
                Component.For<ISlackNotificationService>().ImplementedBy<SlackNotificationService>().LifestyleTransient(),
                Component.For<ISlackMessageSender>().ImplementedBy<SlackMessageSender>().LifestyleSingleton(),
                Component.For<IContractValueAggregator>().ImplementedBy<ContractValueAggregator>().LifestyleSingleton(),
                Component.For<IContractDeliverableEnricher>().ImplementedBy<ContractDeliverableEnricher>().LifestyleSingleton(),
                GetOverrideDateRegistration());
        }

        private IRegistration GetOverrideDateRegistration()
        {
            string useRealDate = _appConfiguration["UseRealDate"];

            if (useRealDate == "true")
            {
                return Component.For<IOverrideDateRepository>().ImplementedBy<SystemDateRepository>()
                    .LifestyleSingleton();
            }

            return Component.For<IOverrideDateRepository>().ImplementedBy<OverrideDateRepository>()
                .LifestyleTransient();
        }
    }
}
