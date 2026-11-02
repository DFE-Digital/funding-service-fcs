namespace AllocationDeliveryDomain.Endpoint.Tests.Integration
{
    using AllocationDeliveryDomain.Endpoint.BusinessLogic;
    using AllocationDeliveryDomain.Endpoint.BusinessLogic.Enricher;
    using AllocationDeliveryDomain.Endpoint.BusinessLogic.Mapper;
    using AllocationDeliveryDomain.Endpoint.Commands;
    using AllocationDeliveryDomain.Endpoint.Handlers;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Entities.AllocationActuals;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.AllocationDeliveryDomain.Endpoint.BusinessLogic.Validator;
    using System;
    using System.Collections.Generic;
    using System.Linq;

    [TestClass]
    public class ActualsVerificationTestsBad
    {
        private readonly List<ReportedActual> _reportedActuals;
        private readonly List<AllocationDeliverablePeriod> _enrichedActuals;

        public ActualsVerificationTestsBad()
        {
            _reportedActuals = CreateReportedActuals();
            _enrichedActuals = CreateEnrichedActuals();
        }

        private List<ReportedActual> CreateReportedActuals()
        {
            var reportedActuals = new List<ReportedActual>();

            reportedActuals.Add(new ReportedActual()
            {
                CollectionType = "aa",

                OrganisationId = "ORG1231231",

                ActualValue = 10.01,
                ActualVolume = 11,

                ContractAllocationNumber = "ALLOC-001",
                Period = "201508",
                DeliverableCode = "2",
                UoPCode = string.Empty,
                CollectionReturnCode = "X",
                FundingStreamPeriodCode = "16-18APPS1516",
            });

            reportedActuals.Add(new ReportedActual()
            {
                CollectionType = "aa",

                OrganisationId = "ORG1231231",

                ActualValue = 10.01,
                ActualVolume = 11,

                ContractAllocationNumber = "ALLOC-001",
                Period = "201508",
                DeliverableCode = "2",
                UoPCode = string.Empty,
                CollectionReturnCode = "X",
                FundingStreamPeriodCode = "NonExisting_FSPC",
            });

            return reportedActuals;
        }

        private List<AllocationDeliverablePeriod> CreateEnrichedActuals()
        {
            var result = new List<AllocationDeliverablePeriod>();
            foreach (var reportedActual in _reportedActuals)
            {
                var item = new AllocationDeliverablePeriod()
                {
                    AllocationStartDate = DateTime.Parse("1 Oct 2015"),
                    AllocationEndDate = DateTime.Parse("31 July 2016"),
                    ContractNumber = "CONTRACT-001",
                    ContractVersionNumber = 1,
                    ContractSubVersionNumber = 0,

                    ContractAllocationNumber = reportedActual.ContractAllocationNumber,
                    DeliverableCode = int.Parse(reportedActual.DeliverableCode),
                    FundingStreamPeriodCode = reportedActual.FundingStreamPeriodCode,
                    OrganisationId = reportedActual.OrganisationId,
                    Period = reportedActual.Period,
                    UopCode = reportedActual.UoPCode
                };

                result.Add(item);
            }
            return result;
        }

        private void Clear()
        {
            var container = CreateContainer();
            var repository = container.Resolve<IAzureRepository<ReportedActual>>();
            repository.Clear(_reportedActuals.First().EntityPartitionKey);
        }

        private void AddData()
        {
            var container = CreateContainer();
            var repository = container.Resolve<IAzureRepository<ReportedActual>>();
            foreach (var reportedActual in _reportedActuals)
            {
                repository.AddRow(reportedActual);
            }
        }

        private IWindsorContainer CreateContainer()
        {
            var loggerMock = new Mock<ILogger>();

            var container = new WindsorContainer();
            container.Register(Component.For<ILogger>().Instance(loggerMock.Object));
            container.Register(Component.For<IAzureRepository<ReportedActual>>().ImplementedBy<AzureRepository<ReportedActual>>());
            container.Register(Component.For<IAzureTableStore>().ImplementedBy<AzureTableStore>());
            container.Register(Component.For<IEnvironmentContext>().ImplementedBy<EnvironmentContext>());
            container.Register(Component.For<IHandleMessages<ReportedActualsLoadedCommand>>().ImplementedBy<ReportedActualsLoadedHandler>());
            container.Register(Component.For<IActualEnricher>().ImplementedBy<ActualEnricher>());
            container.Register(Component.For<IActualValidator>().ImplementedBy<ActualValidatorNullObject>());
            container.Register(Component.For<IMapper<EnrichedReportedActual, ContractAllocationActualsType>>().ImplementedBy<EnrichedActualMapper>());
            container.Register(Component.For<IMonitoringDeliverablesDbContext>().ImplementedBy<MonitoringDeliverablesDbContext>());

            return container;
        }

        private void AssertPublishedActual(IAllocationActualsVerified allocationActualsVerified)
        {
            var primaryReportedActualItem = _reportedActuals.First();
            Assert.IsNotNull(allocationActualsVerified);
            Assert.IsNotNull(allocationActualsVerified.AllocationActuals);
            Assert.AreEqual(primaryReportedActualItem.FundingStreamPeriodCode, allocationActualsVerified.AllocationActuals.FundingStreamPeriodCode);
            Assert.AreEqual(primaryReportedActualItem.ContractAllocationNumber, allocationActualsVerified.AllocationActuals.ContractAllocationNumber);
            Assert.AreEqual(1, allocationActualsVerified.AllocationActuals.ActualsSummary.Count());
            Assert.AreEqual(primaryReportedActualItem.UoPCode, allocationActualsVerified.AllocationActuals.UoPCode);
        }

        [TestInitialize()]
        public void Initialize()
        {
            Clear(); ;
            AddData();
        }

        [TestCleanup()]
        public void Cleanup()
        {
            Clear();
        }

        [TestMethod, TestCategory("IntegrationTest1")]
        public void WhenNoAllocationsActuals_NothingShouldBePublished()
        {
            var primaryReportedActualItem = _reportedActuals.FirstOrDefault();

            var busMock = new Mock<IBus>();
            busMock.Setup(b => b.Publish(It.IsAny<IAllocationActualsVerified>())).Verifiable();

            var container = CreateContainer();
            container.Register(Component.For<IBus>().Instance(busMock.Object));
            container.Register(Component.For<IMonitoringDeliverableStore>().ImplementedBy<MonitoringDeliverableStore>());

            var handler = container.Resolve<IHandleMessages<ReportedActualsLoadedCommand>>();
            var msg = new ReportedActualsLoadedCommand() { PartitionKey = primaryReportedActualItem.EntityPartitionKey };
            handler.Handle(msg);

            busMock.Verify(b => b.Publish(It.IsAny<IAllocationActualsVerified>()), Times.Never());
        }

        [TestMethod, TestCategory("IntegrationTest1")]
        public void EnrichedInvalidActuals_ShouldNotBeIncludedInPublishedReslts()
        {
            var primaryReportedActualItem = _reportedActuals.FirstOrDefault();

            var busMock = new Mock<IBus>();
            busMock.Setup(b => b.Publish(It.IsAny<IAllocationActualsVerified>())).Verifiable();

            var container = CreateContainer();
            container.Register(Component.For<IBus>().Instance(busMock.Object));
            container.Register(Component.For<IMonitoringDeliverableStore>().ImplementedBy<MonitoringDeliverableStore>());

            var handler = container.Resolve<IHandleMessages<ReportedActualsLoadedCommand>>();
            var msg = new ReportedActualsLoadedCommand() { PartitionKey = primaryReportedActualItem.EntityPartitionKey };
            handler.Handle(msg);

            busMock.Verify(b => b.Publish(It.IsAny<IAllocationActualsVerified>()), Times.Once());
        }
    }
}
