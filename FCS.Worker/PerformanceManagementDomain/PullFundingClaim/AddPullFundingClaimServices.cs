using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PerformanceManagementDomain.PullFundingClaim
{

    using Microsoft.Extensions.Configuration;
    using Microsoft.Extensions.DependencyInjection;
    using Infrastructure;
    using PerformanceManagementDomain.Services;
    using Repositories;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Services;

    public static class PullFundingClaimServiceRegistration
    {
        public static IServiceCollection AddPullFundingClaimServices(
            this IServiceCollection services)
        {
            // ✅ Singleton
            services.AddSingleton<IHttpService, HttpService>();
            services.AddSingleton<IOAuthAccessTokenFactory, OAuthAccessTokenFactory>();
            services.AddSingleton<IAzureTableStore, AzureTableStore>();
            services.AddSingleton<IEnvironmentContext, EnvironmentContext>();
            services.AddSingleton<IFundingClaimImportInfoRepository, FundingClaimImportInfoRepository>();
            services.AddSingleton<ISessionConnectionFactory, SessionConnectionFactory>();
            services.AddSingleton<IClaimReconciliationBehaviourAsyncRepository, ClaimReconciliationBehaviourAsyncRepository>();
            services.AddSingleton<IFundingClaimRepository, FundingClaimRepository>();
            services.AddSingleton<IDateProvider, DateProvider>();
            services.AddSingleton<IClaimReconciliationAllocationGroupFspRepository, ClaimReconciliationAllocationGroupFspRepository>();

            // ✅ Transient
            services.AddTransient<IFundingClaimDebatchService, FundingClaimDebatchService>();

            services.AddTransient<
                ReconciliationCalculationEndpoint.Repositories.IClaimReconciliationAllocationGroupFspRepository,
                ReconciliationCalculationEndpoint.Repositories.ClaimReconciliationAllocationGroupFspRepository>();

            // ✅ ✅ Factory (REPLACES Windsor factory + ConfigurationManager)
            services.AddSingleton<IFundingClaimsApiAdapter>(provider =>
            {
                var config = provider.GetRequiredService<IConfiguration>();

                bool useStub = bool.Parse(
                    config["DCT:FundingClaims:UseStub"] ?? "false");

                if (useStub)
                {
                    return new FundingClaimsApiStubAdapter(
                        provider.GetRequiredService<IAzureTableStore>(),
                        provider.GetRequiredService<IEnvironmentContext>());
                }

                return new FundingClaimsApiAdapter(
                    provider.GetRequiredService<IHttpService>(),
                    provider.GetRequiredService<IOAuthAccessTokenFactory>());
            });

            return services;
        }
    }

}
