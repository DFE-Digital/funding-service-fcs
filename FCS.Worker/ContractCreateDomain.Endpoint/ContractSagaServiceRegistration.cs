
namespace ContractCreateDomain.Endpoint
{
    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.Xrm.Sdk;
    using SFA.FCS.Worker.Common.Crm;
    using System;

    using Infrastructure;
    using Services;
    using Services.Repositories;

    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Repositories;
    using ContractManagement.DataStore.Services;

    using SFA.FCT.ContractCreateDomain.BusinessLogic;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Services;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation;
    using SFA.FCT.ContractCreateDomain.Implementation;
    using SFA.FCT.ContractCreateDomain.Implementation.Repositories;
    using SFA.FCT.ContractCreateDomain.Implementation.Services;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;

    public static class ContractSagaServiceRegistration
    {
        public static IServiceCollection AddContractSagaServices(
            this IServiceCollection services)
        {
            // ✅ DB Context
            services.AddScoped<IContractManagementDbContext, ContractManagementDbContext>();

            // ✅ Funding / lookup (fully qualified to avoid ambiguity)
            services.AddScoped<
                ContractCreateDomain.Endpoint.Infrastructure.IFundingTypeFundingPeriodQueryRepository,
                ContractCreateDomain.Endpoint.Infrastructure.FundingTypeFundingPeriodQueryRepository>();

            services.AddScoped<IFundingTypePeriodFundingStreamPeriodQueryRepository,
                FundingTypePeriodFundingStreamPeriodQueryRepository>();

            services.AddScoped<
                ContractCreateDomain.Endpoint.Infrastructure.IContractValidationLookupDataCreator,
                ContractCreateDomain.Endpoint.Infrastructure.ContractValidationLookupDataCreator>();

            services.AddScoped<
                ContractCreateDomain.Endpoint.Infrastructure.IContractOperationRules,
                ContractCreateDomain.Endpoint.Infrastructure.ContractOperationRules>();

            // ✅ Business logic (Transient)
            services.AddTransient<IContractRequestTransformer, ContractRequestTransformer>();
            services.AddTransient<IOrganisationMessageEnricher, OrganisationMessageEnricher>(); // ✅ FIXED (no duplicate)
            services.AddTransient<IContractDeliverableEnricher, ContractDeliverableEnricher>();
            services.AddTransient<IFundingStreamConfigService, FundingStreamConfigService>();
            services.AddTransient<IContractValueAggregator, ContractValueAggregator>();
            services.AddTransient<IMasher, Masher>();
            services.AddTransient<IValidator, Validator>();

            // ✅ Organisation / external
            services.AddSingleton<IOrganisationService, OrganisationService>();
            services.AddSingleton<IOrganisationServiceApiHttpClient, OrganisationServiceApiHttpClient>();

            // ✅ Lookup / cache / numbering
            services.AddTransient<ILookupManager, LookupManager>();
            services.AddSingleton<IBatchCacheManager, BatchCacheManager>();
            services.AddSingleton<IEnduringCacheManager, EnduringCacheManager>();
            services.AddTransient<INumberRequestManager, XrmNumberRequestManager>();
            services.AddTransient<INumberPrefixRepository, NumberPrefixRepository>();
            services.AddSingleton<ISequenceRepository, SequenceRepository>();

            // ✅ Contract services
            services.AddTransient<IContractsManager, ContractsManager>();
            services.AddTransient<IXrmOrganisationManager, XrmOrganisationManager>();
            services.AddTransient<IXrmWorkflowManager, XrmWorkflowManager>();
            services.AddScoped <Infrastructure.IFundingTypePeriodService, Infrastructure.FundingTypePeriodService>();
            services.AddScoped<ICheckForContractChangeService, CheckForContractChangeService>();
            services.AddSingleton<ICheckForAllocationChangeService, CheckForAllocationChangeService>();

            // ✅ Contract repositories
            services.AddScoped<IFundingStreamPeriodLegalDeliverableRepository, FundingStreamPeriodLegalDeliverableRepository>();
            services.AddScoped<IPreviousContractMerger, PreviousContractMerger>();
            services.AddScoped<IPreviousContractRepository, PreviousContractRepository>();
            services.AddScoped<ICrmContractQueryRepository, CrmContractQueryRepository>();
            services.AddSingleton<Services.Repositories.IApprovedContractRepository, Services.Repositories.ApprovedContractRepository>();
            services.AddSingleton<IFundingTypeFundingPeriodRepository, FundingTypeFundingPeriodRepository>();
            services.AddSingleton<ICreatedContractRepository, CreatedContractRepository>();

            // ✅ Additional domain logic
            services.AddSingleton<ISiblingApprovedContractService, SiblingApprovedContractService>();
            services.AddScoped<ISiblingContractCheckService, SiblingContractCheckService>();
            services.AddSingleton<IRelatedAllocationEnricher, RelatedAllocationEnricher>();

            services.AddSingleton<IContractTypeTransformer, ContractTypeTransformer>();
            services.AddScoped<IValueVariationService, ValueVariationService>();
            services.AddScoped<ILastApprovedContractCreationDateService, LastApprovedContractCreationDateService>();

            // ✅ Persistence / storage
            services.AddSingleton<ISagaDataStorage, SagaDataStorage>();
            services.AddSingleton<Infrastructure.IProcessedMessageRepository, Infrastructure.ProcessedMessageRepository>();
            services.AddSingleton<IContractStorage, AzureContractStorage>();
            services.AddSingleton<ISessionConnectionFactory, SessionConnectionFactory>();

            // ✅ CRM factory
            services.AddScoped<IOrganizationService>(_ =>
                CrmConnectionFactory.GetOrganizationService());

            return services;
        }
    }
}
