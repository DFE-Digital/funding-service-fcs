namespace AllocationDeliveryDomain.Endpoint.Tests.Unit
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using BusinessLogic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using MoreLinq;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging.Interfaces;
    using UnitTests.Common;

    [TestClass]
    public class GenericSubmissionEnricherTests
    {
        private readonly Mock<IMonitoringDeliverableStore> _monitoringDeliverableRepositoryMock = new Mock<IMonitoringDeliverableStore>();
        private readonly Mock<IDate> _mockDate = new Mock<IDate>();

        [TestMethod, TestCategory("UnitTest")]
        public void GenericSubmissionEnricher_ShouldZeroizeActuals_WhenPartialPeriodIsSubmitted()
        {
            // arrange
            IList<AllocationDeliverablePeriod> allocationDeliverablePeriods = new List<AllocationDeliverablePeriod>();
            IList<string> periodList = new[] { "201608", "201609" };
            IList<int> deliverableList = new[] { 1, 2, 3, 4 };
            periodList.ForEach(period =>
            {
                deliverableList.ForEach(deliverableCode => allocationDeliverablePeriods.Add(new AllocationDeliverablePeriod
                {
                    Period = period,
                    DeliverableCode = deliverableCode,
                    OrganisationId = "1",
                    FundingStreamPeriodCode = "2",
                    UopCode = "",
                    ContractNumber = "B",
                    ContractVersionNumber = 1,
                    ContractSubVersionNumber = 2,
                    AllocationStartDate = DateTime.Now,
                    AllocationEndDate = DateTime.Now
                }));
            });

            _mockDate.Setup(x => x.GetCalculationDate()).Returns(new DateTime(2016, 10, 4, 1, 1, 1));
            _monitoringDeliverableRepositoryMock.Setup(rep => rep.GetCurrentAndPastActiveAllocationDeliverablePeriodsForAllocation(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(allocationDeliverablePeriods.ToList());

            IList<int> enrichedDeliverableList = new[] { 1, 2, 4 };
            List<EnrichedReportedActual> enrichedActuals = new List<EnrichedReportedActual>();
            periodList.ForEach(period => enrichedDeliverableList.ForEach(deliverableCode => enrichedActuals.Add(new EnrichedReportedActual
            {
                Period = period,
                DeliverableCode = deliverableCode.ToString(),
                OrganisationId = "1",
                FundingStreamPeriodCode = "2",
                ContractNumber = "B",
                AllocationStartDate = DateTime.Now,
                AllocationEndDate = DateTime.Now
            })));
            GenericSubmissionEnricher genericSubmissionEnricher = new GenericSubmissionEnricher(_monitoringDeliverableRepositoryMock.Object, _mockDate.Object);

            // act
            enrichedActuals = genericSubmissionEnricher.AddMissingActualsWithZeroValues(enrichedActuals, FundingStreamZeroisationBehaviour.ZeroiseMissingActuals, ConnectionInfo.CreateDefault());

            // assert
            Assert.AreEqual(8, enrichedActuals.Count, "Missing actuals have not been added");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GenericSubmissionEnricher_ShouldZeroizeActuals_WhenResubmittingPastPeriod_WithNoCurrentPeriodActuals()
        {
            // arrange
            IList<AllocationDeliverablePeriod> allocationDeliverablePeriods = new List<AllocationDeliverablePeriod>();
            IList<string> periodList = new[] { "201608", "201609", "201610" };
            IList<int> deliverableList = new[] { 1, 2, 3, 4 };

            periodList.ForEach(period =>
            {
                deliverableList.ForEach(deliverableCode => allocationDeliverablePeriods.Add(new AllocationDeliverablePeriod
                {
                    Period = period,
                    DeliverableCode = deliverableCode,
                    OrganisationId = "1",
                    FundingStreamPeriodCode = "2",
                    UopCode = "",
                    ContractNumber = "B",
                    ContractVersionNumber = 1,
                    ContractSubVersionNumber = 2,
                    AllocationStartDate = DateTime.Now,
                    AllocationEndDate = DateTime.Now
                }));
            });

            _mockDate.Setup(x => x.GetCalculationDate()).Returns(new DateTime(2016, 10, 4, 1,1,1));
            _monitoringDeliverableRepositoryMock.Setup(rep => rep.GetCurrentAndPastActiveAllocationDeliverablePeriodsForAllocation(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(allocationDeliverablePeriods.ToList());

            IList<string> actualsPeriodList = new[] { "201608", "201609" };
            IList<int> enrichedDeliverableList = new[] { 1, 2, 3, 4 };
            List<EnrichedReportedActual> enrichedActuals = new List<EnrichedReportedActual>();
            actualsPeriodList.ForEach(period => enrichedDeliverableList.ForEach(deliverableCode => enrichedActuals.Add(new EnrichedReportedActual
            {
                Period = period,
                DeliverableCode = deliverableCode.ToString(),
                OrganisationId = "1",
                FundingStreamPeriodCode = "2",
                ContractNumber = "B",
                AllocationStartDate = DateTime.Now,
                AllocationEndDate = DateTime.Now
            })));
            GenericSubmissionEnricher genericSubmissionEnricher = new GenericSubmissionEnricher(_monitoringDeliverableRepositoryMock.Object, _mockDate.Object);

            // act
            enrichedActuals = genericSubmissionEnricher.AddMissingActualsWithZeroValues(enrichedActuals, FundingStreamZeroisationBehaviour.ZeroiseMissingActuals, ConnectionInfo.CreateDefault());

            // assert
            Assert.AreEqual(12, enrichedActuals.Count, "Missing actuals have not been added");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GenericSubmissionEnricher_ShouldZeroizeActuals_WhenMissingResubmission_ForPastPeriodForOneDeliverable()
        {
            // arrange
            IList<AllocationDeliverablePeriod> allocationDeliverablePeriods = new List<AllocationDeliverablePeriod>();
            IList<string> periodList = new[] { "201608", "201609", "201610" };
            IList<int> deliverableList = new[] { 1, 2, 3, 4 };
            periodList.ForEach(period =>
            {
                deliverableList.ForEach(deliverableCode => allocationDeliverablePeriods.Add(new AllocationDeliverablePeriod
                {
                    Period = period,
                    DeliverableCode = deliverableCode,
                    OrganisationId = "1",
                    FundingStreamPeriodCode = "2",
                    UopCode = "",
                    ContractNumber = "B",
                    ContractVersionNumber = 1,
                    ContractSubVersionNumber = 2,
                    AllocationStartDate = DateTime.Now,
                    AllocationEndDate = DateTime.Now
                }));
            });

            _mockDate.Setup(x => x.GetCalculationDate()).Returns(new DateTime(2016, 10, 4, 1, 1, 1));
            _monitoringDeliverableRepositoryMock.Setup(rep => rep.GetCurrentAndPastActiveAllocationDeliverablePeriodsForAllocation(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(allocationDeliverablePeriods.ToList());

            IList<int> enrichedDeliverableList = new[] { 1, 2, 3, 4 };
            List<EnrichedReportedActual> enrichedActuals = new List<EnrichedReportedActual>();
            periodList.ForEach(period => enrichedDeliverableList.ForEach(deliverableCode => enrichedActuals.Add(new EnrichedReportedActual
            {
                Period = period,
                DeliverableCode = deliverableCode.ToString(),
                OrganisationId = "1",
                FundingStreamPeriodCode = "2",
                ContractNumber = "B",
                AllocationStartDate = DateTime.Now,
                AllocationEndDate = DateTime.Now
            })));

            var actualToRemove = enrichedActuals.Single(actual => actual.Period == "201608" && actual.DeliverableCode == "2");
            enrichedActuals.Remove(actualToRemove);

            GenericSubmissionEnricher genericSubmissionEnricher = new GenericSubmissionEnricher(_monitoringDeliverableRepositoryMock.Object, _mockDate.Object);

            // act
            enrichedActuals = genericSubmissionEnricher.AddMissingActualsWithZeroValues(enrichedActuals, FundingStreamZeroisationBehaviour.ZeroiseMissingActuals, ConnectionInfo.CreateDefault());

            // assert
            Assert.AreEqual(12, enrichedActuals.Count, "Missing actuals have not been added");
        }

        /// <summary>
        /// Failing test added to support work on 16147.
        /// </summary>
        [TestMethod, TestCategory("UnitTest")]
        public void GenericSubmissionEnricher_Should_ZeroisePastActuals_WhenPersistCurrentActualsStateIsFalseAndProcessFutureActualsIsFalse()
        {
            // arrange
            IList<AllocationDeliverablePeriod> allocationDeliverablePeriods = new List<AllocationDeliverablePeriod>();
            IList<string> periodList = new[] { "201608", "201609", "201610" };
            IList<int> deliverableList = new[] { 1, 2, 3, 4 };
            periodList.ForEach(period =>
            {
                deliverableList.ForEach(deliverableCode => allocationDeliverablePeriods.Add(new AllocationDeliverablePeriod
                {
                    Period = period,
                    DeliverableCode = deliverableCode,
                    OrganisationId = "1",
                    FundingStreamPeriodCode = "2",
                    UopCode = "",
                    ContractNumber = "B",
                    ContractVersionNumber = 1,
                    ContractSubVersionNumber = 2,
                    AllocationStartDate = DateTime.Now,
                    AllocationEndDate = DateTime.Now
                }));
            });

            Mock<IMonitoringDeliverableStore> monitoringDelStoreMock = new Mock<IMonitoringDeliverableStore>();
            monitoringDelStoreMock.Setup(m => m.GetCurrentAndPastActiveAllocationDeliverablePeriodsForAllocation(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(allocationDeliverablePeriods.ToList());

            _mockDate.Setup(x => x.GetCalculationDate()).Returns(new DateTime(2016, 10, 4, 1, 1, 1));
            
            IList<int> enrichedDeliverableList = new[] { 1, 2, 3, 4 };
            List<EnrichedReportedActual> enrichedActuals = new List<EnrichedReportedActual>();
            periodList.ForEach(period => enrichedDeliverableList.ForEach(deliverableCode => enrichedActuals.Add(new EnrichedReportedActual
            {
                Period = period,
                DeliverableCode = deliverableCode.ToString(),
                OrganisationId = "1",
                FundingStreamPeriodCode = "2",
                ContractNumber = "B",
                AllocationStartDate = DateTime.Now,
                AllocationEndDate = DateTime.Now,
                ActualValue = 1,
                ActualVolume = 1
            })));

            enrichedActuals.RemoveAll(actual => actual.Period == "201608");

            GenericSubmissionEnricher genericSubmissionEnricher = new GenericSubmissionEnricher(
                monitoringDelStoreMock.Object,
                _mockDate.Object);

            // act
            enrichedActuals = genericSubmissionEnricher.AddMissingActualsWithZeroValues(enrichedActuals, FundingStreamZeroisationBehaviour.ZeroiseMissingActuals, ConnectionInfo.CreateDefault());

            // assert
            Assert.AreEqual(12, enrichedActuals.Count, "Missing actuals have not been added");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GenericSubmissionEnricher_Should_NotZeroisePastActuals_WhenPersistCurrentActualsStateIsTrueAndProcessFutureActualsIsFalse()
        {
            // arrange
            IList<AllocationDeliverablePeriod> allocationDeliverablePeriods = new List<AllocationDeliverablePeriod>();
            IList<string> periodList = new[] { "201608", "201609", "201610" };
            IList<int> deliverableList = new[] { 1, 2, 3, 4 };
            periodList.ForEach(period =>
            {
                deliverableList.ForEach(deliverableCode => allocationDeliverablePeriods.Add(new AllocationDeliverablePeriod
                {
                    Period = period,
                    DeliverableCode = deliverableCode,
                    OrganisationId = "1",
                    FundingStreamPeriodCode = "2",
                    UopCode = "",
                    ContractNumber = "B",
                    ContractVersionNumber = 1,
                    ContractSubVersionNumber = 2,
                    AllocationStartDate = DateTime.Now,
                    AllocationEndDate = DateTime.Now
                }));
            });

            _mockDate.Setup(x => x.GetCalculationDate()).Returns(new DateTime(2016, 10, 4, 1, 1, 1));

            var monitoringDeliverableStoreMock = new Mock<IMonitoringDeliverableStore>();
            monitoringDeliverableStoreMock
                .Setup(m => m.GetAllocationDeliverablePeriodsForAllocationAndPeriodList(It.IsAny<string>(), It.IsAny<IEnumerable<string>>(), It.IsAny<ConnectionInfo>()))
                .Returns((string allocationNumber, IEnumerable<string> periods, ConnectionInfo connectionInfo) =>
                {
                    return allocationDeliverablePeriods
                            .Where(allocDp => allocDp.ContractAllocationNumber == allocationNumber && periods.Contains(allocDp.Period))
                            .ToList();
                });

            IList<int> enrichedDeliverableList = new[] { 1, 2, 3, 4 };
            List<EnrichedReportedActual> enrichedActuals = new List<EnrichedReportedActual>();
            periodList.ForEach(period => enrichedDeliverableList.ForEach(deliverableCode => enrichedActuals.Add(new EnrichedReportedActual
            {
                Period = period,
                DeliverableCode = deliverableCode.ToString(),
                OrganisationId = "1",
                FundingStreamPeriodCode = "2",
                ContractNumber = "B",
                AllocationStartDate = DateTime.Now,
                AllocationEndDate = DateTime.Now,
                ActualValue = 1,
                ActualVolume = 1
            })));

            enrichedActuals.RemoveAll(actual => actual.Period == "201608");

            GenericSubmissionEnricher genericSubmissionEnricher = new GenericSubmissionEnricher(
                monitoringDeliverableStoreMock.Object,
                _mockDate.Object);

            // act
            enrichedActuals = genericSubmissionEnricher.AddMissingActualsWithZeroValues(enrichedActuals, FundingStreamZeroisationBehaviour.PersistCurrentViewActualsState, ConnectionInfo.CreateDefault());

            // assert
            Assert.AreEqual(8, enrichedActuals.Count, "Missing actuals have not been added");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GenericSubmissionEnricher_Should_ZeroisePastActualsAndFutureActuals_WhenPersistCurrentActualsStateIsFalseAndProcessFutureActualsIsTrue()
        {
            // arrange
            IList<AllocationDeliverablePeriod> allocationDeliverablePeriods = new List<AllocationDeliverablePeriod>();
            IList<string> periodList = new[] { "201608", "201609", "201610", "201611", "201612" };
            IList<int> deliverableList = new[] { 1, 2, 3, 4 };
            periodList.ForEach(period =>
            {
                deliverableList.ForEach(deliverableCode => allocationDeliverablePeriods.Add(new AllocationDeliverablePeriod
                {
                    Period = period,
                    DeliverableCode = deliverableCode,
                    OrganisationId = "1",
                    FundingStreamPeriodCode = "2",
                    UopCode = "",
                    ContractNumber = "B",
                    ContractVersionNumber = 1,
                    ContractSubVersionNumber = 2,
                    AllocationStartDate = DateTime.Now,
                    AllocationEndDate = DateTime.Now
                }));
            });

            _mockDate.Setup(x => x.GetCalculationDate()).Returns(new DateTime(2016, 10, 4, 1, 1, 1));

            Mock<IMonitoringDeliverableStore> monitoringDelStoreMock = new Mock<IMonitoringDeliverableStore>();
            monitoringDelStoreMock.Setup(m => m.GetActiveAllocationDeliverablePeriods(It.IsAny<List<string>>(), It.IsAny<ConnectionInfo>()))
                .Returns(allocationDeliverablePeriods.ToList());

            IList<int> enrichedDeliverableList = new[] { 1, 2, 3, 4 };
            List<EnrichedReportedActual> enrichedActuals = new List<EnrichedReportedActual>();

            IList<string> reportedActualsPeriods = new[] { "201609", "201610" };

            reportedActualsPeriods.ForEach(period => enrichedDeliverableList.ForEach(deliverableCode => enrichedActuals.Add(new EnrichedReportedActual
            {
                Period = period,
                DeliverableCode = deliverableCode.ToString(),
                OrganisationId = "1",
                FundingStreamPeriodCode = "2",
                ContractNumber = "B",
                AllocationStartDate = DateTime.Now,
                AllocationEndDate = DateTime.Now,
                ActualValue = 1,
                ActualVolume = 1
            })));

            GenericSubmissionEnricher genericSubmissionEnricher = new GenericSubmissionEnricher(
                monitoringDelStoreMock.Object,
                _mockDate.Object);

            // act
            enrichedActuals = genericSubmissionEnricher.AddMissingActualsWithZeroValues(enrichedActuals, FundingStreamZeroisationBehaviour.ProcessFutureActuals, ConnectionInfo.CreateDefault());

            // assert
            Assert.AreEqual(20, enrichedActuals.Count, "Missing actuals have not been added");
        }
    }
}
