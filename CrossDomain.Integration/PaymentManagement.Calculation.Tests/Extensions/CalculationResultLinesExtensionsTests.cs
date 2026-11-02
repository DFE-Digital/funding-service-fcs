namespace PaymentManagement.Calculation.Tests.Extensions
{
    using System.Collections.Generic;
    using System.Linq;
    using Calculation.Dtos;
    using Calculation.Extensions;
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.AllocationActuals;

    [TestClass]
    public class CalculationResultLinesExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CalculationResultLinesExtensions_ShouldReturnPaymentSchedule()
        {
            // arrange
            List<CalculationResultLine> lines = new List<CalculationResultLine>
            {
                new CalculationResultLine(202001, 1, 10, 11, 12, 13, 14),
                new CalculationResultLine(202001, 2, 10, 11, 12, 13, 14),
                new CalculationResultLine(202001, 3, 10, 11, 12, 13, 14)
            };

            ContractAllocationActualsType contractAllocationActualsType = new ContractAllocationActualsType
            {
                ContractAllocationNumber = "AAC-1013",
                ContractReference = new ContractReferenceType
                {
                    ContractNumber = "MAIN-1234",
                    ContractSubVersionNumber = 2,
                    ContractVersionNumber = 1
                },
                ContractorReference = new OrganisationReferenceType
                {
                    OrganisationIdentifier = "1234",
                    AlternativeOrganisationIdentifiers = new List<organisationIdentifiersOrganisationIdentifier>
                    {
                        new organisationIdentifiersOrganisationIdentifier
                        {
                            organisationIdentifier = "ukprn",
                            organisationIdentifierType = organisationIdentifierType.UKPROVIDERREFERENCENUMBER
                        }
                    }
                },
                FundingStreamPeriodCode = "FSP1"
            };

            var fspDeliverableInfos = new List<FspDeliverableInfo>
            {
                new FspDeliverableInfo(1, true, null, -1),
                new FspDeliverableInfo(2, true, null, -1),
                new FspDeliverableInfo(3, true, null, -1)
            };

            var cappingGroups = new List<CappingGroup>
            {
                new CappingGroup(9000, true, false),
                new CappingGroup(9000, false, true),
                new CappingGroup(9000, false, false)
            };

            // act
            var paymentSchedule = lines.ToPaymentSchedule(contractAllocationActualsType.ToCalculationAllocationInput(fspDeliverableInfos, cappingGroups));

            // assert
            Assert.AreEqual(contractAllocationActualsType.ContractReference.ContractNumber, paymentSchedule.ContractNumber, "The contract number is not set");
            Assert.AreEqual(contractAllocationActualsType.ContractReference.ContractVersionNumber, paymentSchedule.VersionNumber, "The contract version is not set");
            Assert.AreEqual(contractAllocationActualsType.FundingStreamPeriodCode, paymentSchedule.FundingStreamPeriodCode, "The FundingStreamPeriodCode is not set");
            Assert.AreEqual(contractAllocationActualsType.ContractAllocationNumber, paymentSchedule.AllocationNumber, "The AllocationNumber is not set");
            Assert.AreEqual(3, paymentSchedule.AllocationDeliverables.Count, "The number of deliverables is not correct");
            lines.ForEach(l =>
            {
                var deliverable = paymentSchedule.AllocationDeliverables.Single(d => d.DeliverableCode == l.DeliverableCode)
                    .ScheduledPayments.Single(p => p.Period == l.Period.ToString());
                Assert.AreEqual(l.ProfileValue, deliverable.ProfilePaymentAmount, $"The ProfilePaymentAmount is not correct for deliverableCode {l.DeliverableCode} and period {l.Period}");
                Assert.AreEqual(l.CappedPaymentAmount, deliverable.CappedPaymentAmount, $"The CappedPaymentAmount is not correct for deliverableCode {l.DeliverableCode} and period {l.Period}");
                Assert.AreEqual(l.BalancingPaymentAmount, deliverable.BalancingPaymentAmount, $"The BalancingPaymentAmount is not correct for deliverableCode {l.DeliverableCode} and period {l.Period}");
                Assert.AreEqual(l.ReconciliationPaymentAmount, deliverable.ReconciliationPaymentAmount, $"The ReconciliationPaymentAmount is not correct for deliverableCode {l.DeliverableCode} and period {l.Period}");
                Assert.AreEqual(l.NetPaymentAmount, deliverable.NetPaymentAmount, $"The NetPaymentAmount is not correct for deliverableCode {l.DeliverableCode} and period {l.Period}");
            });
            Assert.AreEqual(contractAllocationActualsType.ContractorReference.OrganisationIdentifier, paymentSchedule.Organisation.MainOrganisationIdentifier, "The MainOrganisationIdentifier is not correct");
            Assert.AreEqual(contractAllocationActualsType.ContractorReference.AlternativeOrganisationIdentifiers[0].organisationIdentifier, paymentSchedule.Organisation.OrganisationIdentifiers[0].OrganisationId, "The OrganisationId (ukprn) is not correct");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CalculationResultLinesExtensions_StaggerPaymentsIfNecessary_ShouldReturnTheSameCollectionWhenStaggerIsFalse()
        {
            // arrange
            List<CalculationResultLine> lines = new List<CalculationResultLine>
            {
                new CalculationResultLine(202001, 1, 10, 11, 12, 13, 14),
                new CalculationResultLine(202001, 2, 10, 11, 12, 13, 14),
                new CalculationResultLine(202001, 3, 10, 11, 12, 13, 14)
            };

            // act
            var linesReturned = lines.StaggerPaymentsIfNecessary(false, 202109);

            // assert
            lines.SequenceEqual(linesReturned).Should().BeTrue();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CalculationResultLinesExtensions_StaggerPaymentsIfNecessary_ShouldReturnStaggeredPaymentsWhenStaggerIsTrue()
        {
            // arrange
            const int currentPeriod = 202109;
            var lineValues = new List<(int period, decimal? reconciliationValue, decimal? balancingPayment)>
            {
                (202108, -100, null),
                (currentPeriod, -1242.55M, null),
                (202110, 0, 10),
                (202111, 0, null),
                (202112, 0, null),
                (202201, 0, null),
                (202202, 0, null),
                (202203, 0, null),
                (202204, 0, null),
                (202205, 0, null),
                (202206, 0, null),
                (202207, 0, null)
            };

            var lines = lineValues
                .Select(v => new CalculationResultLine(v.period, 1, 0, 0, v.balancingPayment, v.reconciliationValue, 0))
                .ToList();

            // act
            var staggeredPayments = lines.StaggerPaymentsIfNecessary(true, currentPeriod);

            // assert
            staggeredPayments.Single(sp => sp.Period == currentPeriod).ReconciliationPaymentAmount.Should().Be(-310.63M);
            staggeredPayments.Single(sp => sp.Period == 202110).ReconciliationPaymentAmount.Should().Be(-310.63M);
            staggeredPayments.Single(sp => sp.Period == 202111).ReconciliationPaymentAmount.Should().Be(-310.63M);
            staggeredPayments.Single(sp => sp.Period == 202112).ReconciliationPaymentAmount.Should().Be(-310.66M);
            staggeredPayments.Single(sp => sp.Period == 202109).NetPaymentAmount.Should().Be(-310.63M);
            staggeredPayments.Single(sp => sp.Period == 202110).NetPaymentAmount.Should().Be(-300.63M);
            staggeredPayments.Single(sp => sp.Period == 202111).NetPaymentAmount.Should().Be(-310.63M);
            staggeredPayments.Single(sp => sp.Period == 202112).NetPaymentAmount.Should().Be(-310.66M);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CalculationResultLinesExtensions_StaggerPaymentsIfNecessary_ShouldReturnStaggeredPaymentsWhenCurrentPeriodIsBeyondTheEndOfTheContract()
        {
            // arrange
            const int currentPeriod = 202210;
            var lineValues = new List<(int period, decimal? reconciliationValue, decimal? balancingPayment)>
            {
                (202108, -100, null),
                (202108, 0, null),
                (202110, 0, 10),
                (202111, 0, null),
                (202112, 0, null),
                (202201, 0, null),
                (202202, 0, null),
                (202203, 0, null),
                (202204, 0, null),
                (202205, 0, null),
                (202206, 0, null),
                (202207, 0, null),
                (currentPeriod, -1242.55M, null),
            };

            var lines = lineValues
                .Select(v => new CalculationResultLine(v.period, 1, 0, 0, v.balancingPayment, v.reconciliationValue, 0))
                .ToList();

            // act
            var staggeredPayments = lines.StaggerPaymentsIfNecessary(true, currentPeriod);

            // assert
            staggeredPayments.Single(sp => sp.Period == currentPeriod).ReconciliationPaymentAmount.Should().Be(-310.63M);
            staggeredPayments.Single(sp => sp.Period == 202211).ReconciliationPaymentAmount.Should().Be(-310.63M);
            staggeredPayments.Single(sp => sp.Period == 202212).ReconciliationPaymentAmount.Should().Be(-310.63M);
            staggeredPayments.Single(sp => sp.Period == 202301).ReconciliationPaymentAmount.Should().Be(-310.66M);
            staggeredPayments.Single(sp => sp.Period == currentPeriod).NetPaymentAmount.Should().Be(-310.63M);
            staggeredPayments.Single(sp => sp.Period == 202211).NetPaymentAmount.Should().Be(-310.63M);
            staggeredPayments.Single(sp => sp.Period == 202212).NetPaymentAmount.Should().Be(-310.63M);
            staggeredPayments.Single(sp => sp.Period == 202301).NetPaymentAmount.Should().Be(-310.66M);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CalculationResultLinesExtensions_StaggerPaymentsIfNecessary_ShouldPopulateMissingPeriodsOnDeliverableThatDoesntHaveReconciliationValue()
        {
            // arrange
            const int currentPeriod = 202210;
            var lineValues = new List<(int period, decimal? reconciliationValue, decimal? balancingPayment)>
            {
                (202108, -100, null),
                (202108, 0, null),
                (202110, 0, 10),
                (202111, 0, null),
                (202112, 0, null),
                (202201, 0, null),
                (202202, 0, null),
                (202203, 0, null),
                (202204, 0, null),
                (202205, 0, null),
                (202206, 0, null),
                (202207, 0, null),
                (currentPeriod, -1242.55M, null),
            };

            var deliverableOneLines = lineValues
                .Select(v => new CalculationResultLine(v.period, 1, 0, 0, v.balancingPayment, v.reconciliationValue, 0))
                .ToList();

            lineValues = new List<(int period, decimal? reconciliationValue, decimal? balancingPayment)>
            {
                (202108, 0, null),
                (202108, 0, null),
                (202110, 0, null),
                (202111, 0, null),
                (202112, 0, null),
                (202201, 0, null),
                (202202, 0, null),
                (202203, 0, null),
                (202204, 0, null),
                (202205, 0, null),
                (202206, 0, null),
                (202207, 0, null),
                (currentPeriod, 0, null),
            };

            var deliverableTwoLines = lineValues
                .Select(v => new CalculationResultLine(v.period, 2, 0, 0, v.balancingPayment, v.reconciliationValue, 0))
                .ToList();

            var allLines = deliverableOneLines.Concat(deliverableTwoLines).ToList();
            // act
            var staggeredPayments = allLines.StaggerPaymentsIfNecessary(true, currentPeriod);

            // assert
            var staggeredDeliverableTwoPayments = staggeredPayments.Where(sp => sp.DeliverableCode == 2).ToList();
            staggeredDeliverableTwoPayments.Count.Should().Be(16);
            staggeredDeliverableTwoPayments.Single(sp => sp.Period == 202211).ReconciliationPaymentAmount.Should().Be(0);
            staggeredDeliverableTwoPayments.Single(sp => sp.Period == 202212).ReconciliationPaymentAmount.Should().Be(0);
            staggeredDeliverableTwoPayments.Single(sp => sp.Period == 202301).ReconciliationPaymentAmount.Should().Be(0);
        }
    }
}
