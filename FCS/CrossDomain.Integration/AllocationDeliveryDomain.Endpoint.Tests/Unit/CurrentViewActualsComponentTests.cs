namespace AllocationDeliveryDomain.Endpoint.Tests.Unit
{
    using System.Collections.Generic;
    using System.Linq;
    using BusinessLogic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class CurrentViewActualsComponentTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CurrentViewActualsComponent_ShouldInsertCurrentViewActualsWhenThereAreNoneForTheAllocations()
        {
            // arrange
            Mock<IMonitoringDeliverableStore> monitoringDeliverableStoreMock = new Mock<IMonitoringDeliverableStore>();
            monitoringDeliverableStoreMock.Setup(
                m => m.GetCurrentViewActualsForAllocations(It.IsAny<IEnumerable<string>>(), It.IsAny<ConnectionInfo>()))
                .Returns(Enumerable.Empty<CurrentViewActual>().ToList());

            List<CurrentViewActual> currentViewActuals = new List<CurrentViewActual>();
            monitoringDeliverableStoreMock
                .Setup(r => r.InsertCurrentViewActuals(It.IsAny<IEnumerable<CurrentViewActual>>(), It.IsAny<ConnectionInfo>()))
                .Callback((IEnumerable<CurrentViewActual> cvas, ConnectionInfo ci) =>
                {
                    currentViewActuals.AddRange(cvas);
                });

            CurrentViewActualsComponent currentViewActualsComponent = new CurrentViewActualsComponent(monitoringDeliverableStoreMock.Object);
            List<EnrichedReportedActual> enrichedReportedActuals = new List<EnrichedReportedActual>
            {
                new EnrichedReportedActual
                {
                    ContractAllocationNumber = "Test1",
                    DeliverableCode = "1"
                }
            };

            // act
            currentViewActualsComponent.UpdateCurrentViewActualsReturningFullSetOfEnrichedActuals(
                    enrichedReportedActuals, ConnectionInfo.CreateDefault());

            // assert
            Assert.AreEqual(1, currentViewActuals.Count);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CurrentViewActualsComponent_ShouldUpdateCurrentViewActualsThatArePresentWithValidActuals()
        {
            // arrange
            List<CurrentViewActual> initialCurrentViewActuals = new List<CurrentViewActual>
            {
                new CurrentViewActual
                {
                    ContractAllocationNumber = "Test1",
                    DeliverableCode = 1,
                    OrganisationId = "ORG1",
                    FundingStreamPeriodCode = "FSP1",
                    UoPCode = "UOP1",
                    Period = "201708",
                    ActualVolume = 1,
                    ActualValue = 10
                },
                new CurrentViewActual
                {
                    ContractAllocationNumber = "Test1",
                    DeliverableCode = 2,
                    OrganisationId = "ORG1",
                    FundingStreamPeriodCode = "FSP1",
                    UoPCode = "UOP1",
                    Period = "201708",
                    ActualVolume = 2,
                    ActualValue = 20
                }
            };

            Mock<IMonitoringDeliverableStore> monitoringDeliverableStoreMock = new Mock<IMonitoringDeliverableStore>();
            monitoringDeliverableStoreMock.Setup(
                m => m.GetCurrentViewActualsForAllocations(It.IsAny<IEnumerable<string>>(), It.IsAny<ConnectionInfo>()))
                .Returns(initialCurrentViewActuals);

            CurrentViewActualsComponent currentViewActualsComponent = new CurrentViewActualsComponent(monitoringDeliverableStoreMock.Object);
            List<EnrichedReportedActual> enrichedReportedActuals = new List<EnrichedReportedActual>
            {
                new EnrichedReportedActual
                {
                    ContractAllocationNumber = "Test1",
                    DeliverableCode = "1",
                    OrganisationId = "ORG1",
                    FundingStreamPeriodCode = "FSP1",
                    UoPCode = "UOP1",
                    Period = "201708",
                    ActualVolume = 10,
                    ActualValue = 100,
                },
                new EnrichedReportedActual
                {
                    ContractAllocationNumber = "Test1",
                    DeliverableCode = "2",
                    OrganisationId = "ORG1",
                    FundingStreamPeriodCode = "FSP1",
                    UoPCode = "UOP1",
                    Period = "201708",
                    ActualVolume = 20,
                    ActualValue = 200
                }
            };

            // act
                currentViewActualsComponent.UpdateCurrentViewActualsReturningFullSetOfEnrichedActuals(
                    enrichedReportedActuals, ConnectionInfo.CreateDefault());

            // assert
            Assert.AreEqual(100, initialCurrentViewActuals[0].ActualValue, "The ActualValue has not been updated correctly for first initialCurrentViewActuals");
            Assert.AreEqual(10, initialCurrentViewActuals[0].ActualVolume, "The ActualVolume has not been updated correctly for first initialCurrentViewActuals");
            Assert.AreEqual(200, initialCurrentViewActuals[1].ActualValue, "The ActualValue has not been updated correctly for second initialCurrentViewActuals");
            Assert.AreEqual(20, initialCurrentViewActuals[1].ActualVolume, "The ActualVolume has not been updated correctly for second initialCurrentViewActuals");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CurrentViewActualsComponent_ShouldReturnValidActualsAndCurrentViewActualsForTheAllocation()
        {
            // arrange
            List<CurrentViewActual> initialCurrentViewActuals = new List<CurrentViewActual>
            {
                new CurrentViewActual
                {
                    ContractAllocationNumber = "Test1",
                    DeliverableCode = 1,
                    OrganisationId = "ORG1",
                    FundingStreamPeriodCode = "FSP1",
                    UoPCode = "UOP1",
                    Period = "201708",
                    ActualVolume = 1,
                    ActualValue = 10
                },
                new CurrentViewActual
                {
                    ContractAllocationNumber = "Test1",
                    DeliverableCode = 2,
                    OrganisationId = "ORG1",
                    FundingStreamPeriodCode = "FSP1",
                    UoPCode = "UOP1",
                    Period = "201708",
                    ActualVolume = 2,
                    ActualValue = 20
                }
            };

            Mock<IMonitoringDeliverableStore> monitoringDeliverableStoreMock = new Mock<IMonitoringDeliverableStore>();
            monitoringDeliverableStoreMock.Setup(
                m => m.GetCurrentViewActualsForAllocations(It.IsAny<IEnumerable<string>>(), It.IsAny<ConnectionInfo>()))
                .Returns(initialCurrentViewActuals);

            CurrentViewActualsComponent currentViewActualsComponent = new CurrentViewActualsComponent(monitoringDeliverableStoreMock.Object);
            List<EnrichedReportedActual> enrichedReportedActuals = new List<EnrichedReportedActual>
            {
                new EnrichedReportedActual
                {
                    ContractAllocationNumber = "Test1",
                    DeliverableCode = "1",
                    OrganisationId = "ORG1",
                    FundingStreamPeriodCode = "FSP1",
                    UoPCode = "UOP1",
                    Period = "201708",
                    ActualVolume = 10,
                    ActualValue = 100,
                    CollectionReturnCode = "R01"
                }
            };

            // act
            enrichedReportedActuals =
                currentViewActualsComponent.UpdateCurrentViewActualsReturningFullSetOfEnrichedActuals(
                    enrichedReportedActuals, It.IsAny<ConnectionInfo>());

            // assert
            Assert.AreEqual(2, enrichedReportedActuals.Count, "The Count of enrichedReportedActuals returned is not correct");
            Assert.AreEqual(1, enrichedReportedActuals.Count(era => era.DeliverableCode == "2"), "The Count of enrichedReportedActuals where deliverable code is 2 returned is not correct");
            Assert.AreEqual(1, enrichedReportedActuals.Count(era => era.DeliverableCode == "1"), "The Count of enrichedReportedActuals where deliverable code is 1 returned is not correct");
            Assert.AreEqual(2, enrichedReportedActuals.Count(era => era.CollectionReturnCode == "R01"), "The Count of enrichedReportedActuals where CollectionReturnCode is R01 returned is not correct");
        }
    }
}
