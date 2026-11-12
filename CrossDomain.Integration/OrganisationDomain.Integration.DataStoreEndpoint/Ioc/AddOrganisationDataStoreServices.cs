using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OrganisationDomain.Integration.DataStoreEndpoint.Ioc
{

    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.Extensions.Configuration;
    using DataStore;
    using Implementation.BusinessLogic;
    using Implementation.Converters;
    using Implementation.Mappers;
    using OrganisationDomain.Implementation.ExternalServices.Helper;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;

    public static class OrganisationDataStoreServiceRegistration
    {
        public static IServiceCollection AddOrganisationDataStoreServices(
            this IServiceCollection services)
        {
            // ✅ Config flag (DO NOT register bool directly)
            services.AddSingleton<CPDSOptions>(provider =>
            {
                var config = provider.GetRequiredService<IConfiguration>();
                return new CPDSOptions
                {
                    UseStub = config["CPDS:UseStub"] == "true"
                };
            });

            // ✅ Gateway factory
            services.AddTransient<GatewayServiceContract>(_ =>
                GatewayServiceClientFactory.Create());

            services.AddTransient<Func<GatewayServiceContract>>(provider =>
                () => provider.GetRequiredService<GatewayServiceContract>());

            // ✅ Core dependencies
            services.AddSingleton<ICpdsMapper, CpdsMapper>();
            services.AddSingleton<ICpdsXmlValidator, CpdsXmlValidator>();
            services.AddSingleton<ICpdsProviderConverter, CpdsProviderConverter>();

            // ✅ CPDS Organisation Retriever (FIXED)
            services.AddSingleton<ICpdsOrganisationRetriever>(provider =>
            {
                var options = provider.GetRequiredService<CPDSOptions>();
                var loggerFactory = provider.GetRequiredService<ILoggerFactory>();
                var logger = loggerFactory.CreateLogger("OrganisationDomainDataStoreEndpoint");

                if (options.UseStub)
                {
                    return new CpdsStub(
                        logger,
                        provider.GetRequiredService<IAzureTableStore>(),
                        provider.GetRequiredService<ICpdsProviderConverter>());
                }

                return new CpdsOrganisationRetriever(
                    logger,
                    provider.GetRequiredService<GatewayServiceContract>(),
                    provider.GetRequiredService<ICpdsMapper>(),
                    provider.GetRequiredService<ICpdsXmlValidator>());
            });

            // ✅ CPDS Summary Retriever (FIXED)
            services.AddSingleton<ICpdsSummaryRetriever>(provider =>
            {
                var options = provider.GetRequiredService<CPDSOptions>();
                var loggerFactory = provider.GetRequiredService<ILoggerFactory>();
                var logger = loggerFactory.CreateLogger("OrganisationDomainDataStoreEndpoint");

                if (options.UseStub)
                {
                    return new CpdsStub(
                        logger,
                        provider.GetRequiredService<IAzureTableStore>(),
                        provider.GetRequiredService<ICpdsProviderConverter>());
                }

                return new CpdsSummaryRetriever(
                    provider.GetRequiredService<GatewayServiceContract>(),
                    provider.GetRequiredService<ICpdsProviderConverter>(),
                    logger);
            });

            // ✅ Scoped services
            services.AddScoped<IOrganisationDomainDbContext, OrganisationDomainDbContext>();
            services.AddScoped<Implementation.DataAccess.IOrganisationRepository,
                Implementation.DataAccess.OrganisationRepository>();

            services.AddScoped<IProviderResolver, ProviderResolver>();
            services.AddScoped<IProviderComparer, ProviderComparer>();

            return services;
        }
    }

    // ✅ Helper class instead of bool
    public class CPDSOptions
    {
        public bool UseStub { get; set; }
    }


}
