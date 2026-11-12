using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ContractManagementDomain.Endpoint.Xrm.ContractNotification
{

    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.Xrm.Sdk;
    using Repositories;
    using Services;
    using SFA.FCS.Worker.Common.Crm;

    public static class ContractNotificationServiceRegistration
    {
        public static IServiceCollection AddContractNotificationServices(
            this IServiceCollection services)
        {
            // ✅ Scoped (Windsor LifestyleScoped)
            services.AddScoped<IOrganizationService>(_ =>
                CrmConnectionFactory.GetOrganizationService());

            services.AddScoped<ICrmContractRepository, CrmContractRepository>();
            services.AddScoped<ICrmNotificationRepository, CrmNotificationRepository>();
            services.AddScoped<ICrmNotificationService, CrmNotificationService>();

            return services;
        }
    }

}
