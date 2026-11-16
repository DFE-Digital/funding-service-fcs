using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ContractManagementDomain.Endpoint.ConfirmPublicationToProvider
{

    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.Xrm.Sdk;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Repositories;
    using Infrastructure;
    using Services;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Services;

    public static class ConfirmPublicationToProviderServiceRegistration
    {
        public static IServiceCollection AddConfirmPublicationToProviderServices(
            this IServiceCollection services)
        {
            // ✅ Singleton (Windsor LifestyleSingleton)
            services.AddSingleton<ISessionConnectionFactory, SessionConnectionFactory>();
            services.AddSingleton<IDateProvider, DateProvider>();
            services.AddSingleton(typeof(IEntityCache<,>), typeof(EntityCache<,>));

            // ✅ Scoped (Windsor LifestyleScoped)
            services.AddScoped<IOrganizationService>(_ =>
                CrmConnectionFactory.GetOrganizationService());

            services.AddScoped<IContractsManager, ContractsManager>();
            services.AddScoped<IFundingTypeFundingPeriodService, FundingTypeFundingPeriodService>();
            services.AddScoped<IFundingTypeFundingPeriodQueryRepository, FundingTypeFundingPeriodQueryRepository>();
            services.AddScoped<IContractManagementDbContext, ContractManagementDbContext>();
            services.AddScoped<IXrmManager, XrmManager>();

            return services;
        }
    }

}
