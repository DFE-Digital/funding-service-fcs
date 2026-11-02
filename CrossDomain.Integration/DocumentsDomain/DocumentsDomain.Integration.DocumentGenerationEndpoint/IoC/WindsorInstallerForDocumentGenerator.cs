namespace SFA.FCT.DocumentsDomain.Integration.DocumentGenerationEndpoint.IoC
{
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Repositories;
    using CrossDomain.Integration.Entities.Data;
    using DataStore;
    using DataStore.Repositories;
    using DocumentGeneration;
    using DocumentGeneration.DocumentCreator;
    using DocumentGeneration.DocumentDefiner;
    using DocumentGeneration.DocumentDefiner.DocumentConfiguration;
    using DocumentGeneration.DocumentLocationResolver;
    using DocumentGeneration.DocumentMerger;
    using DocumentGeneration.Infrastructure;
    using DocumentGeneration.Repositories;
    using DocumentGeneration.Services;
    using Framework.Logging.Interfaces;
    using Integration;
    using PaymentManagementDomain.PolicyCache.DataStore;
    using PaymentManagementDomain.PolicyCache.DataStore.Repositories;
    using AzureStorageWrapper = Integration.AzureStorageWrapper;
    using IProcessedMessageRepository = DataStore.Repositories.IProcessedMessageRepository;

    public class WindsorInstallerForDocumentGenerator : IWindsorInstaller
    {
        private static IWindsorContainer _container;
        private readonly ILoggerFactory _loggerFactory;

        public WindsorInstallerForDocumentGenerator(ILoggerFactory loggerFactory)
        {
            _loggerFactory = loggerFactory;
        }

        internal static IWindsorContainer Container => _container;

        public void Install(IWindsorContainer container, IConfigurationStore store)
        {
            _container = container;

            container.Register(
                Classes.FromThisAssembly().BasedOn<DocumentPartCreator>().WithService.FromInterface().WithService.Self().LifestyleScoped(),
                Classes.FromThisAssembly().BasedOn<IDocumentHeaderCreator>().WithService.FromInterface().LifestyleSingleton(),
                Component.For<IDocumentGenerator>().ImplementedBy<DocumentGenerator>().LifestyleScoped(),
                Component.For<ICorporateContractValidator>().ImplementedBy<CorporateContractValidator>().LifestyleSingleton(),
                Component.For<IDocumentDefiner>().ImplementedBy<DocumentDefiner>().LifestyleScoped(),
                Component.For<IDocumentCreator>().ImplementedBy<DocumentCreator>().LifestyleSingleton(),
                Component.For<IDocumentLocationResolver>().ImplementedBy<DocumentLocationResolver>().LifestyleSingleton(),
                Component.For<IDocumentMerger>().ImplementedBy<DocumentMerger>().LifestyleSingleton(),
                Component.For<IDocumentPartFinder>().ImplementedBy<DocumentPartFinder>().LifestyleSingleton(),
                Component.For<ITemplateRepository>().ImplementedBy<TemplateRepository>().LifestyleSingleton(),
                Component.For<IAsposeWrapper>().ImplementedBy<AsposeWrapper>().LifestyleSingleton(),
                Component.For<IAzureStorageWrapper>().ImplementedBy<AzureStorageWrapper>().LifestyleSingleton(),
                Component.For<IDocumentConfigurationSource>().ImplementedBy<DocumentConfigurationSource>().LifestyleScoped(),
                Component.For<IContractManagementDbContext>().ImplementedBy<ContractManagementDbContext>().LifestyleScoped(),
                Component.For<IPaymentManagementPolicyContext>().ImplementedBy<PaymentManagementPolicyContext>().LifestyleScoped(),
                Component.For<IFundingTypeFundingPeriodQueryRepository>().ImplementedBy<FundingTypeFundingPeriodQueryRepository>().LifestyleScoped(),
                Component.For(typeof(IEntityCache<,>)).ImplementedBy(typeof(EntityCache<,>)).LifestyleSingleton(),
                Component.For<DocumentsDomainDbContext>().ImplementedBy<DocumentsDomainDbContext>().LifestyleScoped(),
                Component.For<IFundingStreamPeriodRepository>().ImplementedBy<FundingStreamPeriodRepository>().LifestyleScoped(),
                Component.For<IFspDeliverableRepository>().ImplementedBy<FspDeliverableRepository>().LifestyleScoped(),
                Component.For<IContractDocumentTemplateRepository>().ImplementedBy<ContractDocumentTemplateRepository>().LifestyleScoped(),
                Component.For<IPayCalcPolicyQueryRepository>().ImplementedBy<PayCalcPolicyQueryRepository>().LifestyleScoped(),
                Component.For<IFundingTypeFundingPeriodContractTypeRepository>().ImplementedBy<FundingTypeFundingPeriodContractTypeRepository>().LifestyleScoped(),
                Component.For<IFspGroupDocumentTemplateRepository>().ImplementedBy<FspGroupDocumentTemplateRepository>().LifestyleScoped(),
                Component.For<IFundingTypeFundingPeriodRepository>().ImplementedBy<FundingTypeFundingPeriodRepository>().LifestyleScoped(),
                Component.For<INlapFundingConfigRepository>().ImplementedBy<NlapFundingConfigRepository>().LifestyleScoped(),
                Component.For<ILogger>().Instance(_loggerFactory.CreateLogger("DocumentsDomain")),
                Component.For<ITemplateVersionChecker>().ImplementedBy<TemplateVersionChecker>().LifestyleScoped(),
                Component.For<IUploadedDocumentTemplateQueryRepository>().ImplementedBy<UploadedDocumentTemplateRepository>().LifestyleScoped(),
                Component.For<IProcessedMessageRepository>().ImplementedBy<DataStore.Repositories.ProcessedMessageRepository>().LifestyleScoped(),
                Component.For<IContractReferenceConfigRepository>().ImplementedBy<ContractReferenceConfigRepository>().LifestyleScoped(),
                Component.For<ISessionConnectionFactory>().ImplementedBy<SessionConnectionFactory>().LifestyleSingleton()
            );
        }
    }
}
