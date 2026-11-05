namespace ADMonitoringDomain.Endpoint.Tests.Unit
{
    using System.Collections.Generic;
    using System.Linq;
    using BusinessLogic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model;

    [TestClass]
    public class AtomItemMapperTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void MapAllocations_MapsContractNumberAndVersion()
        {
            var result = AtomItemMapper.MapAllocations(
                new Allocation { ContractNumber = "CON-1", ContractVersionNumber = 3 });

            Assert.AreEqual("CON-1", result.contractNumber);
            Assert.AreEqual(3, result.contractVersionNumber);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MapAllocationsForFspCode_MapsFundingStreamPeriodCode()
        {
            var result = AtomItemMapper.MapAllocationsForFspCode(new Allocation { FundingStreamPeriodCode = "ESF1420" });

            Assert.AreEqual("ESF1420", result.FundingStreamPeriodCode);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MapOrganisationIdentifiers_MapsMainAndAlternativeIdentifiers()
        {
            var result = AtomItemMapper.MapOrganisationIdentifiers(
                new OrganisationIdentifer { MainOrganisationIdentifier = "MAIN", OrganisationId = "ALT" });

            Assert.AreEqual("MAIN", result.organisationIdentifier);
            Assert.AreEqual("ALT", result.alternativeOrganisationIdentifiers.AlternativeOrganisationIdentifier.OrganisationIdentifier);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MapDeliverablePayments_GroupsByPeriodInOrderAndDefaultsNullAmountsToZero()
        {
            var payments = new List<DeliverablePayment>
            {
                new DeliverablePayment { Period = "2", DeliverableCode = 10, NetPaymentAmount = 5m },
                new DeliverablePayment
                {
                    Period = "1", DeliverableCode = 11, NetPaymentAmount = 1m, ProfilePaymentAmount = 2m,
                    CappedPaymentAmount = 3m, BalancingPaymentAmount = 4m, ReconciliationPaymentAmount = 6m
                },
                new DeliverablePayment { Period = "1", DeliverableCode = 12, NetPaymentAmount = 7m }
            }.AsQueryable();

            var result = AtomItemMapper.MapDeliverablePayments(payments);

            Assert.AreEqual(2, result.Count);
            Assert.AreEqual("1", result[0].Period);
            Assert.AreEqual(2, result[0].ScheduledPayment.Count);
            Assert.AreEqual(2m, result[0].ScheduledPayment[0].ProfilePayment);
            Assert.AreEqual(3m, result[0].ScheduledPayment[0].CappingPayment);
            Assert.AreEqual(4m, result[0].ScheduledPayment[0].BalancingPayment);
            Assert.AreEqual(6m, result[0].ScheduledPayment[0].ReconciliationPayment);
            Assert.AreEqual(0m, result[0].ScheduledPayment[1].ProfilePayment);
            Assert.AreEqual(0m, result[1].ScheduledPayment[0].BalancingPayment);
            Assert.AreEqual(5m, result[1].ScheduledPayment[0].NetPayment);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MapDeliverablePayments_WithNoPayments_ReturnsEmptyList()
        {
            Assert.AreEqual(0, AtomItemMapper.MapDeliverablePayments(new List<DeliverablePayment>().AsQueryable()).Count);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MapActualsForCollectionReturnPeriod_GroupsActualsByPeriod()
        {
            var audits = new List<AllocationDeliverablePeriodActualAudit>
            {
                new AllocationDeliverablePeriodActualAudit
                    { CollectionReturnCode = "R04", Period = "1", DeliverableCode = 1, ActualValue = 10.5, ActualVolume = 2 },
                new AllocationDeliverablePeriodActualAudit
                    { CollectionReturnCode = "R04", Period = "1", DeliverableCode = 2, ActualValue = 4, ActualVolume = 1 },
                new AllocationDeliverablePeriodActualAudit
                    { CollectionReturnCode = "R04", Period = "2", DeliverableCode = 1, ActualValue = 1, ActualVolume = 3 }
            };

            var result = AtomItemMapper.MapActualsForCollectionReturnPeriod(audits);

            Assert.AreEqual("R04", result.CollectionReturnCode);
            Assert.AreEqual(2, result.ActualsPeriod.Count);
            Assert.AreEqual(2, result.ActualsPeriod[0].Actual.Count);
            Assert.AreEqual(10.5m, result.ActualsPeriod[0].Actual[0].ActualValue);
            Assert.AreEqual(2, result.ActualsPeriod[0].Actual[0].ActualVolume);
            Assert.AreEqual(3, result.ActualsPeriod[1].Actual[0].ActualVolume);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MapDeliverablesTypes_SetsLegalAndMonitoringFlagsFromFundingStreamPeriodDeliverable()
        {
            var summaries = new List<DeliverablePeriodSummary>
            {
                new DeliverablePeriodSummary
                {
                    DeliverableCode = 1, Period = "1", PlannedValue = 5m, PlannedVolumne = 2,
                    FundingStreamPeriodDeliverable = new FundingStreamPeriodDeliverable { AllowProfile = false }
                },
                new DeliverablePeriodSummary { DeliverableCode = 1, Period = "2" },
                new DeliverablePeriodSummary { DeliverableCode = 2, Period = "1" }
            };

            var result = AtomItemMapper.MapDeliverablesTypes(summaries);

            Assert.AreEqual(2, result.Count);
            var first = result.Single(d => d.DeliverableCode == 1);
            Assert.IsFalse(first.isLegal);
            Assert.IsTrue(first.isMonitoring);
            Assert.AreEqual(2, first.ContractDeliverablePeriods.Count);
            Assert.AreEqual(5m, first.ContractDeliverablePeriods[0].PlannedValue);
            Assert.AreEqual(2, first.ContractDeliverablePeriods[0].PlannedVolume);
            Assert.AreEqual(0m, first.ContractDeliverablePeriods[1].PlannedValue);

            var second = result.Single(d => d.DeliverableCode == 2);
            Assert.IsTrue(second.isLegal);
            Assert.IsFalse(second.isMonitoring);
        }
    }
}
