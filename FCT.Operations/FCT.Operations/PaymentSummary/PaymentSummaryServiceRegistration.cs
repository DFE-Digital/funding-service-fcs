
namespace FCT.Operations.PaymentSummary
{
    using Microsoft.Extensions.DependencyInjection;
    using FCT.Operations.Repositories;
    using Infrastructure;
    using Repositories;
    using Services;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.Operations.Common.Repositories;

    public static class PaymentSummaryServiceRegistration
    {
        public static IServiceCollection AddPaymentSummaryServices(
            this IServiceCollection services,
            ILogger logger,
            IFcsConfiguration appConfiguration)
        {
            // ✅ Instance registrations (exact Windsor equivalent)
            services.AddSingleton(logger);
            services.AddSingleton(appConfiguration);

            // ✅ All LifestyleSingleton registrations (1:1 mapping)

            services.AddSingleton<IOverrideDateRepository, OverrideDateRepository>();
            services.AddSingleton<ISessionConnectionFactory, SessionConnectionFactory>();
            services.AddSingleton<IPaymentSummaryReportService, PaymentSummaryReportService>();
            services.AddSingleton<IPaymentLineSummaryRepository, PaymentLineSummaryRepository>();
            services.AddSingleton<IExcelGenerator, ExcelGenerator>();
            services.AddSingleton<IWorkbookStorageRepository, WorkbookStorageRepository>();
            services.AddSingleton<IFundingStreamPeriodCensusDateRepository, FundingStreamPeriodCensusDateRepository>();
            services.AddSingleton<IWorkbookSharePointRepository, WorkbookSharePointRepository>();
            services.AddSingleton<IOffice365StorageWrapper, Office365StorageWrapper>();
            services.AddSingleton<IAuthenticationHelper, AuthenticationHelper>();
            services.AddSingleton<ISharepointOAuthAccessTokenFactory, SharepointOAuthAccessTokenFactory>();

            return services;
        }
    }
}
