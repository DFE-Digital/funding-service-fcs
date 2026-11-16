
namespace SFA.FCT.Operations.Maintenance.Endpoint
{
    using Common.Services;
    using Microsoft.Extensions.DependencyInjection;
    using Repositories;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.Operations.Maintenance.Endpoint.Services;

    public static class MaintenanceServiceRegistration
    {
        public static IServiceCollection AddMaintenanceServices(
            this IServiceCollection services,
            ILogger logger,
            IFcsConfiguration appConfiguration)
        {
            // ✅ Instance registrations
            services.AddSingleton(logger);
            services.AddSingleton(appConfiguration);

            // ✅ IMPORTANT: Single implementation for multiple interfaces
            services.AddSingleton<AzureServiceBusQueueService>();

            services.AddSingleton<IAzureServiceBusQueueService>(sp =>
                sp.GetRequiredService<AzureServiceBusQueueService>());

            services.AddSingleton<IQueueQueryService>(sp =>
                (IQueueQueryService)sp.GetRequiredService<AzureServiceBusQueueService>());

            // ✅ Remaining registrations (1:1 mapping)

            services.AddSingleton<ICrmReplicaRepository, CrmReplicaRepository>();
            services.AddSingleton<ICrmReplicaRowDeleteRepository, CrmReplicaRowDeleteRepository>();
            services.AddSingleton<ISchemaQueryRepository, SchemaQueryRepository>();
            services.AddSingleton<IProcessedMessageDeleteRepository, ProcessedMessageDeleteRepository>();
            services.AddSingleton<IAuditMessageDeleteRepository, AuditMessageDeleteRepository>();

            return services;
        }
    }
}
