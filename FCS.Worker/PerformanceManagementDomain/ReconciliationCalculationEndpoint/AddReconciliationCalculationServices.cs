namespace PerformanceManagementDomain.ReconciliationCalculationEndpoint
{

    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.Xrm.Sdk;
    using CrmRepositories;
    using Infrastructure;
    using PerformanceManagementDomain.Services;
    using Services;
    using Repositories;
    using SFA.FCS.Worker.Common.Crm;

    public static class ReconciliationCalculationServiceRegistration
    {
        public static IServiceCollection AddReconciliationCalculationServices(
            this IServiceCollection services)
        {
            // ✅ Infrastructure (Singleton)
            services.AddSingleton<ISessionConnectionFactory, SessionConnectionFactory>();
            services.AddSingleton<IParentDeliverableResolver, ParentDeliverableResolver>();

            // ✅ CRM (Scoped)
            services.AddScoped<IOrganizationService>(_ =>
                CrmConnectionFactory.GetOrganizationService());

            services.AddScoped<ICrmFundingClaimReconciliationRepository,
                CrmFundingClaimReconciliationRepository>();

            // ✅ Core services (Scoped + Transient)
            services.AddScoped<ICalculationService, CalculationService>();
            services.AddScoped<IDeliverableGroupAmountSummaryCreator, DeliverableGroupAmountSummaryCreator>();
            services.AddScoped<IFcrRecalculationRequiredChecker, FcrRecalculationRequiredChecker>();
            services.AddTransient<IFundingClaimDebatchService, FundingClaimDebatchService>();
            services.AddScoped<IFcrUpdateService, FcrUpdateService>();
            services.AddScoped<IFundingClaimEnrichmentService, FundingClaimEnrichmentService>();
            services.AddScoped<IPolicyDeliverableRepository, PolicyDeliverableRepository>();

            services.AddTransient<Repositories.IContractAllocationDeliverableRepository,
                Repositories.ContractAllocationDeliverableRepository>();

            services.AddTransient<Repositories.IClaimReconciliationAllocationGroupFspRepository,
                Repositories.ClaimReconciliationAllocationGroupFspRepository>();

            // ✅ Datastore repositories
            services.AddTransient<Repositories.IFspDeliverableClaimRepository,
                Repositories.FspDeliverableClaimRepository>();

            services.AddTransient<Repositories.IClaimReconciliationAllocationGroupRepository,
                Repositories.ClaimReconciliationAllocationGroupRepository>();

            services.AddScoped<Repositories.IClaimReconciliationBehaviourRepository,
                Repositories.ClaimReconciliationBehaviourRepository>();

            services.AddTransient<Repositories.IClaimTypeRepository,
                Repositories.ClaimTypeRepository>();

            services.AddScoped<Repositories.IContractAllocationRepository,
                Repositories.ContractAllocationRepository>();

            services.AddScoped<Repositories.IClaimReferenceProfileRepository,
                Repositories.ClaimReferenceProfileRepository>();

            services.AddTransient<Repositories.IFundingClaimRepository,
                Repositories.FundingClaimRepository>();

            services.AddTransient<Repositories.IFundingStreamPeriodQueryRepository,
                Repositories.FundingStreamPeriodQueryRepository>();

            return services;
        }
    }


}
