using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OrganisationDomain.Integration.MainEndpoint.Ioc
{


    using Microsoft.Extensions.DependencyInjection;
    using System;
    using System.Configuration;
    using DataStore;
    using DataStore.Repositories;
    using Implementation.BusinessLogic;
    using Implementation.Converters;
    using Implementation.Mappers;
    using Implementation.Services;
    using OrganisationDomain.Implementation.ExternalServices.Helper;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;

    public static class OrganisationMainServiceRegistration
    {
        public static IServiceCollection AddOrganisationMainServices(
            this IServiceCollection services)
        {
            // ✅ ===== SCOPED =====
            services.AddScoped<IOrganisationRepository, OrganisationRepository>();
            services.AddScoped<IOrgSupplementaryPopulationService, OrgSupplementaryPopulationService>();
            services.AddScoped<IOrgSupplementaryChangeService, OrgSupplementaryChangeService>();
            services.AddScoped<IOrganisationDomainDbContext, OrganisationDomainDbContext>();

            services.AddScoped<Implementation.DataAccess.IOrganisationRepository,
                Implementation.DataAccess.OrganisationRepository>();

            services.AddScoped<IProviderResolver, ProviderResolver>();
            services.AddScoped<IProviderComparer, ProviderComparer>();
             

            // ✅ ===== TRANSIENT =====
            services.AddTransient<GatewayServiceContract>(_ =>
                GatewayServiceClientFactory.Create());

            services.AddTransient<Func<GatewayServiceContract>>(provider =>
                () => provider.GetRequiredService<GatewayServiceContract>());

            // ✅ ===== SINGLETON =====
            services.AddSingleton<IAzureTableStore, AzureTableStore>();
            services.AddSingleton<ICpdsMapper, CpdsMapper>();
            services.AddSingleton<ICpdsXmlValidator, CpdsXmlValidator>();
            services.AddSingleton<ICpdsProviderConverter, CpdsProviderConverter>();

            // ✅ CPDS conditional registration
            var useStubCpds = ConfigurationManager.AppSettings["CPDS:UseStub"] == "true";

            if (useStubCpds)
            {
                services.AddSingleton<ICpdsSummaryRetriever, CpdsStub>();
                services.AddSingleton<ICpdsOrganisationRetriever, CpdsStub>();
            }
            else
            {
                services.AddSingleton<ICpdsSummaryRetriever, CpdsSummaryRetriever>();
                services.AddSingleton<ICpdsOrganisationRetriever, CpdsOrganisationRetriever>();
            }

            // ✅ ✅ REPLACEMENT FOR BOOTSTRAPPER LOGIC
            var useRealUkrlpService =
                Convert.ToBoolean(ConfigurationManager.AppSettings["UseRealUkrlpService"]);

            if (useRealUkrlpService)
            {
                services.AddSingleton<IOrgSupplementaryDataService, OrgSupplementaryDataService>();
            }
            else
            {
                services.AddSingleton<IOrgSupplementaryDataService, OrgSupplementaryDataServiceTestImpl>();
            }

            return services;
        }
    }


}
