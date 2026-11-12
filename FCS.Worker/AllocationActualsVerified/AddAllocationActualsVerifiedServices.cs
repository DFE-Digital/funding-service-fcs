using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PaymentManagementDomain.AllocationActualsVerified
{
    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.Xrm.Sdk;
    using PaymentManagementDomain.AllocationActualsVerified.Repositories;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Repositories;

    public static class AllocationActualsVerifiedServiceRegistration
    {
        public static IServiceCollection AddAllocationActualsVerifiedServices(
            this IServiceCollection services)
        {
            // ✅ Scoped (Windsor LifestyleScoped)
            services.AddScoped<IOrganizationService>(_ =>
                CrmConnectionFactory.GetOrganizationService());

            services.AddScoped<IAllocationActualsRepository, AllocationActualsRepository>();
            services.AddScoped<IPayCalcPolicyQueryRepository, PayCalcPolicyQueryRepository>();
            services.AddScoped<IPaymentManagementPolicyContext, PaymentManagementPolicyContext>();

            // ✅ Singleton (Windsor LifestyleSingleton)
            services.AddSingleton(typeof(IEntityCache<,>), typeof(EntityCache<,>));
            services.AddSingleton<ISessionConnectionFactory, SessionConnectionFactory>();

            return services;
        }
    }

}
