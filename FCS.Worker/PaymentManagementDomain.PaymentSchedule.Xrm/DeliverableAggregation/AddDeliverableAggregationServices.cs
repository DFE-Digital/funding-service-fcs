using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PaymentManagementDomain.PaymentSchedule.DeliverableAggregation
{
    extern alias IntegrationEntities;

    using IntegrationEntities::SFA.FCT.CrossDomain.Integration.Entities.Data;
    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.Xrm.Sdk;
    using PaymentManagementDomain.PaymentSchedule.Xrm.Infrastructure;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Repositories;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Repositories;

    public static class DeliverableAggregationServiceRegistration
    {
        public static IServiceCollection AddDeliverableAggregationServices(
            this IServiceCollection services)
        {
            // ✅ CRM
            services.AddScoped<IOrganizationService>(_ =>
                CrmConnectionFactory.GetOrganizationService());

            // ✅ Core services
            services.AddScoped<IAggregateDeliverablesService, AggregateDeliverablesService>();

            // ✅ Repositories (Scoped)
            services.AddScoped<IDeliverablePaymentRepository, DeliverablePaymentRepository>();
            services.AddScoped<IPayCalcPolicyQueryRepository, PayCalcPolicyQueryRepository>();
            services.AddScoped<IPaymentManagementPolicyContext, PaymentManagementPolicyContext>();
            services.AddScoped<IPaymentSchedulePolicyContext, PaymentSchedulePolicyContext>();
            services.AddScoped<ICrmDeliverableRepository, CrmDeliverableRepository>();

            // ✅ Infrastructure
            services.AddScoped<ISessionConnectionFactory, SessionConnectionFactory>();

            // ✅ Generic cache (Singleton)
            services.AddSingleton(typeof(IEntityCache<,>), typeof(EntityCache<,>));

            return services;
        }
    }

}
