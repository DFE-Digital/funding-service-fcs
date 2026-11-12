using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PerformanceManagementDomain.ReconciliationPublication
{
    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.Xrm.Sdk;
    using Infrastructure;
    using Repositories;
    using Services;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Services;
    using SFA.FCT.PerformanceManagementDomain.Common.Repositories;

    public static class ReconciliationPublicationServiceRegistration
    {
        public static IServiceCollection AddReconciliationPublicationServices(
            this IServiceCollection services)
        {
            // ✅ Singleton (Windsor LifestyleSingleton)
            services.AddSingleton<ISessionConnectionFactory, SessionConnectionFactory>();
            services.AddSingleton<IFcrPublisher, FcrPublisher>();
            services.AddSingleton<IAtomFeedItemRepository, AtomFeedItemRepository>();
            services.AddSingleton<IDateProvider, DateProvider>();
            services.AddSingleton<IClaimReconciliationBehaviourRepository, ClaimReconciliationBehaviourRepository>();
            services.AddSingleton<IClaimReconciliationPublicationExceptionRepository, ClaimReconciliationPublicationExceptionRepository>();
            services.AddSingleton<IClaimReconciliationReferenceDataReconProfilingRepository,
                ClaimReconciliationReferenceDataReconProfilingRepository>();

            // ✅ Scoped (Windsor LifestyleScoped)
            services.AddScoped<IOrganizationService>(_ =>
                CrmConnectionFactory.GetOrganizationService());

            services.AddScoped<IFundingClaimReconciliationQueryRepository,
                FundingClaimReconciliationQueryRepository>();

            return services;
        }
    }

}
