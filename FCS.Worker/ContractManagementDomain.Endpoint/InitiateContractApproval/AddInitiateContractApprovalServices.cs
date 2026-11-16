using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ContractManagementDomain.Endpoint.InitiateContractApproval
{
    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.Xrm.Sdk;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Repositories;
    using Endpoint.Repositories;
    using Endpoint.Services;
    using Infrastructure;
    using Repositories;
    using Services;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Services;

    public static class InitiateContractApprovalServiceRegistration
    {
        public static IServiceCollection AddInitiateContractApprovalServices(
            this IServiceCollection services)
        {
            // ✅ Singleton (Windsor LifestyleSingleton)
            services.AddSingleton<ISessionConnectionFactory, SessionConnectionFactory>();
            services.AddSingleton<IDateProvider, DateProvider>();
            services.AddSingleton(typeof(IEntityCache<,>), typeof(EntityCache<,>));

            // ✅ Scoped (Windsor LifestyleScoped)
            services.AddScoped<IMonthEndHistoryRepository, MonthEndHistoryRepository>();
            services.AddScoped<IContractManagementDbContext, ContractManagementDbContext>();
            services.AddScoped<IContractCheckerService, ContractCheckerService>();
            services.AddScoped<IFundingTypeFundingPeriodQueryRepository, FundingTypeFundingPeriodQueryRepository>();
            services.AddScoped<ICrmContractRepository, CrmContractRepository>();
            services.AddScoped<IOrganizationService>(_ =>
                CrmConnectionFactory.GetOrganizationService());
            services.AddScoped<ICrmContractDeliverablePeriodRepository, CrmContractDeliverablePeriodRepository>();
            services.AddScoped<ICrmContractAllocationRepository, CrmContractAllocationRepository>();
            services.AddScoped<IContractsManager, ContractsManager>();
            services.AddScoped<IFundingTypeFundingPeriodService, FundingTypeFundingPeriodService>();
            services.AddScoped<IXrmManager, XrmManager>();

            return services;
        }
    }

}
