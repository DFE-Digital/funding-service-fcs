
namespace AllocationDeliveryDomain.Endpoint.PaymentInstructionValidation
{
    using AllocationDeliveryDomain.Endpoint.Repositories;
    using Infrastructure;
    using Microsoft.Extensions.DependencyInjection;
    using Repositories; // ✅ CORRECT namespace
    using Services;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.OverrideDate;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore;
    using System;

    public static class PaymentInstructionValidationServiceRegistration
    {
        public static IServiceCollection AddPaymentInstructionValidationServices(
            this IServiceCollection services)
        {
            // ✅ Singleton
            services.AddSingleton<ISessionConnectionFactory, SessionConnectionFactory>();
            services.AddSingleton<IMultiSourceActualRepository, MultiSourceActualRepository>();
            services.AddSingleton<ISummarisedActualsQueryRepository, SummarisedActualsRepository>();
            services.AddSingleton<IEnvironmentContext, EnvironmentContext>();

            // ✅ Transient
            services.AddTransient<IAzureRepository<ReportedActual>, AzureRepository<ReportedActual>>();
            services.AddTransient<IAzureTableStore, AzureTableStore>();

            // ✅ ✅ FIXED HERE (correct namespace)
            services.AddScoped<IPaymentInstructionAuditRepository, PaymentInstructionAuditRepository>();

            // ✅ Scoped
            services.AddScoped<IMonitoringDeliverableStore, MonitoringDeliverableStore>();
            services.AddScoped<IReportedPaymentEnricher, ReportedPaymentEnricher>();
            services.AddScoped<IPaymentInstructionValidator, PaymentInstructionValidator>();
            services.AddScoped<IMonitoringDeliverablesForAllocationService, MonitoringDeliverablesForAllocationService>();
            services.AddScoped<IOverrideDateDBContext, OverrideDateDBContext>();
            services.AddScoped<IMonitoringDeliverablesDbContext, MonitoringDeliverablesDbContext>();

            // ✅ Date provider (environment-based)
            var useRealDate = Convert.ToBoolean(
                Environment.GetEnvironmentVariable("UseRealDate") ?? "false");

            if (useRealDate)
                services.AddSingleton<IDate, SystemDate>();
            else
                services.AddScoped<IDate, StaticDate>();

            return services;
        }
    }
}
