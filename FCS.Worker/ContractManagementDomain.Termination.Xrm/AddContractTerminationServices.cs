using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ContractManagementDomain.Termination.Xrm
{
    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.Xrm.Sdk;
    using Repositories;
    using SFA.FCS.Worker.Common.Crm;

    public static class ContractTerminationServiceRegistration
    {
        public static IServiceCollection AddContractTerminationServices(
            this IServiceCollection services)
        {
            // ✅ Scoped (Windsor LifestyleScoped)
            services.AddScoped<IOrganizationService>(_ =>
                CrmConnectionFactory.GetOrganizationService());

            services.AddScoped<ICrmContractRepository, CrmContractRepository>();

            return services;
        }
    }

}
