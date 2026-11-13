using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OrganisationDomain.Endpoint.Xrm
{

    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.Xrm.Sdk;
    using Repositories;
    using SFA.FCS.Worker.Common.Crm;

    public static class OrganisationXrmServiceRegistration
    {
        public static IServiceCollection AddOrganisationXrmServices(
            this IServiceCollection services)
        {
            // ✅ Scoped (Windsor LifestyleScoped)
            services.AddScoped<IOrganizationService>(_ =>
                CrmConnectionFactory.GetOrganizationService());

            services.AddScoped<IProviderNotificationRepository,
                ProviderNotificationRepository>();

            // ✅ Singleton (Windsor LifestyleSingleton)
            services.AddSingleton<ITeamRepository, TeamRepository>();

            return services;
        }
    }

}
