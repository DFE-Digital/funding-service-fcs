
namespace PaymentGenerationDomain.Endpoint.ProcessPaymentRunEndpoint
{
    using BusinessLogic;
    using BusinessLogic.Mappers;
    using BusinessLogic.Services;
    using Integration.DataStore;
    using Integration.DataStore.Repositories;
    using Microsoft.Extensions.DependencyInjection;
    using Services;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;

    public static class ProcessPaymentRunServiceRegistration
    {
        public static IServiceCollection AddProcessPaymentRunServices(
            this IServiceCollection services)
        {
            // ✅ Singleton
            services.AddSingleton<ISessionConnectionFactory, SessionConnectionFactory>();
            services.AddSingleton<IPaymentCorpSchemaMapper, PaymentCorpSchemaMapper>();

            // ✅ Scoped (LifestyleScoped)
            services.AddScoped<IPaymentRunService, PaymentRunService>();
            services.AddScoped<IDataAccessManager, DataAccessManager>();
            services.AddScoped<ISubnominalAggregationRepository, SubnominalAggregationRepository>();
            services.AddScoped<PaymentGenerationDbContext>();
            services.AddScoped<IMonitoringDeliverableStore, MonitoringDeliverableStore>();
            services.AddScoped<IMonitoringDeliverablesDbContext, MonitoringDeliverablesDbContext>();
            services.AddScoped<IPaymentBatchFeedItemCommandRepository, PaymentBatchFeedItemRepository>();
            services.AddScoped<IFcsConfiguration, FrameworkConfiguration>();
            services.AddScoped<IFundingStreamPeriodQueryRepository, FundingStreamPeriodQueryRepository>();

            // ✅ Transient
            services.AddTransient<IPaymentGenerationXmlValidator, PaymentGenerationXmlValidator>();

            return services;
        }
    }
}

