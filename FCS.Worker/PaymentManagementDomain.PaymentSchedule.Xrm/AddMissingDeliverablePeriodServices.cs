using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PaymentManagementDomain.PaymentSchedule
{
    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.Xrm.Sdk;
    using PaymentManagementDomain.PaymentSchedule.Xrm.Infrastructure;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Repositories;

    public static class MissingDeliverablePeriodServiceRegistration
    {
        public static IServiceCollection AddMissingDeliverablePeriodServices(
            this IServiceCollection services)
        {
            // ✅ Scoped (Windsor LifestyleScoped)
            services.AddScoped<IOrganizationService>(_ =>
                CrmConnectionFactory.GetOrganizationService());

            services.AddScoped<ISessionConnectionFactory, SessionConnectionFactory>();

            // ✅ Singleton (Windsor LifestyleSingleton)
            services.AddSingleton<IDeliverablePaymentCommandRepository,
                DeliverablePaymentCommandRepository>();

            return services;
        }
    }

}
