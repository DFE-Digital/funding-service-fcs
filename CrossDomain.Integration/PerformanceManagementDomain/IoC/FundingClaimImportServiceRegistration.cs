
namespace SFA.FCT.PerformanceManagementDomain.IoC
{
    using System;
    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.Extensions.Logging;
    using SFA.FCT.PerformanceManagementDomain.Common.Repositories;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Repositories;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Repositories.Atom;
    using SFA.FCT.PerformanceManagementDomain.FundingClaimImportEndpoint.Services;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.OverrideDate;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore;

    public static class FundingClaimImportServiceRegistration
    {
        public static IServiceCollection AddFundingClaimImportServices(
            this IServiceCollection services,
            ILoggerFactory loggerFactory)
        {
            // ✅ REMOVE custom ILogger registration
            // Use ILogger<T> everywhere instead

            // ---------------------------------------------
            // Repositories & Services
            // ---------------------------------------------
            services.AddTransient<IFundingClaimReconciliationQueryRepository, FundingClaimReconciliationQueryRepository>();
            services.AddTransient<IFundingClaimDebatchService, FundingClaimDebatchService>();
            services.AddTransient<IFundingClaimRepository, FundingClaimRepository>();
            services.AddTransient<IFundingClaimCollectionImportInfoRepository, FundingClaimCollectionImportInfoRepository>();
            services.AddTransient<IFspDeliverableClaimRepository, FspDeliverableClaimRepository>();
            services.AddScoped<IClaimReconciliationAllocationGroupFspRepository, ClaimReconciliationAllocationGroupFspRepository>();
            services.AddTransient<IClaimReconciliationAllocationGroupRepository, ClaimReconciliationAllocationGroupRepository>();
            services.AddTransient<IContractAllocationDeliverableRepository, ContractAllocationDeliverableRepository>();
            services.AddScoped<IClaimReconciliationBehaviourRepository, ClaimReconciliationBehaviourRepository>();
            services.AddTransient<IClaimTypeRepository, ClaimTypeRepository>();
            services.AddScoped<IContractAllocationRepository, ContractAllocationRepository>();
            services.AddTransient<IDedsSearchProxyServiceChannelFactory, DedsSearchProxyServiceChannelFactory>();
            services.AddSingleton<IFundingClaimDedsService, FundingClaimDedsService>();

            // ---------------------------------------------
            // DbContexts
            // ---------------------------------------------
            services.AddScoped<IPerformanceManagementDbContext, PerformanceManagementDbContext>();
            services.AddScoped<IPaymentManagementPolicyContext, PaymentManagementPolicyContext>();
            services.AddScoped<IOverrideDateDBContext, OverrideDateDBContext>();

            // ---------------------------------------------
            // Atom
            // ---------------------------------------------
            services.AddScoped<IAtomFeedItemQueryRepository, AtomFeedItemQueryRepository>();
            services.AddScoped<IClaimReferenceProfileRepository, ClaimReferenceProfileRepository>();

            // ---------------------------------------------
            // Funding stream
            // ---------------------------------------------
            services.AddScoped<IFundingStreamPeriodQueryRepository, FundingStreamPeriodQueryRepository>();

            // ---------------------------------------------
            // Filter
            // ---------------------------------------------
            services.AddScoped<IFundingClaimAllocationFilter, FundingClaimAllocationFilter>();

            // ---------------------------------------------
            // Date provider (modernised)
            // ---------------------------------------------
            var useRealDate = Convert.ToBoolean(
                Environment.GetEnvironmentVariable("UseRealDate") ?? "false");

            if (useRealDate)
                services.AddSingleton<IDate, SystemDate>();
            else
                services.AddScoped<IDate, StaticDate>();

            return services;
        }
    }
}
