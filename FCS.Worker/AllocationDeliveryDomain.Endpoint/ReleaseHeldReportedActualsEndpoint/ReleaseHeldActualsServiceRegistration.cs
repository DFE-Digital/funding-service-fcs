
namespace AllocationDeliveryDomain.Endpoint.ReleaseHeldReportedActualsEndpoint.IoC
{
    using Microsoft.Extensions.DependencyInjection;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Services;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using ClosedCollectionRepository = SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using Infrastructure;

    public static class ReleaseHeldActualsServiceRegistration
    {
        public static IServiceCollection AddReleaseHeldActualsServices(
            this IServiceCollection services)
        {
            // ✅ Singleton
            services.AddSingleton<ISessionConnectionFactory, SessionConnectionFactory>();
            services.AddSingleton<IAzureRepository<ActualsCollectionTypeSummary>, AzureRepository<ActualsCollectionTypeSummary>>();
            services.AddSingleton<IEnvironmentContext, EnvironmentContext>();

            // ✅ Scoped (Windsor LifestyleScoped)
            services.AddScoped<IHeldReportedActualGroupQueryRepository, HeldReportedActualGroupRepository>();
            services.AddScoped<IHeldReportedActualGroupCommandRepository, HeldReportedActualGroupRepository>();
            services.AddScoped<IClosedCollectionRepository, ClosedCollectionRepository.ClosedCollectionRepository>();
            services.AddScoped<MonitoringDeliverablesDbContext>();
            services.AddScoped<IHeldPartitionKeyQueryService, HeldReportedActualGroupService>();
            services.AddScoped<IHeldFspCollectionConfigRepository, HeldFspCollectionConfigRepository>();
            services.AddScoped<IAzureTableStore, AzureTableStore>();

            return services;
        }
    }
}
