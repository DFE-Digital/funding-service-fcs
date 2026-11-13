using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ContractManagementDomain.Endpoint.Xrm.ContractClosure
{

    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.Xrm.Sdk;
    using Repositories;
    using Services;
    using SFA.FCS.Worker.Common.Crm;

    public static class ContractClosureServiceRegistration
    {
        public static IServiceCollection AddContractClosureServices(
            this IServiceCollection services)
        {
            // ✅ Scoped (Windsor LifestyleScoped)
            services.AddScoped<IOrganizationService>(_ =>
                CrmConnectionFactory.GetOrganizationService());

            services.AddScoped<IContractClosureService, ContractClosureService>();
            services.AddScoped<ICrmContractRepository, CrmContractRepository>();

            return services;
        }
    }

}
