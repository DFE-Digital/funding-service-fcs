using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ContractManagementDomain.Endpoint.ReleaseForReview
{
    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.Xrm.Sdk;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;

    public static class ReleaseForReviewServiceRegistration
    {
        public static IServiceCollection AddReleaseForReviewServices(
            this IServiceCollection services)
        {
            // ✅ CRM
            services.AddScoped<IOrganizationService>(_ =>
                CrmConnectionFactory.GetOrganizationService());

            // ✅ Domain service
            services.AddScoped<IContractsManager, ContractsManager>();

            return services;
        }
    }

}
