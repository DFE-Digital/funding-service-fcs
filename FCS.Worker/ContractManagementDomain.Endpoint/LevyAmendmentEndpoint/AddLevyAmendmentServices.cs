using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ContractManagementDomain.Endpoint.LevyAmendmentEndpoint
{


    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.Xrm.Sdk;
    using Services;
    using Repositories;
    using Infrastructure;
    using SFA.FCS.Worker.Common.Crm;

    public static class LevyAmendmentServiceRegistration
    {
        public static IServiceCollection AddLevyAmendmentServices(
            this IServiceCollection services)
        {
            // ✅ Scoped (Windsor LifestyleScoped)
            services.AddScoped<IOrganizationService>(_ =>
                CrmConnectionFactory.GetOrganizationService());

            services.AddScoped<IAmendLevyContractService, AmendLevyContractService>();
            services.AddScoped<ICrmContractRepository, CrmContractRepository>();

            // ✅ Singleton (Windsor LifestyleSingleton)
            services.AddSingleton<IRoatpProviderRepository, RoatpProviderRepository>();
            services.AddSingleton<IRoatpApiHttpClient, RoatpApiHttpClient>();
            services.AddSingleton<IRoatpRepositoryService, RoatpRepositoryService>();
            services.AddSingleton<ISessionConnectionFactory, SessionConnectionFactory>();

            return services;
        }
    }

}
