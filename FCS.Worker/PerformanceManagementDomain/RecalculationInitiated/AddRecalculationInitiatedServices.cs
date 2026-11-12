using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PerformanceManagementDomain.RecalculationInitiated
{

    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.Xrm.Sdk;
    using Repositories;
    using SFA.FCS.Worker.Common.Crm;

    public static class RecalculationInitiatedServiceRegistration
    {
        public static IServiceCollection AddRecalculationInitiatedServices(
            this IServiceCollection services)
        {
            // ✅ Scoped (Windsor LifestyleScoped)
            services.AddScoped<IOrganizationService>(_ =>
                CrmConnectionFactory.GetOrganizationService());

            services.AddScoped<IFundingClaimReconciliationRepository,
                FundingClaimReconciliationRepository>();

            return services;
        }
    }

}
