namespace AllocationDeliveryDomain.Endpoint.Tests.PaymentInstructionValidation
{
    using System.Collections.Generic;
    using System.Data;
    using System.Linq;
    using Endpoint.PaymentInstructionValidation.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class ReportedPaymentEnricherTests
    {
        private const string ContractNumber = "LEVY-1234";
        private const int ContractVersionNumber = 1;
        private const int ContractSubVersionNumber = 2;
        private const string AllocationNumber = "APPS-100";

        private const string ValidOrganisationId = "ORG0000001";
        private const string Ukprn = "10000020";
        private const string ValidFundingStreamPeriodCode = "LEVY1799";

        private const string InvalidOrganisationId = "ORG000002";


        private readonly Mock<IMonitoringDeliverableStore> _mockStore = new Mock<IMonitoringDeliverableStore>();

        [TestInitialize]
        public void SetupTests()
        {
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
                    Period = "201705",
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
                    Period = "201705",
                    Ukprn = Ukprn
                },

                new AllocationDeliverablePeriod
                {
                    ContractNumber = "1",
                    ContractVersionNumber = ContractVersionNumber,
                    ContractSubVersionNumber = ContractSubVersionNumber,
                    ContractAllocationNumber = "1A",
                    DeliverableCode = 1,
                    FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                    OrganisationId = "ABC",
                    Period = "201705",
                    Ukprn = "ABC01"
                },

                new AllocationDeliverablePeriod
                {
                    ContractNumber = "1",
                    ContractVersionNumber = ContractVersionNumber,
                    ContractSubVersionNumber = ContractSubVersionNumber,
                    ContractAllocationNumber = "1A",
                    DeliverableCode = 2,
                    FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                    OrganisationId = "ABC",
                    Period = "201705",
                    Ukprn = "ABC01"
                }


            };

            _mockStore.Setup(s => s.GetActiveAllocationDeliverablePeriods(ValidOrganisationId,
                ValidFundingStreamPeriodCode, null, It.IsAny<ConnectionInfo>()))
                .Returns(allocationDeliverablePeriods.Where(m => m.FundingStreamPeriodCode == ValidFundingStreamPeriodCode && m.Ukprn == Ukprn).ToList());

            _mockStore.Setup(s => s.GetActiveAllocationDeliverablePeriods("ABC",
               ValidFundingStreamPeriodCode,null, It.IsAny<ConnectionInfo>()))
                .Returns(allocationDeliverablePeriods.Where(m => m.FundingStreamPeriodCode == ValidFundingStreamPeriodCode && m.Ukprn == "ABC01").ToList());

