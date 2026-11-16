namespace ContractCreateDomain.IncrementContractVersionEndpoint.IoC
{
    using ContractCreateDomain.IncrementContractVersionEndpoint.Repositories;
    using ContractCreateDomain.IncrementContractVersionEndpoint.Services;
    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.ContractCreateDomain.BusinessLogic;
    using SFA.FCT.ContractCreateDomain.Implementation.Repositories;
    using SFA.FCT.ContractCreateDomain.Implementation.Services;
    using Infrastructure;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;


    public static class IncrementContractVersionServiceRegistration
    {
        public static IServiceCollection AddIncrementContractVersionServices(
            this IServiceCollection services)
        {
            // ✅ Scoped (Windsor LifestyleScoped)
            services.AddScoped<IContractsManager, ContractsManager>();
            services.AddScoped<IContractDeliverableEnricher, ContractDeliverableEnricher>();
            services.AddScoped<IFundingStreamConfigService, FundingStreamConfigService>();
            services.AddScoped<IContractRequestTransformer, ContractRequestTransformer>();
            services.AddScoped<IFundingTypePeriodService, FundingTypePeriodService>();
            services.AddScoped<IContractVersionIncrementService, ContractVersionIncrementService>();
            services.AddScoped<ISiblingApprovedContractService, SiblingApprovedContractService>();
            services.AddScoped<IApprovedContractRepository, ApprovedContractRepository>();
            services.AddScoped<ILevyContractAllocationService, LevyContractAllocationService>();
            services.AddScoped<IFundingStreamPeriodRepository, FundingStreamPeriodRepository>();
            services.AddScoped<IAllocationNumberRepository, AllocationNumberRepository>();
            services.AddScoped<ICrmContractRepository, CrmContractRepository>();

            // ✅ Singleton (Windsor LifestyleSingleton)
            services.AddSingleton<IFundingTypeFundingPeriodQueryRepository, FundingTypeFundingPeriodQueryRepository>();
            services.AddSingleton<IContractValueAggregator, ContractValueAggregator>();
            services.AddSingleton<IContractStorage, AzureContractStorage>();
            services.AddSingleton<IFundingTypeFundingPeriodRepository, FundingTypeFundingPeriodRepository>();
            services.AddSingleton<ISessionConnectionFactory, SessionConnectionFactory>();
            services.AddSingleton<ISequenceRepository, SequenceRepository>();
            services.AddSingleton<ICreatedContractRepository, CreatedContractRepository>();

            // ✅ CRM factory
            services.AddScoped<IOrganizationService>(_ =>
                CrmConnectionFactory.GetOrganizationService());

            return services;
        }
    }

}
