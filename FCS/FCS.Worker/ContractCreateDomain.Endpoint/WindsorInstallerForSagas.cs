namespace ContractCreateDomain.Endpoint
{
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Services.Repositories;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Repositories;
    using ContractManagement.DataStore.Services;
    using Infrastructure;
    using Microsoft.Xrm.Sdk;
    using Services;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.ContractCreateDomain.BusinessLogic;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Services;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation;
    using SFA.FCT.ContractCreateDomain.Implementation;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractCreateDomain.Implementation.Repositories;
    using SFA.FCT.ContractCreateDomain.Implementation.Services;
    using SFA.FCT.Framework.Logging.Interfaces;
    using FundingTypeFundingPeriodQueryRepository = Infrastructure.FundingTypeFundingPeriodQueryRepository;
    using FundingTypePeriodService = Infrastructure.FundingTypePeriodService;
    using IFundingTypeFundingPeriodQueryRepository = Infrastructure.IFundingTypeFundingPeriodQueryRepository;
    using IFundingTypePeriodService = Infrastructure.IFundingTypePeriodService;
    using PolicyConfigRepository = ContractManagement.DataStore.Repositories.PolicyConfigRepository;

    public class WindsorInstallerForSagas : IWindsorInstaller
    {
        private readonly ILoggerFactory _loggerFactory;

        public WindsorInstallerForSagas(ILoggerFactory loggerFactory)
        {
            _loggerFactory = loggerFactory;
        }

        public void Install(IWindsorContainer container, IConfigurationStore store)
        {
            container.Install(
                 new OrganizationServiceInstaller());

            container.Register(
                Component.For<IContractManagementDbContext>().ImplementedBy<ContractManagementDbContext>().LifestyleScoped(),
                Component.For<IFundingTypeFundingPeriodQueryRepository>().ImplementedBy<FundingTypeFundingPeriodQueryRepository>().LifestyleScoped(),
                Component.For<IFundingTypePeriodFundingStreamPeriodQueryRepository>().ImplementedBy<FundingTypePeriodFundingStreamPeriodQueryRepository>().LifestyleScoped(),
                Component.For<IContractRequestTransformer>().ImplementedBy<ContractRequestTransformer>(),
                Component.For<IOrganisationMessageEnricher>()
                    .ImplementedBy<OrganisationMessageEnricher>()
                    .LifestyleTransient(),
                Component.For<IOrganisationService>().ImplementedBy<OrganisationService>().LifestyleSingleton(),
                Component.For<IOrganisationServiceApiHttpClient>().ImplementedBy<OrganisationServiceApiHttpClient>().LifestyleSingleton(),
                Component.For<IContractDeliverableEnricher>().ImplementedBy<ContractDeliverableEnricher>(),
                Component.For<IFundingStreamConfigService>().ImplementedBy<FundingStreamConfigService>(),
                Component.For<IContractValueAggregator>().ImplementedBy<ContractValueAggregator>(),
                Component.For<ContractCreateDomain.Endpoint.Infrastructure.IContractValidationLookupDataCreator>()
                    .ImplementedBy<ContractCreateDomain.Endpoint.Infrastructure.ContractValidationLookupDataCreator>().LifestyleScoped(),
                Component.For<IMasher>().ImplementedBy<Masher>(),
                Component.For<IValidator>()
                    .ImplementedBy<Validator>(),
                Component.For<ContractCreateDomain.Endpoint.Infrastructure.IContractOperationRules>()
                    .ImplementedBy<ContractCreateDomain.Endpoint.Infrastructure.ContractOperationRules>()
                    .LifestyleScoped(),
                Component.For<ILookupManager>().ImplementedBy<LookupManager>().LifestyleTransient(),
                Component.For<IBatchCacheManager>().ImplementedBy<BatchCacheManager>(),
                Component.For<IEnduringCacheManager>().ImplementedBy<EnduringCacheManager>().LifestyleSingleton(),
                Component.For<INumberRequestManager>().ImplementedBy<XrmNumberRequestManager>().LifestyleTransient(),
                Component.For<INumberPrefixRepository>().ImplementedBy<NumberPrefixRepository>().LifestyleTransient(),
                Component.For<ISequenceRepository>().ImplementedBy<SequenceRepository>().LifestyleSingleton(),
                Component.For<IContractsManager>().ImplementedBy<ContractsManager>().LifestyleTransient(),
                Component.For<IXrmOrganisationManager>().ImplementedBy<XrmOrganisationManager>().LifestyleTransient(),
                Component.For<IXrmWorkflowManager>().ImplementedBy<XrmWorkflowManager>().LifestyleTransient(),
                Component.For<IFundingTypePeriodService>().ImplementedBy<FundingTypePeriodService>().LifestyleScoped(),
                Component.For<Infrastructure.IProcessedMessageRepository>().ImplementedBy<Infrastructure.ProcessedMessageRepository>().LifestyleSingleton(),
                Component.For<ILogger>().Instance(_loggerFactory.CreateLogger("ContractCreateDomain")),
                Component.For<IPolicyConfigRepository>().ImplementedBy<PolicyConfigRepository>().LifestyleScoped(),
                Component.For<IFundingStreamPeriodLegalDeliverableRepository>().ImplementedBy<FundingStreamPeriodLegalDeliverableRepository>().LifestyleScoped(),
                Component.For<IPreviousContractMerger>().ImplementedBy<PreviousContractMerger>().LifestyleScoped(),
                Component.For<IPreviousContractRepository>().ImplementedBy<PreviousContractRepository>().LifestyleScoped(),
                Component.For<ISessionConnectionFactory>().ImplementedBy<SessionConnectionFactory>().LifestyleSingleton(),
                Component.For<ILegalDeliverableService>().ImplementedBy<LegalDeliverableService>().LifestyleScoped(),
                Component.For<ISagaDataStorage>().ImplementedBy<SagaDataStorage>().LifestyleSingleton(),
                Component.For<IFundingTypeFundingPeriodContractTypeQueryRepository>().ImplementedBy<FundingTypeFundingPeriodContractTypeQueryRepository>().LifestyleSingleton(),
                Component.For<ICheckForContractChangeService>().ImplementedBy<CheckForContractChangeService>().LifestyleScoped(),
                Component.For<ICheckForAllocationChangeService>().ImplementedBy<CheckForAllocationChangeService>().LifestyleSingleton(),
                Component.For<ICrmContractQueryRepository>().ImplementedBy<CrmContractQueryRepository>().LifestyleScoped(),
                Component.For<ISiblingApprovedContractService>().ImplementedBy<SiblingApprovedContractService>().LifestyleSingleton(),
                Component.For<Services.Repositories.IApprovedContractRepository>().ImplementedBy<Services.Repositories.ApprovedContractRepository>().LifestyleSingleton(),
                Component.For<IFundingTypeFundingPeriodRepository>().ImplementedBy<FundingTypeFundingPeriodRepository>().LifestyleSingleton(),
                Component.For<IRelatedAllocationEnricher>().ImplementedBy<RelatedAllocationEnricher>().LifestyleSingleton(),
                Component.For<ISiblingContractCheckService>().ImplementedBy<SiblingContractCheckService>().LifestyleScoped(),
                Component.For<ICreatedContractRepository>().ImplementedBy<CreatedContractRepository>().LifestyleSingleton(),
                Component.For<ILastApprovedContractCreationDateService>().ImplementedBy<LastApprovedContractCreationDateService>().LifestyleScoped(),
                Component.For<IContractTypeTransformer>().ImplementedBy<ContractTypeTransformer>().LifestyleSingleton(),
                Component.For<IContractStorage>().ImplementedBy<AzureContractStorage>().LifestyleSingleton(),
                Component.For<IValueVariationService>().ImplementedBy<ValueVariationService>().LifestyleScoped()
            );
        }

        private class OrganizationServiceInstaller : IWindsorInstaller
        {
            public void Install(IWindsorContainer container, IConfigurationStore store)
            {
                container.Register(
                    Component.For<IOrganizationService>().UsingFactoryMethod(k => CrmConnectionFactory.GetOrganizationService()).LifestyleScoped());
            }
        }
    }
}