            _mockStore.Setup(s => s.GetActiveAllocationDeliverablePeriods(InvalidOrganisationId,
                It.IsAny<string>(),It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(new List<AllocationDeliverablePeriod>());

        }

        [TestMethod, TestCategory("UnitTest")]
        public void Enrich_WhenAllocationFound_ShouldReturnCorrectEnrichedData_When_Period_In_AllocationDeliverablePeriodsTable_Is_Same_In_ReportedData()
        {
            // Arrange
            var actuals = new List<ReportedActual>
            {
                new ReportedActual
                {
                    OrganisationId = ValidOrganisationId,
                    FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                    DeliverableCode = "1",
                    Period = "201705"
                },
                new ReportedActual
                {
                    OrganisationId = ValidOrganisationId,
                    FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                    DeliverableCode = "2",
                    Period = "201705"
                },

            };

            var enricher = new ReportedPaymentEnricher
            {
                DeliverableStore = _mockStore.Object
            };

            var mockConnectionInfo = new Mock<ConnectionInfo>(null, Mock.Of<IDbConnection>());

            // Act
            var enrichedActuals = enricher.Enrich(mockConnectionInfo.Object, actuals).ToArray();

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


        }

        [TestMethod, TestCategory("UnitTest")]
        public void Enrich_WhenAllocationFound_ShouldReturnCorrectEnrichedData_When_Period_In_AllocationDeliverablePeriodsTable_Is_Different_In_ReportedData()
        {
            // Arrange
            var actuals = new List<ReportedActual>
            {
                new ReportedActual
                {
                    OrganisationId = ValidOrganisationId,
                    FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                    DeliverableCode = "1",
                    Period = "201709"
                },
                new ReportedActual
                {
                    OrganisationId = ValidOrganisationId,
                    FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                    DeliverableCode = "2",
                    Period = "201709"
                },
            };

            var enricher = new ReportedPaymentEnricher
            {
                DeliverableStore = _mockStore.Object
            };

            var mockConnectionInfo = new Mock<ConnectionInfo>(null, Mock.Of<IDbConnection>());

            // Act
            var enrichedActuals = enricher.Enrich(mockConnectionInfo.Object, actuals.Where(x => x.OrganisationId == ValidOrganisationId).ToList());

            // Assert
            Assert.AreEqual(2,
                enrichedActuals.Count(),
                $"The number of actuals enriched is incorrect for provider UKPRN - {ValidOrganisationId}");

            Assert.IsTrue(enrichedActuals.Where(x => x.OrganisationId == ValidOrganisationId).All(e => e.Ukprn == Ukprn),
                $"The actuals were not enriched with the correct Ukprn {ValidOrganisationId}");

            Assert.IsTrue(enrichedActuals.Where(x => x.OrganisationId == ValidOrganisationId).All(e => e.ContractNumber == ContractNumber),
                $"The actuals were not enriched with the correct contract number for provider UKPRN - {ValidOrganisationId} ");

            Assert.IsTrue(enrichedActuals.Where(x => x.OrganisationId == ValidOrganisationId).All(e => e.ContractAllocationNumber == AllocationNumber),
                $"The actuals were not enriched with the correct allocation number for provider UKPRN - {ValidOrganisationId}");

            Assert.IsTrue(enrichedActuals.All(e => e.ContractVersion == ContractVersionNumber),
                $"The actuals were not enriched with the correct contract version number for provider UKPRN - {ValidOrganisationId}");

            Assert.IsTrue(enrichedActuals.All(e => e.ContractSubVersion == ContractSubVersionNumber),
                $"The actuals were not enriched with the correct contract sub version number for provider UKPRN - {ValidOrganisationId}");

            Assert.IsTrue(enrichedActuals.All(e => e.Period == "201709"),
                $"The actuals were not enriched with the correct period for provider UKPRN - {ValidOrganisationId}");

        }

        [TestMethod, TestCategory("UnitTest")]
        public void Enrich_WhenAllocationFound_ShouldReturnCorrectEnrichedData_When_Period_In_AllocationDeliverablePeriodsTable_Is_Different_And_For_Multiple_Allocations_In_ReportedData()
        {
            // Arrange
            var actuals = new List<ReportedActual>
            {
                new ReportedActual
                {
                    OrganisationId = ValidOrganisationId,
                    FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                    DeliverableCode = "1",
                    Period = "201709"
                },
                new ReportedActual
                {
                    OrganisationId = ValidOrganisationId,
                    FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                    DeliverableCode = "2",
                    Period = "201709"
                },
                new ReportedActual
                {
                    OrganisationId = "ABC",
                    FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                    DeliverableCode = "1",
                    Period = "201709"
                },
                new ReportedActual
                {
                    OrganisationId = "ABC",
                    FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                    DeliverableCode = "2",
                    Period = "201709"
                }
            };

            var enricher = new ReportedPaymentEnricher
            {
                DeliverableStore = _mockStore.Object
            };

            var mockConnectionInfo = new Mock<ConnectionInfo>(null, Mock.Of<IDbConnection>());

            // Act
            var enrichedActuals = enricher.Enrich(mockConnectionInfo.Object, actuals.Where(x => x.OrganisationId == ValidOrganisationId).ToList());

            // Assert
            Assert.AreEqual(2,
                enrichedActuals.Count(),
                $"The number of actuals enriched is incorrect for provider UKPRN - {ValidOrganisationId}");

            Assert.IsTrue(enrichedActuals.Where(x => x.OrganisationId == ValidOrganisationId).All(e => e.Ukprn == Ukprn),
                $"The actuals were not enriched with the correct Ukprn {ValidOrganisationId}");

            Assert.IsTrue(enrichedActuals.Where(x => x.OrganisationId == ValidOrganisationId).All(e => e.ContractNumber == ContractNumber),
                $"The actuals were not enriched with the correct contract number for provider UKPRN - {ValidOrganisationId} ");

            Assert.IsTrue(enrichedActuals.Where(x => x.OrganisationId == ValidOrganisationId).All(e => e.ContractAllocationNumber == AllocationNumber),
                $"The actuals were not enriched with the correct allocation number for provider UKPRN - {ValidOrganisationId}");

            Assert.IsTrue(enrichedActuals.All(e => e.ContractVersion == ContractVersionNumber),
                $"The actuals were not enriched with the correct contract version number for provider UKPRN - {ValidOrganisationId}");

            Assert.IsTrue(enrichedActuals.All(e => e.ContractSubVersion == ContractSubVersionNumber),
                $"The actuals were not enriched with the correct contract sub version number for provider UKPRN - {ValidOrganisationId}");

            Assert.IsTrue(enrichedActuals.All(e => e.Period == "201709"),
                $"The actuals were not enriched with the correct period for provider UKPRN - {ValidOrganisationId}");

            // Act
            enrichedActuals = enricher.Enrich(mockConnectionInfo.Object, actuals.Where(x => x.OrganisationId == "ABC").ToList());

            // Assert
            Assert.AreEqual(2,
                enrichedActuals.Count(),
                "The number of actuals enriched is incorrect for provider UKPRN - ABC01");

            Assert.IsTrue(enrichedActuals.All(e => e.Ukprn == "ABC01"),
                "The actuals were not enriched with the correct Ukprn - ABC01");

            Assert.IsTrue(enrichedActuals.All(e => e.ContractNumber == "1"),
                "The actuals were not enriched with the correct contract number for provider UKPRN - ABC01");

            Assert.IsTrue(enrichedActuals.All(e => e.ContractAllocationNumber == "1A"),
                "The actuals were not enriched with the correct allocation number for provider UKPRN - ABC01");

            Assert.IsTrue(enrichedActuals.All(e => e.ContractVersion == ContractVersionNumber),
                "The actuals were not enriched with the correct contract version number for provider UKPRN - ABC01");

            Assert.IsTrue(enrichedActuals.All(e => e.ContractSubVersion == ContractSubVersionNumber),
                "The actuals were not enriched with the correct contract sub version number for provider UKPRN - ABC01");

            Assert.IsTrue(enrichedActuals.All(e => e.Period == "201709"),
                "The actuals were not enriched with the correct period for provider UKPRN - ABC01");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ReportedPaymentEnricher_ShouldNotReturnAnyPaymentsIfNoValidAllocationDeliverablePeriodsFound()
        {
            // arrange
            Mock<IMonitoringDeliverableStore> monitoringDeliverableStoreMock = new Mock<IMonitoringDeliverableStore>();

            // return an empty list - no valid adp found
            monitoringDeliverableStoreMock.Setup(m => 
                m.GetActiveAllocationDeliverablePeriods(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(new List<AllocationDeliverablePeriod>());

            IReportedPaymentEnricher reportedPaymentEnricher = new ReportedPaymentEnricher()
            {
                DeliverableStore = monitoringDeliverableStoreMock.Object
            };

            List<ReportedActual> paymentInstructions = new List<ReportedActual>
            {
                new ReportedActual
                {
                    OrganisationId = ValidOrganisationId,
                    FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                    DeliverableCode = "1",
                    Period = "201705"
                },
                new ReportedActual
                {
                    OrganisationId = ValidOrganisationId,
                    FundingStreamPeriodCode = ValidFundingStreamPeriodCode,
                    DeliverableCode = "2",
                    Period = "201705"
                }
            };

            var mockConnectionInfo = new Mock<ConnectionInfo>(null, Mock.Of<IDbConnection>());

            // act
            var enrichedPaymentInstructions = reportedPaymentEnricher.Enrich(mockConnectionInfo.Object, paymentInstructions);

            Assert.IsFalse(enrichedPaymentInstructions.Any(), "Enriched Payment instructions were returned");
        }
    }
}