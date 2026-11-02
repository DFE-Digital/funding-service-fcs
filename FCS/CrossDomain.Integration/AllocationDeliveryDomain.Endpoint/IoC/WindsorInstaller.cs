namespace AllocationDeliveryDomain.Endpoint.IoC
{
    using System;
    using System.Configuration;
    using System.Diagnostics.CodeAnalysis;
    using BusinessLogic;
    using BusinessLogic.Enricher;
    using BusinessLogic.Mapper;
    using Services;
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Repositories;
    using Infrastructure;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Cache;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.AllocationDeliveryDomain.Endpoint.BusinessLogic.Validator;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Entities.AllocationActuals;
    using SFA.FCT.CrossDomain.Integration.OverrideDate;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Repositories;
    using Settings;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Services;
    using SFA.FCT.AllocationDelivery.DataStore;
    using ClosedCollectionRepository = SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;

    [ExcludeFromCodeCoverage]
    public class WindsorInstaller : IWindsorInstaller
    {
        private readonly ILoggerFactory _loggerFactory;

        public WindsorInstaller(ILoggerFactory loggerFactory)
        {
            _loggerFactory = loggerFactory;
        }

        public void Install(IWindsorContainer container, IConfigurationStore store)
        {
            container.Register(Component.For<IAzureTableStore>().ImplementedBy<AzureTableStore>());
            container.Register(Component.For<IEnvironmentContext>().ImplementedBy<EnvironmentContext>());
            container.Register(
                Component.For<IAzureRepository<ReportedActual>>().ImplementedBy<AzureRepository<ReportedActual>>());
            container.Register(
                Component.For<IAzureRepository<ActualsCollectionTypeSummary>>()
                    .ImplementedBy<AzureRepository<ActualsCollectionTypeSummary>>());
            container.Register(
                Component.For<IAzureRepository<ActualAllocationGroupKeyEntity>>()
                    .ImplementedBy<AzureRepository<ActualAllocationGroupKeyEntity>>());
            container.Register(
                Component.For<IAzureRepository<ClosedCollectionHistory>>()
                    .ImplementedBy<AzureRepository<ClosedCollectionHistory>>());

            container.Register(Component.For<IOverrideDateDBContext>().ImplementedBy<OverrideDateDBContext>().LifestyleScoped());

            container.Register(Component.For<IMonitoringDeliverablesDbContext>().ImplementedBy<MonitoringDeliverablesDbContext>().LifestyleScoped());

            container.Register(Component.For<IAllocationDeliveryDomainSettings>().ImplementedBy<AllocationDeliveryDomainSettings>());
            container.Register(ParseDateRegistration());

            container.Register(
                Component.For<IMapper<EnrichedReportedActual, ContractAllocationActualsType>>()
                    .ImplementedBy<EnrichedActualMapper>());
            container.Register(Component.For<IMonitoringDeliverableStore>().ImplementedBy<MonitoringDeliverableStore>().LifestyleScoped());
            container.Register(
                Component.For<IFundingStreamConfigurationStore>()
                    .ImplementedBy<FundingStreamConfigurationStore>()
                    .LifestyleScoped());

            container.Register(Component.For<ILogger>().Instance(_loggerFactory.CreateLogger("AllocationDeliveryDomain")));

            container.Register(Component.For<IActualEnricher>().ImplementedBy<ActualEnricher>().LifestyleScoped());
            container.Register(Component.For<IGenericSubmissionEnricher>().ImplementedBy<GenericSubmissionEnricher>().LifestyleScoped());
            container.Register(Component.For<IActualValidator>().ImplementedBy<ActualValidator>().LifestyleScoped());
            container.Register(Component.For<ICurrentViewActualsComponent>().ImplementedBy<CurrentViewActualsComponent>().LifestyleScoped());
            container.Register(Component.For<IActualsAuditMapper>().ImplementedBy<ActualsAuditMapper>().LifestyleScoped());
            container.Register(Component.For<IFundingStreamPeriodCache>().ImplementedBy<FundingStreamPeriodCache>());            
            container.Register(Component.For<IContractManagementDbContext>().ImplementedBy<ContractManagementDbContext>().LifestyleScoped());
            container.Register(Component.For<IMonthEndService>().ImplementedBy<MonthEndService>().LifestyleScoped());
            container.Register(Component.For<IMonthEndHistoryRepository>().ImplementedBy<MonthEndHistoryRepository>().LifestyleScoped());
            container.Register(Component.For<ClosedCollectionRepository.IClosedCollectionRepository>().ImplementedBy<ClosedCollectionRepository.ClosedCollectionRepository>().LifestyleScoped());
            container.Register(Component.For<IAzureServiceBusQueryService>().ImplementedBy<AzureServiceBusQueryService>().LifestyleSingleton());
            container.Register(Component.For<IHeldReportedActualGroupCommandRepository, IHeldReportedActualGroupQueryRepository>().ImplementedBy<HeldReportedActualGroupRepository>().LifestyleScoped());
            container.Register(Component.For<IHeldReportedActualGroupEvaluator>().ImplementedBy<HeldReportedActualGroupService>().LifestyleScoped());
            container.Register(Component.For<IHeldFspCollectionConfigRepository>().ImplementedBy<HeldFspCollectionConfigRepository>().LifestyleScoped());
            container.Register(Component.For<IAllocationsUnderTerminationQueryRepository>().ImplementedBy<AllocationsUnderTerminationQueryRepository>().LifestyleScoped());
            container.Register(Component.For<IAllocationDeliveryDbContext>().ImplementedBy<AllocationDeliveryDbContext>().LifestyleScoped());
            container.Register(Component.For<SFA.FCT.AllocationDelivery.DataStore.Repositories.IProcessedMessageRepository>()
                .ImplementedBy<SFA.FCT.AllocationDelivery.DataStore.Repositories.ProcessedMessageRepository>().LifestyleScoped());
            container.Register(Component.For<IMultiSourceActualRepository>().ImplementedBy<MultiSourceActualRepository>().LifestyleScoped());
            container.Register(Component.For<ISummarisedActualRepository>().ImplementedBy<SummarisedActualRepository>().LifestyleScoped());
            container.Register(Component.For<IFundingStreamPeriodRepository>().ImplementedBy<FundingStreamPeriodRepository>().LifestyleScoped());
            container.Register(Component.For<ISessionConnectionFactory>().ImplementedBy<SessionConnectionFactory>().LifestyleSingleton());
        }

        // This registration is dependant on the environment:
        // StaticDate should be used on any environment in which automated tests have to be run
        // SystemDate should be used for production for performance improvements
        private static IRegistration ParseDateRegistration()
        {
            var useRealDate = Convert.ToBoolean(ConfigurationManager.AppSettings["UseRealDate"]);

            return useRealDate ? Component.For<IDate>().ImplementedBy<SystemDate>().LifestyleSingleton() : Component.For<IDate>().ImplementedBy<StaticDate>().LifestyleScoped();
        }
    }
}
