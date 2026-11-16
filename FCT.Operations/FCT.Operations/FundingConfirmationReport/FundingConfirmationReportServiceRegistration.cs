
namespace FCT.Operations.FundingConfirmationReport
{
    using Microsoft.Extensions.DependencyInjection;
    using Infrastructure;
    using Operations.Repositories;
    using Repositories;
    using Services;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.Framework.Logging.Interfaces;

    public static class FundingConfirmationReportServiceRegistration
    {
        public static IServiceCollection AddFundingConfirmationReportServices(
            this IServiceCollection services,
            ILogger logger,
            IFcsConfiguration appConfiguration)
        {
            // ✅ Instance registrations (exact Windsor equivalent)
            services.AddSingleton(logger);
            services.AddSingleton(appConfiguration);

            // ✅ LifestyleSingleton mappings (1:1)

            services.AddSingleton<ISessionConnectionFactory, SessionConnectionFactory>();
            services.AddSingleton<IExcelReportGenerator, ExcelGeneratorFundingConfirmationReport>();
            services.AddSingleton<IReportService, ReportService>();
            services.AddSingleton<IlaReportService, LAReportService>();
            services.AddSingleton<IFundingConfirmationReportRepository, FundingConfirmationReportRepository>();
            services.AddSingleton<ILAFundingConfirmationReportRepository, LAFundingConfirmationReportRepository>();
            services.AddSingleton<IWorkbookSharePointRepository, WorkbookSharePointRepository>();
            services.AddSingleton<IOffice365StorageWrapper, Office365StorageWrapper>();
            services.AddSingleton<IAuthenticationHelper, AuthenticationHelper>();
            services.AddSingleton<ISharepointOAuthAccessTokenFactory, SharepointOAuthAccessTokenFactory>();

            return services;
        }
    }
}
