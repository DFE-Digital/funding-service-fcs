using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ContractManagementDomain.Endpoint.InitiateContractWithdrawal
{

    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.Xrm.Sdk;
    using Infrastructure;
    using Services;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Services;

    public static class InitiateContractWithdrawalServiceRegistration
    {
        public static IServiceCollection AddInitiateContractWithdrawalServices(
            this IServiceCollection services)
        {
            // ✅ Singleton (Windsor LifestyleSingleton)
            services.AddSingleton<ISessionConnectionFactory, SessionConnectionFactory>();
            services.AddSingleton<IDateProvider, DateProvider>();

            // ✅ Scoped (Windsor LifestyleScoped)
            services.AddScoped<IOrganizationService>(_ =>
                CrmConnectionFactory.GetOrganizationService());

            services.AddScoped<IXrmManager, XrmManager>();
            services.AddScoped<IContractsManager, ContractsManager>();

            return services;
        }
    }

}
