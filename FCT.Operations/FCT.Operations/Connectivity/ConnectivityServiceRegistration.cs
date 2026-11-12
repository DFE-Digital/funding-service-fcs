
namespace FCT.Operations.Connectivity
{
    using Microsoft.Extensions.DependencyInjection;
    using Infrastructure;
    using Repositories;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.Framework.Logging.Interfaces;

    public static class ConnectivityServiceRegistration
    {
        public static IServiceCollection AddConnectivityServices(
            this IServiceCollection services,
            ILogger logger,
            IFcsConfiguration appConfiguration)
        {
            // ✅ Replace Windsor Instance registrations
            services.AddSingleton(logger);
            services.AddSingleton(appConfiguration);

            // ✅ Replace Windsor LifestyleSingleton
            services.AddSingleton<ISessionConnectionFactory, SessionConnectionFactory>();
            services.AddSingleton<IConnectivityRepository, ConnectivityRepository>();

            return services;
        }
    }
}
