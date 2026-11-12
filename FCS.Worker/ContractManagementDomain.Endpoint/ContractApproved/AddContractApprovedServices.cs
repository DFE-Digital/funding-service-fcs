using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ContractManagementDomain.Endpoint.ContractApproved
{

    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.Xrm.Sdk;
    using Infrastructure;
    using Repositories;
    using Services;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Services;

    public static class ContractApprovedServiceRegistration
    {        public static IServiceCollection AddContractApprovedServices(
            this IServiceCollection services)
        {
            // ✅ Scoped (Windsor LifestyleScoped)
            services.AddScoped<IOrganizationService>(_ =>
                CrmConnectionFactory.GetOrganizationService());

            services.AddScoped<IContractsManager, ContractsManager>();

            // ✅ Singleton (Windsor LifestyleSingleton)
            services.AddSingleton<ISessionConnectionFactory, SessionConnectionFactory>();
            services.AddSingleton<IApprovedContractAtomFeedItemCreationService, ApprovedContractAtomFeedItemCreationService>();
            services.AddSingleton<IApprovedContractAtomItemRepository, ApprovedContractAtomItemRepository>();
            services.AddSingleton<IContractTransformer, ContractTransformer>();
            services.AddSingleton<IApprovedContractPopulateCacheService, ApprovedContractPopulateCacheService>();
            services.AddSingleton<IApprovedContractRepository, ApprovedContractRepository>();
            services.AddSingleton<IFundingTypeFundingPeriodRepository, FundingTypeFundingPeriodRepository>();
            services.AddSingleton<IContractXmlValidator, ContractXmlValidator>();

            return services;
        }
    }

}
