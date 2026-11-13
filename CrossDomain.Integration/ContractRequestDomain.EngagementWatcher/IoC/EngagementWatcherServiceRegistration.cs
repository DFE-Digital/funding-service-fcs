namespace SFA.FCT.ContractRequestDomain.EngagementWatcher.IoC
{
    using Microsoft.Extensions.DependencyInjection;
    using System;
    using System.Configuration;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Repositories;
    using ContractRequestDomain.EngagementWatcher.Services;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;
    using Microsoft.Extensions.Logging;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public static class EngagementWatcherServiceRegistration
    {


        public static void AddEngagementWatcherServices(this IServiceCollection services, ILoggerFactory loggerFactory)
        {
            // ============================================================
            // Scoped services (were LifestyleScoped in Windsor)
            // ============================================================
            services.AddScoped<IDasRequestService, DasRequestService>();
            services.AddScoped<IEngagementEventRepository, EngagementEventRepository>();
            services.AddScoped<IContractManagementDbContext, ContractManagementDbContext>();
            services.AddScoped<IFundingTypeFundingPeriodQueryRepository, FundingTypeFundingPeriodQueryRepository>();
            services.AddScoped<ISessionConnectionFactory, SessionConnectionFactory>();

            // ============================================================
            // Singletons (were LifestyleSingleton / Instance in Windsor)
            // ============================================================
            services.AddSingleton(typeof(IEntityCache<,>), typeof(EntityCache<,>));
            services.AddSingleton<IAzureTableStore, AzureTableStore>();
            services.AddSingleton<IEnvironmentContext, EnvironmentContext>();

            // Factory-based registration for IDasEventsApiAdapter
            services.AddSingleton<IDasEventsApiAdapter>(sp =>
            {
                bool useStub = string.Equals(
                    ConfigurationManager.AppSettings["DasEngagements.UseStub"],
                    "true",
                    StringComparison.OrdinalIgnoreCase);

                if (useStub)
                {
                    var tableStore = sp.GetRequiredService<IAzureTableStore>();
                    var envCtx = sp.GetRequiredService<IEnvironmentContext>();
                    return new DasEventsApiAdapterTestImpl(tableStore, envCtx);
                }
                else
                {
                    var tokenFactory = sp.GetRequiredService<IOAuthAccessTokenFactory>();
                    return new DasEventsApiAdapter(tokenFactory);
                }
            });

            services.AddSingleton<IOAuthAccessTokenFactory, OAuthAccessTokenFactory>();

            // Windsor: Component.For<ILogger>().Instance(_loggerFactory.CreateLogger("ContractManagementDomain"))
            services.AddSingleton<ILogger>(
                _ => loggerFactory.CreateLogger("ContractManagementDomain"));

        }
    }
}
