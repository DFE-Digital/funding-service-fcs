
namespace SFA.FCT.AllocationDeliveryDomain.MDEnrich.Endpoint.Ioc
{
    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.Extensions.Logging;
    using SFA.FCT.AllocationDeliveryDomain.MDEnrich.BusinessLogic;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.MDEnrich.Infrastructure;
    using Common.DataStore;

    public static class ComponentServiceRegistration
    {
        public static void AddAllocationDeliveryServices(
            this IServiceCollection services,
            ILoggerFactory loggerFactory)
        {
            // ✅ REMOVE custom ILogger registration

            // ---------------------------------------------
            // Transient
            // ---------------------------------------------
            services.AddTransient<IContractAllocationTransformer, ContractAllocationTransformer>();
            services.AddTransient<IMonitoringDeliverableStore, MonitoringDeliverableStore>();
            services.AddTransient<IMonitoringDeliverableEnrichment, MonitoringDeliverableEnrichment>();

            // ---------------------------------------------
            // Scoped
            // ---------------------------------------------
            services.AddScoped<IMonitoringDeliverablesDbContext, MonitoringDeliverablesDbContext>();
            services.AddScoped<IInactiveAllocationRepository, InactiveAllocationRepository>();

            // ---------------------------------------------
            // Singleton
            // ---------------------------------------------
            services.AddSingleton<ISessionConnectionFactory, SessionConnectionFactory>();
        }
    }
}
