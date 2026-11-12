namespace AllocationDeliveryDomain.Endpoint.IoC
{
    using AllocationDeliveryDomain.Endpoint.BusinessLogic;
    using AllocationDeliveryDomain.Endpoint.BusinessLogic.Enricher;
    using AllocationDeliveryDomain.Endpoint.BusinessLogic.Mapper;
    using AllocationDeliveryDomain.Endpoint.Repositories;
    using AllocationDeliveryDomain.Endpoint.Services;
    using AllocationDeliveryDomain.Endpoint.Settings;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Repositories;
    using Microsoft.Extensions.DependencyInjection;
    using SFA.FCT.AllocationDelivery.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Cache;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Services;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.AllocationDeliveryDomain.Endpoint.BusinessLogic.Validator;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Entities.AllocationActuals;
    using SFA.FCT.CrossDomain.Integration.OverrideDate;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore;
    using Microsoft.Extensions.Logging;
    using System;
    using System.Configuration;
    using ClosedCollectionRepository = SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using Infrastructure;
    public static class AllocationServiceRegistration
    {
        public static void AddAllocationDomainServices(
            this IServiceCollection services,
            ILoggerFactory loggerFactory)
        {            

            // ============================================================
            // AZURE TABLE STORAGE + ENVIRONMENT CONTEXT
            // ============================================================
            services.AddSingleton<IAzureTableStore, AzureTableStore>();
            services.AddSingleton<IEnvironmentContext, EnvironmentContext>();

            // ============================================================
            // GENERIC AZURE REPOSITORIES
            // ============================================================
            services.AddSingleton<IAzureRepository<ReportedActual>, AzureRepository<ReportedActual>>();
            services.AddSingleton<IAzureRepository<ActualsCollectionTypeSummary>, AzureRepository<ActualsCollectionTypeSummary>>();
            services.AddSingleton<IAzureRepository<ActualAllocationGroupKeyEntity>, AzureRepository<ActualAllocationGroupKeyEntity>>();
            services.AddSingleton<IAzureRepository<ClosedCollectionHistory>, AzureRepository<ClosedCollectionHistory>>();

            // ============================================================
            // DATE REGISTRATION (ParseDateRegistration from Windsor)
            // ============================================================
            bool useRealDate = Convert.ToBoolean(ConfigurationManager.AppSettings["UseRealDate"]);
            if (useRealDate)
                services.AddSingleton<IDate, SystemDate>();
            else
                services.AddScoped<IDate, StaticDate>();

            // ============================================================
            // DB CONTEXTS (Scoped)
            // ============================================================
            services.AddScoped<IOverrideDateDBContext, OverrideDateDBContext>();
            services.AddScoped<IMonitoringDeliverablesDbContext, MonitoringDeliverablesDbContext>();
            services.AddScoped<IContractManagementDbContext, ContractManagementDbContext>();
            services.AddScoped<IAllocationDeliveryDbContext, AllocationDeliveryDbContext>();

            // ============================================================
            // SETTINGS
            // ============================================================
            services.AddSingleton<IAllocationDeliveryDomainSettings, AllocationDeliveryDomainSettings>();

            // ============================================================
            // BUSINESS LOGIC / SERVICES
            // ============================================================
            services.AddScoped<IMapper<EnrichedReportedActual, ContractAllocationActualsType>, EnrichedActualMapper>();
            services.AddScoped<IMonitoringDeliverableStore, MonitoringDeliverableStore>();
            services.AddScoped<IFundingStreamConfigurationStore, FundingStreamConfigurationStore>();
            services.AddScoped<IActualEnricher, ActualEnricher>();
            services.AddScoped<IGenericSubmissionEnricher, GenericSubmissionEnricher>();
            services.AddScoped<IActualValidator, ActualValidator>();
            services.AddScoped<ICurrentViewActualsComponent, CurrentViewActualsComponent>();
            services.AddScoped<IActualsAuditMapper, ActualsAuditMapper>();
            services.AddScoped<IFundingStreamPeriodCache, FundingStreamPeriodCache>();
            services.AddScoped<IMonthEndService, MonthEndService>();
            services.AddScoped<IMonthEndHistoryRepository, MonthEndHistoryRepository>();
            //services.AddScoped<IContractAllocationTransformer, ContractAllocationTransformer>(); // If required we can add 

            // ============================================================
            // CLOSED COLLECTION
            // ============================================================
            services.AddScoped<ClosedCollectionRepository.IClosedCollectionRepository,
                ClosedCollectionRepository.ClosedCollectionRepository>();

            // ============================================================
            // SERVICE BUS QUERY
            // ============================================================
            services.AddSingleton<IAzureServiceBusQueryService, AzureServiceBusQueryService>();

            // ============================================================
            // HELD ACTUALS
            // ============================================================
            services.AddScoped<IHeldReportedActualGroupCommandRepository, HeldReportedActualGroupRepository>();
            services.AddScoped<IHeldReportedActualGroupQueryRepository, HeldReportedActualGroupRepository>();
            services.AddScoped<IHeldReportedActualGroupEvaluator, HeldReportedActualGroupService>();
            services.AddScoped<IHeldFspCollectionConfigRepository, HeldFspCollectionConfigRepository>();

            // ============================================================
            // TERMINATION QUERY
            // ============================================================
            services.AddScoped<IAllocationsUnderTerminationQueryRepository, AllocationsUnderTerminationQueryRepository>();

            // ============================================================
            // MESSAGE PROCESSING
            // ============================================================
            services.AddScoped<SFA.FCT.AllocationDelivery.DataStore.Repositories.IProcessedMessageRepository,
                SFA.FCT.AllocationDelivery.DataStore.Repositories.ProcessedMessageRepository>();

            // ============================================================
            // MULTI-SOURCE ACTUALS / SUMMARY ACTUALS
            // ============================================================
            services.AddScoped<IMultiSourceActualRepository, MultiSourceActualRepository>();
            services.AddScoped<ISummarisedActualRepository, SummarisedActualRepository>();

            // ============================================================
            // FUNDING REPOSITORIES
            // ============================================================
            services.AddScoped<IFundingStreamPeriodRepository, FundingStreamPeriodRepository>();

            // ============================================================
            // SESSION CONNECTION FACTORY
            // ============================================================
            services.AddSingleton<ISessionConnectionFactory, SessionConnectionFactory>();
        }
    }
}
