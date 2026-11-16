
namespace FCT.Operations.FundingAllocationExtract
{
    using Microsoft.Extensions.DependencyInjection;
    using Repositories;
    using Infrastructure;
    using FCT.Operations.Repositories;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.Framework.Logging.Interfaces;

    public static class FundingAllocationExtractServiceRegistration
    {
        public static IServiceCollection AddFundingAllocationExtractServices(
            this IServiceCollection services,
            ILogger logger,
            IFcsConfiguration appConfiguration)
        {
            // ✅ Instance registrations (exact match to Windsor)
            services.AddSingleton(logger);
            services.AddSingleton(appConfiguration);

            // ✅ All Windsor LifestyleSingleton equivalents (1:1)
            services.AddSingleton<IWorkbookSharePointRepository, WorkbookSharePointRepository>();
            services.AddSingleton<IExcelGenerator, ExcelGenerator>();
            services.AddSingleton<IFundingAllocationExtractRepository, FundingAllocationExtractRepository>();
            services.AddSingleton<ISessionConnectionFactory, SessionConnectionFactory>();
            services.AddSingleton<IOffice365StorageWrapper, Office365StorageWrapper>();
            services.AddSingleton<IAuthenticationHelper, AuthenticationHelper>();
            services.AddSingleton<ISharepointOAuthAccessTokenFactory, SharepointOAuthAccessTokenFactory>();

            return services;
        }
    }
}

