namespace AllocationDeliveryDomain.Endpoint.Tests.Integration
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using AllocationDelivery.Messages.Commands;
    using BusinessLogic;
    using BusinessLogic.Enricher;
    using BusinessLogic.Mapper;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus;
    using Repositories;
    using SFA.FCT.AllocationDelivery.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Cache;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.AllocationDeliveryDomain.Endpoint.BusinessLogic.Validator;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Entities.AllocationActuals;
    using SFA.FCT.CrossDomain.Integration.OverrideDate;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Extensions;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Validation;

    [TestClass]
    public abstract class ActualsVerificationTestBase
    {
        protected readonly List<ReportedActual> _reportedActuals;
        protected IWindsorContainer _container;

        public ActualsVerificationTestBase()
        {
            _container = CreateContainer();
            _reportedActuals = CreateReportedActuals();
        }

        protected abstract List<ReportedActual> CreateReportedActuals();

        protected virtual void ClearReportedActuals()
        {
            var repository = _container.Resolve<IAzureRepository<ReportedActual>>();
            repository.Clear(_reportedActuals.First().EntityPartitionKey);
        }

        protected virtual void ClearActualsAudit()
        {
            var context = _container.Resolve<IMonitoringDeliverablesDbContext>();
            var audits = context.AllocationDeliverablePeriodActualAudits.ToList();
            audits.ForEach(
                a =>
                {
                    context.AllocationDeliverablePeriodActualAudits.Remove(a);
                });
            context.SaveChanges();
        }

        protected virtual void ClearAllocationDeliverablePeriods()
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                context.AllocationDeliverablePeriods.ToList()
                    .ForEach(x => context.AllocationDeliverablePeriods.Remove(x));
                context.SaveChanges();
            }
        }

        protected virtual void AddReportedActuals()
        {
            var repository = _container.Resolve<IAzureRepository<ReportedActual>>();
            foreach (var reportedActual in _reportedActuals)
            {
                repository.AddRow(reportedActual);
            }
        }

        protected virtual void AddAllocationDeliverablePeriods()
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                var allocationDeliverablePeriods = new AllocationDeliverablePeriod()
                {
                    OrganisationId = "ORG1231231",
                    FundingStreamPeriodCode = "16-18APPS1516",
                    UopCode = string.Empty,
                    DeliverableCode = 2,
                    Period = "201508",
                    ContractAllocationNumber = "ALLOC-001",
                    ContractNumber = "CONTRACT-001",
                    ContractVersionNumber = 2,
                    ContractSubVersionNumber = 0,
                    AllocationStartDate = DateTime.Parse("1 Jan 2000"),
                    AllocationEndDate = DateTime.Parse("1 Dec 2015"),
                    Ukprn = string.Empty
                };
                context.AllocationDeliverablePeriods.Add(allocationDeliverablePeriods);
                context.SaveChanges();
            }
        }

        protected virtual IWindsorContainer CreateContainer()
        {
            var loggerMock = new Mock<ILogger>();

            var container = new WindsorContainer();

            container.Register(Component.For<ILogger>().Instance(loggerMock.Object));
            container.Register(Component.For<IAzureRepository<ReportedActual>>().ImplementedBy<AzureRepository<ReportedActual>>());
            container.Register(Component.For<IAzureTableStore>().ImplementedBy<AzureTableStore>());
            container.Register(Component.For<IEnvironmentContext>().ImplementedBy<EnvironmentContext>());
            container.Register(Component.For<IHandleMessages<ReportedActualsLoadedCommand>>().ImplementedBy<ReportedActualsLoadedHandler>());
            container.Register(Component.For<IActualEnricher>().ImplementedBy<ActualEnricher>());
            container.Register(Component.For<IActualValidator>().ImplementedBy<ActualValidator>());
            container.Register(Component.For<IMapper<EnrichedReportedActual, ContractAllocationActualsType>>().ImplementedBy<EnrichedActualMapper>());
            container.Register(Component.For<IMonitoringDeliverablesDbContext>().ImplementedBy<MonitoringDeliverablesDbContext>().LifestyleTransient());
            container.Register(Component.For<IMonitoringDeliverableStore>().ImplementedBy<MonitoringDeliverableStore>().LifestyleTransient());
            container.Register(Component.For<IFundingStreamConfigurationStore>().ImplementedBy<FundingStreamConfigurationStore>());
            container.Register(Component.For<IDate>().ImplementedBy<StaticDate>());
            container.Register(Component.For<IOverrideDateDBContext>().ImplementedBy<OverrideDateDBContext>());
            container.Register(Component.For<ICurrentViewActualsComponent>().ImplementedBy<CurrentViewActualsComponent>());
            container.Register(Component.For<IActualsAuditMapper>().ImplementedBy<ActualsAuditMapper>().LifestyleTransient());
            container.Register(Component.For<IFundingStreamPeriodCache>().ImplementedBy<FundingStreamPeriodCache>());
            container.Register(Component.For<IGenericSubmissionEnricher>().ImplementedBy<GenericSubmissionEnricher>().LifestyleTransient());
            container.Register(Component.For<IAllocationsUnderTerminationQueryRepository>().ImplementedBy<AllocationsUnderTerminationQueryRepository>().LifestyleTransient());
            container.Register(Component.For<IAllocationDeliveryDbContext>().ImplementedBy<AllocationDeliveryDbContext>().LifestyleTransient());
            container.Register(Component.For<SFA.FCT.AllocationDelivery.DataStore.Repositories.IProcessedMessageRepository>()
                .ImplementedBy<SFA.FCT.AllocationDelivery.DataStore.Repositories.ProcessedMessageRepository>().LifestyleTransient());
            container.Register(Component.For<IMultiSourceActualRepository>().ImplementedBy<MultiSourceActualRepository>().LifestyleTransient());
            container.Register(Component.For<ISummarisedActualRepository>().ImplementedBy<SummarisedActualRepository>().LifestyleTransient());


            return container;
        }

        protected virtual void SetStaticDate()
        {
            var overrideDateDbContext = _container.Resolve<IOverrideDateDBContext>();
            overrideDateDbContext.SetOverrideDate("04/10/2015");
        }

        protected virtual void ResetStaticDate()
        {
            var overrideDateDbContext = _container.Resolve<IOverrideDateDBContext>();
            overrideDateDbContext.ResetOverrideDate();
        }

        [TestInitialize]
        public virtual void Initialize()
        {
            ClearReportedActuals();
            ClearAllocationDeliverablePeriods();
            ClearActualsAudit();
            AddReportedActuals();
            AddAllocationDeliverablePeriods();
            SetStaticDate();
        }

        [TestCleanup]
        public virtual void Cleanup()
        {
            ClearReportedActuals();
            ClearAllocationDeliverablePeriods();
            ClearActualsAudit();
            ResetStaticDate();
        }
    }
}