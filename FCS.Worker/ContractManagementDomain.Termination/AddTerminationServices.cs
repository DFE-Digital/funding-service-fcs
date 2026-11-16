using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ContractManagementDomain.Termination
{

    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.Xrm.Sdk;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Repositories;
    using ContractManagement.DataStore.Services;
    using ContractManagementDomain.Termination.Repositories;
    using ContractManagementDomain.Termination.Services;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Repositories;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Services;

    public static class TerminationServiceRegistration
    {
        public static IServiceCollection AddTerminationServices(
            this IServiceCollection services)
        {
            // ✅ Singleton
            services.AddSingleton<IContractTransformer, ContractTransformer>();
            services.AddSingleton<ISessionConnectionFactory, SessionConnectionFactory>();
            services.AddSingleton<ITerminateContractValidationService, TerminateContractValidationService>();
            services.AddSingleton<IDateProvider, DateProvider>();
            services.AddSingleton<IContractXmlValidator, ContractXmlValidator>();

            // ✅ Scoped
            services.AddScoped<IOrganizationService>(_ =>
                CrmConnectionFactory.GetOrganizationService());

            services.AddScoped<ICrmContractRepository, CrmContractRepository>();
            services.AddScoped<ICrmTerminationContractRepository, CrmTerminationContractRepository>();
            services.AddScoped<ILegalDeliverableService, LegalDeliverableService>();
            services.AddScoped<IApprovalOnwardsContractAtomFeedService, ApprovalOnwardsContractAtomFeedService>();
            services.AddScoped<IApprovalOnwardsContractAtomItemRepository, ApprovalOnwardsContractAtomItemRepository>();
            services.AddScoped<IFundingStreamPeriodLegalDeliverableRepository, FundingStreamPeriodLegalDeliverableRepository>();
            services.AddScoped<IContractManagementDbContext, ContractManagementDbContext>();
            services.AddScoped<ITerminateContractInfoCreator, TerminateContractInfoCreator>();
            services.AddScoped<IMonthEndHistoryRepository, MonthEndHistoryRepository>();
            services.AddScoped<IApprovedContractRepository, ApprovedContractRepository>();
            services.AddScoped<ICorporateContractService, CorporateContractService>();
            services.AddScoped<ITerminateContractFeedService, TerminateContractFeedService>();

            // ✅ Transient
            services.AddTransient<IContractsManager, ContractsManager>();

            return services;
        }
    }

}
