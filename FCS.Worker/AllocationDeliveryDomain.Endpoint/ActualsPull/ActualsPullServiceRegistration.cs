
namespace AllocationDeliveryDomain.Endpoint.ActualsPull.IoC
{
    using System;
    using Microsoft.Extensions.DependencyInjection;
    using Adapters;
    using Endpoint.Repositories;
    using Infrastructure;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;

    public static class ActualsPullServiceRegistration
    {
        public static IServiceCollection AddActualsPullServices(
            this IServiceCollection services)
        {
            // ✅ Singleton (Windsor LifestyleSingleton)
            services.AddSingleton<ISessionConnectionFactory, SessionConnectionFactory>();

            services.AddSingleton<IAzureTableStore, AzureTableStore>();
            services.AddSingleton<IEnvironmentContext, EnvironmentContext>();
            services.AddSingleton<IClosedCollectionRepository, ClosedCollectionRepository>();
            services.AddSingleton<ISummarisedActualsRepository, SummarisedActualsRepository>();
            services.AddSingleton<IMonthEndStartRepository, MonthEndHistoryRepository>();

            services.AddSingleton<IOAuthAccessTokenFactory, OAuthAccessTokenFactory>();
            services.AddSingleton<IHttpService, HttpService>();

            // ✅ Factory replacement for Windsor UsingFactoryMethod
            services.AddSingleton<IDcAdapter>(provider =>
            {
                var useStub = Convert.ToBoolean(
                    Environment.GetEnvironmentVariable("DCT__UseStub") ?? "false");

                if (useStub)
                {
                    return new DcStubAdapter(
                        provider.GetRequiredService<IAzureTableStore>(),
                        provider.GetRequiredService<IEnvironmentContext>());
                }

                return new DcAdapter(
                    provider.GetRequiredService<IHttpService>(),
                    provider.GetRequiredService<IOAuthAccessTokenFactory>());
            });

            return services;
        }
    }
}
