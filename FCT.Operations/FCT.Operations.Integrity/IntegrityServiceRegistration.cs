
namespace SFA.FCT.Operations.Integrity
{
    using Microsoft.Extensions.DependencyInjection;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCS.Worker.Common;
    using Microsoft.ApplicationInsights;
    using Services;
    using Repositories;
    using Storage;

    public static class IntegrityServiceRegistration
    {
        public static IServiceCollection AddIntegrityServices(
            this IServiceCollection services,
            ILogger logger,
            IFcsConfiguration appConfiguration)
        {
            // ✅ Instance registrations
            services.AddSingleton(logger);
            services.AddSingleton(appConfiguration);

            // ✅ Transient (IMPORTANT)
            services.AddTransient<IIntegrityCheckRunnerService, IntegrityCheckRunnerService>();

            // ✅ Singleton
            services.AddSingleton<ICheckerDocumentStoreWriter, AzureDocumentStoreWriter>();

            // ✅ Scoped (VERY IMPORTANT - must match Windsor)
            services.AddScoped<ICrmDuplicateContractService, CrmDuplicateContractService>();
            services.AddScoped<ICrmDuplicateContractRepository, CrmDuplicateContractRepository>();
            services.AddScoped<IDuplicateContractRepository, DuplicateContractRepository>();

            // ✅ Instance TelemetryClient (same as Windsor Instance)
            services.AddSingleton(new TelemetryClient());

            return services;
        }
    }
}

