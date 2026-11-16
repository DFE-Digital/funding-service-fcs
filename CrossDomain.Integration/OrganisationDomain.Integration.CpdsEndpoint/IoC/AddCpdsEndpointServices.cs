using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OrganisationDomain.Integration.CpdsEndpoint.IoC
{

    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.Extensions.Configuration;
    using Implementation.BusinessLogic;
    using Implementation.Converters;
    using Implementation.Mappers;
    using OrganisationDomain.Implementation.ExternalServices.Helper;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.Framework.Logging.Interfaces;

    public static class CpdsEndpointServiceRegistration
    {
        public static IServiceCollection AddCpdsEndpointServices(
            this IServiceCollection services)
        {
            // ✅ Configuration (supports app.config or json)
            services.AddSingleton(provider =>
                provider.GetRequiredService<IConfiguration>());

            // ✅ Options wrapper (FIX for bool issue)
            services.AddSingleton<CPDSOptions>(provider =>
            {
                var config = provider.GetRequiredService<IConfiguration>();

                // Supports BOTH app.config + appsettings.json
                string value = config["CPDS:UseStub"]
                               ?? System.Configuration.ConfigurationManager.AppSettings["CPDS:UseStub"];

                return new CPDSOptions
                {
                    UseStub = value == "true"
                };
            });

            // ✅ Gateway factory
            services.AddTransient<GatewayServiceContract>(_ =>
                GatewayServiceClientFactory.Create());

            // ✅ Core dependencies
            services.AddSingleton<ICpdsProviderConverter, CpdsProviderConverter>();
            services.AddSingleton<ICpdsMapper, CpdsMapper>();
            services.AddSingleton<ICpdsXmlValidator, CpdsXmlValidator>();

            // ✅ Storage
            services.AddSingleton<IAzureTableStore, AzureTableStore>();

            // ✅ CPDS Organisation Retriever (FIXED)
            services.AddSingleton<ICpdsOrganisationRetriever>(provider =>
            {
                var options = provider.GetRequiredService<CPDSOptions>();
                var loggerFactory = provider.GetRequiredService<ILoggerFactory>();
                var logger = loggerFactory.CreateLogger("OrganisationDomainCpdsEndpoint");

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
                var logger = loggerFactory.CreateLogger("OrganisationDomainCpdsEndpoint");

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

            return services;
        }
    }

    // ✅ Fix for bool issue
    public class CPDSOptions
    {
        public bool UseStub { get; set; }
    }

}
