
namespace AllocationDeliveryDomain.Endpoint.ContractTerminationEndpoint.IoC
{
    using Microsoft.Extensions.DependencyInjection;
    using Infrastructure;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;

    public static class ContractTerminationServiceRegistration
    {
        public static IServiceCollection AddContractTerminationServices(
            this IServiceCollection services)
        {
            // ✅ Singleton
            services.AddSingleton<ISessionConnectionFactory, SessionConnectionFactory>();

            // ✅ Scoped (Windsor LifestyleScoped)
            services.AddScoped<IMonitoringDeliverablesDbContext, MonitoringDeliverablesDbContext>();
            services.AddScoped<IInactiveAllocationRepository, InactiveAllocationRepository>();

            return services;
        }
    }
}
