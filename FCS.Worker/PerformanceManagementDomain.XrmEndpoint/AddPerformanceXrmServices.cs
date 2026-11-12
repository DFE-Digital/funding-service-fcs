using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PerformanceManagementDomain.XrmEndpoint
{

    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.Xrm.Sdk;
    using Repositories;
    using SFA.FCS.Worker.Common.Crm;

    public static class PerformanceXrmServiceRegistration
    {
        public static IServiceCollection AddPerformanceXrmServices(
            this IServiceCollection services)
        {
            // ✅ Scoped (Windsor LifestyleScoped)
            services.AddScoped<IOrganizationService>(_ =>
                CrmConnectionFactory.GetOrganizationService());

            // ✅ Transient (Windsor LifestyleTransient)
            services.AddTransient<IFundingClaimReconciliationCommandRepository,
                FundingClaimReconciliationCommandRepository>();

            return services;
        }
    }

}
