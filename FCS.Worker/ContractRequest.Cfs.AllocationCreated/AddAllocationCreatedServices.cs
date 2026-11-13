namespace ContractRequest.Cfs.AllocationCreated
{
    using Microsoft.Extensions.DependencyInjection;
    using Infrastructure;
    using Repositories;

    public static class AllocationCreatedServiceRegistration
    {
        public static IServiceCollection AddAllocationCreatedServices(
            this IServiceCollection services)
        {
            // ✅ Scoped (Windsor LifestyleScoped)
            services.AddScoped<ISessionConnectionFactory, SessionConnectionFactory>();
            services.AddScoped<IAllocationNotificationRepository, AllocationNotificationRepository>();

            return services;
        }
    }

}
