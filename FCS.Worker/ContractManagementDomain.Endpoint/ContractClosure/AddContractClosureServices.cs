using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ContractManagementDomain.Endpoint.ContractClosure
{
    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.Xrm.Sdk;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Repositories;
    using ContractManagement.DataStore.Services;
    using Infrastructure;
    using Repositories;
    using Services;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Services;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Services;

    public static class ContractClosureServiceRegistration
    {
        public static IServiceCollection AddContractClosureServices(
            this IServiceCollection services)
        {
            // ✅ Singleton (Windsor LifestyleSingleton)
            services.AddSingleton<ISessionConnectionFactory, SessionConnectionFactory>();
            services.AddSingleton<IDateProvider, DateProvider>();
            services.AddSingleton<IContractTransformer, ContractTransformer>();
            services.AddSingleton<IContractXmlValidator, ContractXmlValidator>();

            // ✅ Scoped (Windsor LifestyleScoped)
            services.AddScoped<IOrganizationService>(_ =>
                CrmConnectionFactory.GetOrganizationService());

            services.AddScoped<IApprovedContractRepository, ApprovedContractRepository>();
            services.AddScoped<IApprovedContractAllocationRepository, ApprovedContractAllocationRepository>();
            services.AddScoped<ICrmContractRepository, CrmContractRepository>();
            services.AddScoped<IMonthEndHistoryRepository, MonthEndHistoryRepository>();
            services.AddScoped<IValidationService, ValidationService>();
            services.AddScoped<IApprovalOnwardsContractAtomItemRepository, ApprovalOnwardsContractAtomItemRepository>();
            services.AddScoped<IApprovalOnwardsContractAtomFeedService, ApprovalOnwardsContractAtomFeedService>();
            services.AddScoped<IContractsManager, ContractsManager>();
            services.AddScoped<ILegalDeliverableService, LegalDeliverableService>();
            services.AddScoped<IFundingStreamPeriodLegalDeliverableRepository, FundingStreamPeriodLegalDeliverableRepository>();
            services.AddScoped<IContractManagementDbContext, ContractManagementDbContext>();

            return services;
        }
    }

}
