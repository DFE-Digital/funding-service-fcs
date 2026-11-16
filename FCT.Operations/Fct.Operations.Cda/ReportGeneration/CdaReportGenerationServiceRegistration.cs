
namespace FCT.Operations.Cda.ReportGeneration
{
    using Microsoft.Extensions.DependencyInjection;
    using Infrastructure;
    using ReportUpload;
    using Repositories;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCS.Worker.Common;

    public static class CdaReportGenerationServiceRegistration
    {
        public static IServiceCollection AddCdaReportGenerationServices(
            this IServiceCollection services,
            ILogger logger,
            IFcsConfiguration configuration)
        {
            // ✅ Instance registrations (exact Windsor match)
            services.AddSingleton(logger);
            services.AddSingleton(configuration);

            // ✅ All Windsor LifestyleSingleton mappings (1:1)

            services.AddSingleton<IAuthenticationHelper, AuthenticationHelper>();
            services.AddSingleton<ISharepointOAuthAccessTokenFactory, SharepointOAuthAccessTokenFactory>();
            services.AddSingleton<ICrmCdaRepository, CrmCdaRepository>();
            services.AddSingleton<ICdaConfigRepository, CdaConfigRepository>();
            services.AddSingleton<ISessionConnectionFactory, SessionConnectionFactory>();
            services.AddSingleton<IOverrideDateRepository, OverrideDateRepository>();
            services.AddSingleton<IArchiveFolderCreator, ArchiveFolderCreator>();
            services.AddSingleton<IOffice365StorageWrapper, Office365StorageWrapper>();
            services.AddSingleton<IProcessedMessageRepository, ProcessedMessageRepository>();
            services.AddSingleton<IReportUploadService, ReportUploadService>();
            services.AddSingleton<IReportCreationService, ReportCreationService>();
            services.AddSingleton<IClosedContractRepository, ClosedContractRepository>();
            services.AddSingleton<IClosedReportService, ClosedReportService>();

            return services;
        }
    }
}

