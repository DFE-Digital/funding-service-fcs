namespace ContractCreateDomain.Endpoint.ContractCreated.IoC
{
    using Microsoft.Extensions.DependencyInjection;
    using Services.Repositories;
    using Infrastructure;

    public static class ContractCreatedServiceRegistration
    {
        public static IServiceCollection AddContractCreatedServices(
            this IServiceCollection services)
        {
            // ✅ Singleton (Windsor LifestyleSingleton)
            services.AddSingleton<ISessionConnectionFactory, SessionConnectionFactory>();
            services.AddSingleton<ICreatedContractRepository, CreatedContractRepository>();

            return services;
        }
    }
}
