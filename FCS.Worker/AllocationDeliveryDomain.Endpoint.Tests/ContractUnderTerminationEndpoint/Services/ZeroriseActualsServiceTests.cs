namespace AllocationDeliveryDomain.Endpoint.Tests.ContractUnderTerminationEndpoint.Services
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Endpoint.ContractUnderTerminationEndpoint;
    using Endpoint.ContractUnderTerminationEndpoint.Repositories;
    using Endpoint.ContractUnderTerminationEndpoint.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.AllocationActuals;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractTermination;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.OverrideDate;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore;
    using SFA.FCT.Framework.Logging;

    [TestClass]
    public class ZeroriseActualsServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ZeroiseActualsService_ShouldZeroiseIfThereIsNoActivityCloseDate()
        {
            // arrange
            Mock<IFundingStreamPeriodRepository> fspRepositoryMock = new Mock<IFundingStreamPeriodRepository>();
            fspRepositoryMock.Setup(m => m.GetFundingStreamPeriod(It.IsAny<ConnectionInfo>(), It.IsAny<string>()))
                .Returns(Task.FromResult(new FundingStreamPeriod()));

            Mock<IDate> dateMock = new Mock<IDate>();
            dateMock.Setup(m => m.GetCalculationDate()).Returns(new DateTime(2018, 12, 1));

            Mock<IAllocationDeliverablePeriodActualAuditRepository> adpActualAuditRepositoryMock =
                new Mock<IAllocationDeliverablePeriodActualAuditRepository>();
            adpActualAuditRepositoryMock
                .Setup(m => m.GetLatestCollectionReturn(It.IsAny<ConnectionInfo>(), It.IsAny<string>()))
                .Returns(Task.FromResult(GetAdpActualAudits(values: 5, volumes: 0)));

            var service = new ZeroiseActualsService(
                fspRepositoryMock.Object, adpActualAuditRepositoryMock.Object, dateMock.Object);

            ContractAllocationActualsType publishedEvent = null;

            Task PublishEventMock(ContractAllocationActualsType e)
            {
                publishedEvent = e;
                return Task.FromResult(0);
            }

            // act
            service.ConditionallyZeroiseActuals(ConnectionInfo.CreateDefault(), new TerminationAllocation("", "", new DateTime(2018, 6, 1)), PublishEventMock).Wait();

            // assert
            Assert.IsNotNull(publishedEvent, "An event was not published");
            Assert.AreEqual(6, publishedEvent.ActualsSummary.Count(a => a.ActualValue == 0),
                "Incorrect number of zero values");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ZeroiseActualsService_ShouldNotZeroiseIfActivityCloseDateIsInThePast()
        {
            // arrange
            Mock<IFundingStreamPeriodRepository> fspRepositoryMock = new Mock<IFundingStreamPeriodRepository>();
            fspRepositoryMock.Setup(m => m.GetFundingStreamPeriod(It.IsAny<ConnectionInfo>(), It.IsAny<string>()))
                .Returns(Task.FromResult(new FundingStreamPeriod{ ActivityCloseDate = new DateTime(2018, 12, 1)}));

            Mock<IDate> dateMock = new Mock<IDate>();
            dateMock.Setup(m => m.GetCalculationDate()).Returns(new DateTime(2019, 1, 1));

            var service = new ZeroiseActualsService(
                fspRepositoryMock.Object, Mock.Of<IAllocationDeliverablePeriodActualAuditRepository>(), dateMock.Object);

            ContractAllocationActualsType publishedEvent = null;

            Task PublishEventMock(ContractAllocationActualsType e)
            {
                publishedEvent = e;
                return Task.FromResult(0);
            }

            // act
            service.ConditionallyZeroiseActuals(ConnectionInfo.CreateDefault(), new TerminationAllocation("", "", DateTime.Now), PublishEventMock).Wait();

            // assert
            Assert.IsNull(publishedEvent, "An event was published");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ZeroiseActualsService_ShouldNotZeroiseIfAllValuesAndVolumesAreZero()
        {
            // arrange
            Mock<IFundingStreamPeriodRepository> fspRepositoryMock = new Mock<IFundingStreamPeriodRepository>();
            fspRepositoryMock.Setup(m => m.GetFundingStreamPeriod(It.IsAny<ConnectionInfo>(), It.IsAny<string>()))
                .Returns(Task.FromResult(new FundingStreamPeriod{ActivityCloseDate = new DateTime(2019, 12, 1)}));

            Mock<IDate> dateMock = new Mock<IDate>();
            dateMock.Setup(m => m.GetCalculationDate()).Returns(new DateTime(2018, 12, 1));

            Mock<IAllocationDeliverablePeriodActualAuditRepository> adpActualAuditRepositoryMock =
                new Mock<IAllocationDeliverablePeriodActualAuditRepository>();
            adpActualAuditRepositoryMock
                .Setup(m => m.GetLatestCollectionReturn(It.IsAny<ConnectionInfo>(), It.IsAny<string>()))
                .Returns(Task.FromResult(GetAdpActualAudits(values: 0, volumes: 0)));

            var service = new ZeroiseActualsService(
                fspRepositoryMock.Object, adpActualAuditRepositoryMock.Object, dateMock.Object);

            ContractAllocationActualsType publishedEvent = null;

            Task PublishEventMock(ContractAllocationActualsType e)
            {
                publishedEvent = e;
                return Task.FromResult(0);
            }

            // act
            service.ConditionallyZeroiseActuals(ConnectionInfo.CreateDefault(), new TerminationAllocation("", "", DateTime.Now), PublishEventMock).Wait();

            // assert
            Assert.IsNull(publishedEvent, "An event was published");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ZeroiseActualsService_ShouldZeroisePeriodsLaterThanTerminationDateWithNonZeroValue()
        {
            // arrange
            Mock<IFundingStreamPeriodRepository> fspRepositoryMock = new Mock<IFundingStreamPeriodRepository>();
            fspRepositoryMock.Setup(m => m.GetFundingStreamPeriod(It.IsAny<ConnectionInfo>(), It.IsAny<string>()))
                .Returns(Task.FromResult(new FundingStreamPeriod{ActivityCloseDate = new DateTime(2019, 12, 1)}));

            Mock<IDate> dateMock = new Mock<IDate>();
            dateMock.Setup(m => m.GetCalculationDate()).Returns(new DateTime(2018, 12, 1));

            Mock<IAllocationDeliverablePeriodActualAuditRepository> adpActualAuditRepositoryMock =
                new Mock<IAllocationDeliverablePeriodActualAuditRepository>();
            adpActualAuditRepositoryMock
                .Setup(m => m.GetLatestCollectionReturn(It.IsAny<ConnectionInfo>(), It.IsAny<string>()))
                .Returns(Task.FromResult(GetAdpActualAudits(values: 5, volumes: 0)));

            var service = new ZeroiseActualsService(
                fspRepositoryMock.Object, adpActualAuditRepositoryMock.Object, dateMock.Object);

            ContractAllocationActualsType publishedEvent = null;

            Task PublishEventMock(ContractAllocationActualsType e)
            {
                publishedEvent = e;
                return Task.FromResult(0);
            }

            // act
            service.ConditionallyZeroiseActuals(ConnectionInfo.CreateDefault(), new TerminationAllocation("", "", new DateTime(2018, 6, 1)), PublishEventMock).Wait();

            // assert
            Assert.IsNotNull(publishedEvent, "An event was not published");
            Assert.AreEqual(6, publishedEvent.ActualsSummary.Count(a => a.ActualValue == 0),
                "Incorrect number of zero values");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ZeroiseActualsService_ShouldZeroisePeriodsLaterThanTerminationDateWithNonZeroVolume()
        {
            // arrange
            Mock<IFundingStreamPeriodRepository> fspRepositoryMock = new Mock<IFundingStreamPeriodRepository>();
            fspRepositoryMock.Setup(m => m.GetFundingStreamPeriod(It.IsAny<ConnectionInfo>(), It.IsAny<string>()))
                .Returns(Task.FromResult(new FundingStreamPeriod{ActivityCloseDate = new DateTime(2019, 12, 1)}));

            Mock<IDate> dateMock = new Mock<IDate>();
            dateMock.Setup(m => m.GetCalculationDate()).Returns(new DateTime(2018, 12, 1));

            Mock<IAllocationDeliverablePeriodActualAuditRepository> adpActualAuditRepositoryMock =
                new Mock<IAllocationDeliverablePeriodActualAuditRepository>();
            adpActualAuditRepositoryMock
                .Setup(m => m.GetLatestCollectionReturn(It.IsAny<ConnectionInfo>(), It.IsAny<string>()))
                .Returns(Task.FromResult(GetAdpActualAudits(values: 0, volumes: 5)));

            var service = new ZeroiseActualsService(
                fspRepositoryMock.Object, adpActualAuditRepositoryMock.Object, dateMock.Object);

            ContractAllocationActualsType publishedEvent = null;

            Task PublishEventMock(ContractAllocationActualsType e)
            {
                publishedEvent = e;
                return Task.FromResult(0);
            }

            // act
            service.ConditionallyZeroiseActuals(ConnectionInfo.CreateDefault(), new TerminationAllocation("", "", new DateTime(2018, 6, 1)), PublishEventMock).Wait();

            // assert
            Assert.IsNotNull(publishedEvent, "An event was not published");
            Assert.AreEqual(6, publishedEvent.ActualsSummary.Count(a => a.ActualVolume == 0),
                "Incorrect number of zero values");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ZeroiseActualsService_ShouldPublishWhenThereAreNoPeriodsToZeroiseButPeriodsHaveActuals()
        {
            // arrange
            Mock<IFundingStreamPeriodRepository> fspRepositoryMock = new Mock<IFundingStreamPeriodRepository>();
            fspRepositoryMock.Setup(m => m.GetFundingStreamPeriod(It.IsAny<ConnectionInfo>(), It.IsAny<string>()))
                .Returns(Task.FromResult(new FundingStreamPeriod { ActivityCloseDate = new DateTime(2019, 12, 1) }));

            // dateTime in the last period of the contract
            DateTime decemberDate = new DateTime(2018, 12, 1);

            Mock<IDate> dateMock = new Mock<IDate>();
            dateMock.Setup(m => m.GetCalculationDate()).Returns(new DateTime(2018, 12, 1));
            const int actualVolume = 5;

            IReadOnlyCollection<AllocationDeliverablePeriodActualAudit> allocationDeliverablePeriodActualAudits = GetAdpActualAudits(values: 0, volumes: actualVolume);
            Mock<IAllocationDeliverablePeriodActualAuditRepository> adpActualAuditRepositoryMock =
                new Mock<IAllocationDeliverablePeriodActualAuditRepository>();
            adpActualAuditRepositoryMock
                .Setup(m => m.GetLatestCollectionReturn(It.IsAny<ConnectionInfo>(), It.IsAny<string>()))
                .Returns(Task.FromResult(allocationDeliverablePeriodActualAudits));

            var service = new ZeroiseActualsService(
                fspRepositoryMock.Object, adpActualAuditRepositoryMock.Object, dateMock.Object);

            ContractAllocationActualsType publishedEvent = null;

            Task PublishEventMock(ContractAllocationActualsType e)
            {
                publishedEvent = e;
                return Task.FromResult(0);
            }

            // act
            service.ConditionallyZeroiseActuals(ConnectionInfo.CreateDefault(), new TerminationAllocation("", "", decemberDate), PublishEventMock).Wait();

            // assert
            Assert.IsNotNull(publishedEvent, "An event was not published");
            Assert.AreEqual(allocationDeliverablePeriodActualAudits.Count, publishedEvent.ActualsSummary.Count, "The number of periods published is incorrect");
            Assert.IsTrue(publishedEvent.ActualsSummary.All(a => a.ActualVolume == actualVolume), "Zeriosation has taken place");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ZeroiseActualsService_ShouldResolveFromEndpointContainer()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()));

            container.Register(Component.For<IOverrideDateDBContext>().ImplementedBy<OverrideDateDBContext>()
                .LifestyleScoped().IsDefault().Named("Override"));

            container.BeginScope();

            // act, assert
            container.Resolve<IZeroiseActualsService>();
        }

        private static IReadOnlyCollection<AllocationDeliverablePeriodActualAudit> GetAdpActualAudits(double values, long volumes)
        {
            return Enumerable.Range(1, 12)
                .Select(i => new AllocationDeliverablePeriodActualAudit
                {
                    ActualValue = values,
                    ActualVolume = volumes,
                    CollectionReturnCode = "CRC",
                    CollectionType = "CT",
                    CollectionReturnPeriod = 1,
                    Period = $"2018{i:D2}",
                    ContractAllocationNumber = "Alloc1",
                    ContractNumber = "Contract1",
                    PeriodTypeCode = "PT",
                    Ukprn = "12345678",
                    OrganisationId = "ORG0000001",
                    FundingStreamPeriodCode = "FSP1516",
                    ContractVersion = 1,
                    ContractSubVersion = 0,
                    DeliverableCode = 1,
                    UopCode = "UOP"
                }).ToList();
        }
    }
}