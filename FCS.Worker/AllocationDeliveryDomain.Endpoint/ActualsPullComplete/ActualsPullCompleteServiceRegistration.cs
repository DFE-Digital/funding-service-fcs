namespace AllocationDeliveryDomain.Endpoint.ActualsPullComplete
{
    using Microsoft.Extensions.DependencyInjection;
    using ActualsPull.Repositories;
    using Infrastructure;
    using Repositories;

    public static class ActualsPullCompleteServiceRegistration
    {
        public static IServiceCollection AddActualsPullCompleteServices(
            this IServiceCollection services)
        {
            // ✅ Singleton (Windsor LifestyleSingleton equivalent)
            services.AddSingleton<ISessionConnectionFactory, SessionConnectionFactory>();
            services.AddSingleton<IClosedCollectionCompleteRepository, ClosedCollectionRepository>();
            services.AddSingleton<ISummarisedActualsQueryRepository, SummarisedActualsRepository>();

            return services;
        }
    }
}
