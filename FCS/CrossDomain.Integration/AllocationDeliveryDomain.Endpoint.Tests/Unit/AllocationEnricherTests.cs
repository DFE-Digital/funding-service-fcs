namespace AllocationDeliveryDomain.Endpoint.Tests.Unit
{
    using System.Collections.Generic;
    using System.Linq;
    using BusinessLogic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class ActualEnricherTests
    {
        private const string ContractNumber = "MAIN-1234";
        private const int ContractVersionNumber = 1;
        private const int ContractSubVersionNumber = 2;
        private const string AllocationNumber = "CL-100";
        private const string ESFAllocationNumber = "ESF-100";
        private const string ValidOrganisationId = "ORG0000001";
        private const string Ukprn = "10000020";
        private const string ValidFundingStreamPeriodCode = "CL1516";
        private const string ValidESFFundingStreamPeriodCode = "ESF1516";
        private const string InvalidOrganisationId = "ORG000002";

        private readonly Mock<IMonitoringDeliverableStore> _mockStore = new Mock<IMonitoringDeliverableStore>();

        [TestInitialize]
        public void SetupTests()
        {
            AutoMapper.Mapper.Reset();

            var allocationDeliverablePeriods = new List<AllocationDeliverablePeriod>
            {
                new AllocationDeliverablePeriod
                {
                    ContractNumber = ContractNumber,
                    ContractVersionNumber = ContractVersionNumber,
                    ContractSubVersionNumber = ContractSubVersionNumber,
                    ContractAllocationNumber = AllocationNumber,
                    DeliverableCode = 1,
                    FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                    OrganisationId = ValidOrganisationId,
                    Period = "201508",
                    Ukprn = Ukprn
                },
                new AllocationDeliverablePeriod
                {
                    ContractNumber = ContractNumber,
                    ContractVersionNumber = ContractVersionNumber,
                    ContractSubVersionNumber = ContractSubVersionNumber,
                    ContractAllocationNumber = AllocationNumber,
                    DeliverableCode = 1,
                    FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                    OrganisationId = ValidOrganisationId,
                    Period = "201509",
                    Ukprn = Ukprn
                },
                new AllocationDeliverablePeriod
                {
                    ContractNumber = ContractNumber,
                    ContractVersionNumber = ContractVersionNumber,
                    ContractSubVersionNumber = ContractSubVersionNumber,
                    ContractAllocationNumber = AllocationNumber,
                    DeliverableCode = 1,
                    FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                    OrganisationId = ValidOrganisationId,
                    Period = "201510",
                    Ukprn = Ukprn
                },
                new AllocationDeliverablePeriod
                {
                    ContractNumber = ContractNumber,
                    ContractVersionNumber = ContractVersionNumber,
                    ContractSubVersionNumber = ContractSubVersionNumber,
                    ContractAllocationNumber = AllocationNumber,
                    DeliverableCode = 2,
                    FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                    OrganisationId = ValidOrganisationId,
                    Period = "201508",
                    Ukprn = Ukprn
                },
                new AllocationDeliverablePeriod
                {
                    ContractNumber = ContractNumber,
                    ContractVersionNumber = ContractVersionNumber,
                    ContractSubVersionNumber = ContractSubVersionNumber,
                    ContractAllocationNumber = AllocationNumber,
                    DeliverableCode = 2,
                    FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                    OrganisationId = ValidOrganisationId,
                    Period = "201509",
                    Ukprn = Ukprn
                },
                new AllocationDeliverablePeriod
                {
                    ContractNumber = ContractNumber,
                    ContractVersionNumber = ContractVersionNumber,
                    ContractSubVersionNumber = ContractSubVersionNumber,
                    ContractAllocationNumber = AllocationNumber,
                    DeliverableCode = 2,
                    FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                    OrganisationId = ValidOrganisationId,
                    Period = "201510",
                    Ukprn = Ukprn
                },

                new AllocationDeliverablePeriod
                {
                    ContractNumber = ContractNumber,
                    ContractVersionNumber = ContractVersionNumber,
                    ContractSubVersionNumber = ContractSubVersionNumber,
                    ContractAllocationNumber = ESFAllocationNumber,
                    DeliverableCode = 1,
                    FundingStreamPeriodCode = ValidESFFundingStreamPeriodCode,
                    OrganisationId = ValidOrganisationId,
                    Period = "201508",
                    Ukprn = Ukprn
                },
                new AllocationDeliverablePeriod
                {
                    ContractNumber = ContractNumber,
                    ContractVersionNumber = ContractVersionNumber,
                    ContractSubVersionNumber = ContractSubVersionNumber,
                    ContractAllocationNumber = ESFAllocationNumber,
                    DeliverableCode = 1,
                    FundingStreamPeriodCode = ValidESFFundingStreamPeriodCode,
                    OrganisationId = ValidOrganisationId,
                    Period = "201509",
                    Ukprn = Ukprn
                },
                new AllocationDeliverablePeriod
                {
                    ContractNumber = ContractNumber,
                    ContractVersionNumber = ContractVersionNumber,
                    ContractSubVersionNumber = ContractSubVersionNumber,
                    ContractAllocationNumber = ESFAllocationNumber,
                    DeliverableCode = 1,
                    FundingStreamPeriodCode = ValidESFFundingStreamPeriodCode,
                    OrganisationId = ValidOrganisationId,
                    Period = "201510",
                    Ukprn = Ukprn
                },
                new AllocationDeliverablePeriod
                {
                    ContractNumber = ContractNumber,
                    ContractVersionNumber = ContractVersionNumber,
                    ContractSubVersionNumber = ContractSubVersionNumber,
                    ContractAllocationNumber = ESFAllocationNumber,
                    DeliverableCode = 2,
                    FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                    OrganisationId = ValidOrganisationId,
                    Period = "201508",
                    Ukprn = Ukprn
                },
                new AllocationDeliverablePeriod
                {
                    ContractNumber = ContractNumber,
                    ContractVersionNumber = ContractVersionNumber,
                    ContractSubVersionNumber = ContractSubVersionNumber,
                    ContractAllocationNumber = ESFAllocationNumber,
                    DeliverableCode = 2,
                    FundingStreamPeriodCode = ValidESFFundingStreamPeriodCode,
                    OrganisationId = ValidOrganisationId,
                    Period = "201509",
                    Ukprn = Ukprn
                },
                new AllocationDeliverablePeriod
                {
                    ContractNumber = ContractNumber,
                    ContractVersionNumber = ContractVersionNumber,
                    ContractSubVersionNumber = ContractSubVersionNumber,
                    ContractAllocationNumber = ESFAllocationNumber,
                    DeliverableCode = 2,
                    FundingStreamPeriodCode = ValidESFFundingStreamPeriodCode,
                    OrganisationId = ValidOrganisationId,
                    Period = "201510",
                    Ukprn = Ukprn
                }
            };

            // in our code the UopCode is defaulted to empty strin
            allocationDeliverablePeriods.ForEach(adp => adp.UopCode = string.Empty);
            _mockStore.Setup(s => s.GetActiveAllocationDeliverablePeriods(ValidOrganisationId,
                ValidFundingStreamPeriodCode,
                null,
                It.IsAny<ConnectionInfo>())).Returns(allocationDeliverablePeriods
                .Where(m => m.FundingStreamPeriodCode == ValidFundingStreamPeriodCode).ToList());

            _mockStore.Setup(s => s.GetActiveAllocationDeliverablePeriods(InvalidOrganisationId,
                It.IsAny<string>(),
                It.IsAny<string>(),
                It.IsAny<ConnectionInfo>())).Returns(new List<AllocationDeliverablePeriod>());

            _mockStore.Setup(s =>
                    s.GetActiveAllocationDeliverablePeriods(It.Is<List<string>>(a =>
                        a.Count == 1 && a.Contains(ESFAllocationNumber)), It.IsAny<ConnectionInfo>()))
                .Returns(allocationDeliverablePeriods
                    .Where(m => m.FundingStreamPeriodCode == ValidESFFundingStreamPeriodCode).ToList());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Enrich_WhenAllocationFound_ShouldReturnCorrectEnrichedActual()
        {
            // Arrange
            var actuals = new List<ReportedActual>
            {
                new ReportedActual
                {
                    OrganisationId = ValidOrganisationId,
                    FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                    DeliverableCode = "1",
                    Period = "201508"
                },
                new ReportedActual
                {
                    OrganisationId = ValidOrganisationId,
                    FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                    DeliverableCode = "2",
                    Period = "201508"
                }
            };

            // Act
            ActualEnricher enricher = new ActualEnricher(_mockStore.Object, Mock.Of<ILogger>());

            var enrichedActuals = enricher.Enrich(actuals, It.IsAny<ConnectionInfo>()).ToArray();

            // Assert
            Assert.AreEqual(2,
                enrichedActuals.Count(),
                "The number of actuals enriched is incorrect");

            Assert.IsTrue(enrichedActuals.All(e => e.Ukprn == Ukprn),
                "The actuals were not enriched with the correct Ukprn");

            Assert.IsTrue(enrichedActuals.All(e => e.ContractNumber == ContractNumber),
                "The actuals were not enriched with the correct contract number");

            Assert.IsTrue(enrichedActuals.All(e => e.ContractAllocationNumber == AllocationNumber),
                "The actuals were not enriched with the correct allocation number");

            Assert.IsTrue(enrichedActuals.All(e => e.ContractVersion == ContractVersionNumber),
                "The actuals were not enriched with the correct contract version number");

            Assert.IsTrue(enrichedActuals.All(e => e.ContractSubVersion == ContractSubVersionNumber),
                "The actuals were not enriched with the correct contract sub version number");

            Assert.IsTrue(enrichedActuals.Single(e => e.EnrichedDeliverableCode == "1") != null,
                "Matching Deliverable Period was not found for Deliverable Code 1");

            Assert.IsTrue(enrichedActuals.Single(e => e.EnrichedDeliverableCode == "2") != null,
                "Matching Deliverable Period was not found for Deliverable Code 2");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Enrich_WhenESFAllocationFound_ShouldReturnCorrectEnrichedActual()
        {
            // Arrange
            var actuals = new List<ReportedActual>
            {
                new ReportedActual
                {
                    OrganisationId = ValidOrganisationId,
                    FundingStreamPeriodCode = ValidESFFundingStreamPeriodCode,
                    DeliverableCode = "1",
                    Period = "201508",
                    ContractAllocationNumber = ESFAllocationNumber
                },
                new ReportedActual
                {
                    OrganisationId = ValidOrganisationId,
                    FundingStreamPeriodCode = ValidESFFundingStreamPeriodCode,
                    DeliverableCode = "2",
                    Period = "201509",
                    ContractAllocationNumber = ESFAllocationNumber
                }
            };

            // Act
            ActualEnricher enricher = new ActualEnricher(_mockStore.Object, Mock.Of<ILogger>());

            var enrichedActuals = enricher.Enrich(actuals, It.IsAny<ConnectionInfo>()).ToArray();

            // Assert
            Assert.AreEqual(2,
                enrichedActuals.Count(),
                "The number of actuals enriched is incorrect");

            Assert.IsTrue(enrichedActuals.All(e => e.Ukprn == Ukprn),
                "The actuals were not enriched with the correct Ukprn");

            Assert.IsTrue(enrichedActuals.All(e => e.ContractNumber == ContractNumber),
                "The actuals were not enriched with the correct contract number");

            Assert.IsTrue(enrichedActuals.All(e => e.ContractAllocationNumber == ESFAllocationNumber),
                "The actuals were not enriched with the correct allocation number");

            Assert.IsTrue(enrichedActuals.All(e => e.ContractVersion == ContractVersionNumber),
                "The actuals were not enriched with the correct contract version number");

            Assert.IsTrue(enrichedActuals.All(e => e.ContractSubVersion == ContractSubVersionNumber),
                "The actuals were not enriched with the correct contract sub version number");

            Assert.IsTrue(enrichedActuals.Single(e => e.EnrichedDeliverableCode == "1") != null,
                "Matching Deliverable Period was not found for Deliverable Code 1");

            Assert.IsTrue(enrichedActuals.Single(e => e.EnrichedDeliverableCode == "2") != null,
                "Matching Deliverable Period was not found for Deliverable Code 2");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ActualEnricher_ShouldNotMapNullAllocationDeliverablePeriodsToEnrichedReportedActuals()
        {
            // arrange
            Mock<IMonitoringDeliverableStore> monitoringDeliverableStoreMock =
                new Mock<IMonitoringDeliverableStore>();

            monitoringDeliverableStoreMock.Setup(m =>
                    m.GetActiveAllocationDeliverablePeriods(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(new List<AllocationDeliverablePeriod>());

            ActualEnricher enricher = new ActualEnricher(_mockStore.Object, Mock.Of<ILogger>());

            var actuals = new List<ReportedActual>
            {
                new ReportedActual
                {
                    OrganisationId = InvalidOrganisationId,
                    FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                    DeliverableCode = "1",
                    Period = "201508"
                },
                new ReportedActual
                {
                    OrganisationId = InvalidOrganisationId,
                    FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                    DeliverableCode = "2",
                    Period = "201508"
                }
            };

            // act
            IEnumerable<EnrichedReportedActual> result = enricher.Enrich(actuals, It.IsAny<ConnectionInfo>());

            // assert
            Assert.IsFalse(result.Any(),
                "Enricher mapped null allocation deliverable periods to enriched reported actuals");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ActualEnricher_ShouldNotMapNullAllocationDeliverablePeriodsToEnrichedReportedActuals_WithMixOfActiveAndInactiveAllocs()
        {
            // arrange
            const string validUopCode = "VALID";
            const string invalidUopCode = "INVALID";
            const string allocationNumber = "alloc1";
            const int validDelCode = 1;
            const string validPeriod = "201508";

            Mock<IMonitoringDeliverableStore> monitoringDeliverableStoreMock =
                new Mock<IMonitoringDeliverableStore>();

            monitoringDeliverableStoreMock.Setup(m =>
                    m.GetActiveAllocationDeliverablePeriods(It.IsAny<string>(), It.IsAny<string>(), invalidUopCode, It.IsAny<ConnectionInfo>()))
                .Returns(new List<AllocationDeliverablePeriod>());

            monitoringDeliverableStoreMock.Setup(m =>
                    m.GetActiveAllocationDeliverablePeriods(It.IsAny<string>(), It.IsAny<string>(), validUopCode, It.IsAny<ConnectionInfo>()))
                .Returns(new List<AllocationDeliverablePeriod>()
                {
                    new AllocationDeliverablePeriod
                    {
                        OrganisationId = ValidOrganisationId,
                        ContractAllocationNumber = allocationNumber,
                        FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                        UopCode = validUopCode,
                        DeliverableCode = validDelCode,
                        Period = validPeriod
                    }
                });

            ActualEnricher enricher = new ActualEnricher(monitoringDeliverableStoreMock.Object, Mock.Of<ILogger>());

            var actuals = new List<ReportedActual>
            {
                new ReportedActual
                {
                    OrganisationId = ValidOrganisationId,
                    FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                    DeliverableCode = validDelCode.ToString(),
                    Period = validPeriod,
                    UoPCode = validUopCode
                },
                new ReportedActual
                {
                    OrganisationId = ValidOrganisationId,
                    FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                    DeliverableCode = validDelCode.ToString(),
                    Period = validPeriod,
                    UoPCode = invalidUopCode
                }
            };

            // act
            List<EnrichedReportedActual> result = enricher.Enrich(actuals, It.IsAny<ConnectionInfo>()).ToList();

            // assert
            Assert.AreEqual(1, result.Count, "Enricher should have enriched exactly 1 actual");
            Assert.AreEqual(result[0].ContractAllocationNumber, allocationNumber, "Enricher mapped the wrong value for Allocation Number");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ActualEnricher_ShouldMatchUopCodeWhenUopCodeInReportedActualIsNull()
        {
            // arrange
            const int delCode = 1;
            const string period = "201508";

            Mock<IMonitoringDeliverableStore> monitoringDeliverableStoreMock =
                new Mock<IMonitoringDeliverableStore>();

            monitoringDeliverableStoreMock.Setup(m =>
                    m.GetActiveAllocationDeliverablePeriods(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(new List<AllocationDeliverablePeriod>
                {
                    new AllocationDeliverablePeriod
                    { 
                        OrganisationId = ValidOrganisationId,
                        FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                        DeliverableCode = delCode,
                        Period = period,
                        UopCode = string.Empty
                    }
                });

            ActualEnricher enricher = new ActualEnricher(monitoringDeliverableStoreMock.Object, Mock.Of<ILogger>());

            var actuals = new List<ReportedActual>
            {
                new ReportedActual
                {
                    OrganisationId = ValidOrganisationId,
                    FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                    DeliverableCode = delCode.ToString(),
                    Period = period,
                    UoPCode = null
                }
            };

            // act
            List<EnrichedReportedActual> result = enricher.Enrich(actuals, It.IsAny<ConnectionInfo>()).ToList();

            // assert
            Assert.AreEqual(1, result.Count, "Enricher should have enriched exactly 1 actual");
        }
    }
}
