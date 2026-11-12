namespace SFA.FCT.DocumentsDomain.Integration.DocumentGenerationEndpoint.IoC
{

    using Microsoft.Extensions.DependencyInjection;
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
    using Microsoft.Extensions.Logging;
    using Integration;
    using PaymentManagementDomain.PolicyCache.DataStore;
    using PaymentManagementDomain.PolicyCache.DataStore.Repositories;
    using AzureStorageWrapper = Integration.AzureStorageWrapper;
    using IProcessedMessageRepository = DataStore.Repositories.IProcessedMessageRepository;


    public static class DocumentGeneratorServiceRegistration
    {
        public static void AddDocumentGeneratorServices(
            this IServiceCollection services,
            ILoggerFactory loggerFactory)
        {
            // ------------------------------------------------------
            // LOGGER INSTANCE (equivalent to Windsor Instance(logger))
            // ------------------------------------------------------
            services.AddSingleton<ILogger>(_ =>
                loggerFactory.CreateLogger("DocumentsDomain"));

            // ------------------------------------------------------
            // LIFESTYLE SCOPED SERVICES
            // ------------------------------------------------------
            services.AddScoped<DocumentPartCreator>(); // Self + interface (if needed)
            services.AddScoped<IDocumentConfigurationSource, DocumentConfigurationSource>();
            services.AddScoped<IContractManagementDbContext, ContractManagementDbContext>();
            services.AddScoped<IPaymentManagementPolicyContext, PaymentManagementPolicyContext>();
            services.AddScoped<IFundingTypeFundingPeriodQueryRepository, FundingTypeFundingPeriodQueryRepository>();
            services.AddScoped<DocumentsDomainDbContext, DocumentsDomainDbContext>();
            services.AddScoped<IFundingStreamPeriodRepository, FundingStreamPeriodRepository>();
            services.AddScoped<IFspDeliverableRepository, FspDeliverableRepository>();
            services.AddScoped<IContractDocumentTemplateRepository, ContractDocumentTemplateRepository>();
            services.AddScoped<IPayCalcPolicyQueryRepository, PayCalcPolicyQueryRepository>();
            services.AddScoped<IFundingTypeFundingPeriodContractTypeRepository, FundingTypeFundingPeriodContractTypeRepository>();
            services.AddScoped<IFspGroupDocumentTemplateRepository, FspGroupDocumentTemplateRepository>();
            services.AddScoped<IFundingTypeFundingPeriodRepository, FundingTypeFundingPeriodRepository>();
            services.AddScoped<INlapFundingConfigRepository, NlapFundingConfigRepository>();
            services.AddScoped<IUploadedDocumentTemplateQueryRepository, UploadedDocumentTemplateRepository>();
            services.AddScoped<IProcessedMessageRepository, DataStore.Repositories.ProcessedMessageRepository>();
            services.AddScoped<IContractReferenceConfigRepository, ContractReferenceConfigRepository>();
            services.AddScoped<ITemplateVersionChecker, TemplateVersionChecker>();
            services.AddScoped<IDocumentConfigurationSource, DocumentConfigurationSource>();

            // IDocumentGenerator (scoped)
            services.AddScoped<IDocumentGenerator, DocumentGenerator>();

            // ------------------------------------------------------
            // LIFESTYLE SINGLETON SERVICES
            // ------------------------------------------------------
            services.AddSingleton<IDocumentCreator, DocumentCreator>();
            services.AddSingleton<IDocumentLocationResolver, DocumentLocationResolver>();
            services.AddSingleton<IDocumentMerger, DocumentMerger>();
            services.AddSingleton<IDocumentPartFinder, DocumentPartFinder>();
            services.AddSingleton<ITemplateRepository, TemplateRepository>();
            services.AddSingleton<IAsposeWrapper, AsposeWrapper>();
            services.AddSingleton<IAzureStorageWrapper, AzureStorageWrapper>();
            services.AddSingleton<ISessionConnectionFactory, SessionConnectionFactory>();

            // ------------------------------------------------------
            // OPEN GENERIC from Windsor: IEntityCache<,> → EntityCache<,>
            // ------------------------------------------------------
            services.AddSingleton(typeof(IEntityCache<,>), typeof(EntityCache<,>));
        }
    }


}
