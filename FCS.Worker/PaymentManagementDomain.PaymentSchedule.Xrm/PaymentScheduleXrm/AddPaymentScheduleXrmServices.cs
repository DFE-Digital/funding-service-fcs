namespace PaymentManagementDomain.PaymentSchedule.PaymentScheduleXrm
{
    using Microsoft.Extensions.DependencyInjection;
    using PaymentManagementDomain.PaymentSchedule.PaymentScheduleXrm.Repositories;
    using Services;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Repositories;
    using Xrm.Infrastructure;

    public static class PaymentScheduleXrmServiceRegistration
    {
        public static IServiceCollection AddPaymentScheduleXrmServices(
            this IServiceCollection services)
        {
            // ✅ ✅ FIRST: bring in existing integration services
            services.AddPaymentScheduleXrmServices();

            // ✅ CRM
            services.AddScoped(_ =>
                CrmConnectionFactory.GetOrganizationService());

            // ✅ Singleton services
            services.AddSingleton<ISessionConnectionFactory, SessionConnectionFactory>();
            services.AddSingleton<IProcessedMessageRepository, ProcessedMessageRepository>();

            // ✅ Scoped services
            services.AddScoped<IPaymentScheduleService, PaymentScheduleService>();
            services.AddScoped<ICrmFspDeliverableRepository, CrmFspDeliverableRepository>();
            services.AddScoped<ICrmDeliverableRepository, CrmDeliverableRepository>();
            services.AddScoped<ICrmPeriodTypeRepository, CrmPeriodTypeRepository>();
            services.AddScoped<ICrmTransactionRequestRepository, CrmTransactionRequestRepository>();

            return services;
        }
    }

}
