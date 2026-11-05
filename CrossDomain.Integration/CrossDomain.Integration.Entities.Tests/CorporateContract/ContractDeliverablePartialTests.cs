namespace CrossDomain.Integration.Entities.Tests.CorporateContract
{
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    [TestClass]
    public class ContractDeliverablePartialTests
    {
        private static contractDeliverablePeriodsTypeContractDeliverablePeriod Period(decimal value, int volume, decimal unitCost, bool aggregate = false) =>
            new contractDeliverablePeriodsTypeContractDeliverablePeriod
            {
                plannedValue = value,
                plannedVolume = volume,
                unitCost = unitCost,
                aggregate = aggregate
            };

        private static contractDeliverablesTypeContractDeliverable Deliverable(int code, decimal unitCost, params contractDeliverablePeriodsTypeContractDeliverablePeriod[] periods) =>
            new contractDeliverablesTypeContractDeliverable
            {
                deliverable = new deliverableType { deliverableCode = code },
                unitCost = unitCost,
                contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>(periods)
            };

        [TestMethod, TestCategory("UnitTest")]
        public void Deliverable_Aggregations_SumPeriods()
        {
            var d = Deliverable(1, 2m, Period(10m, 3, 2m), Period(5m, 4, 2m));

            Assert.AreEqual(15m, d.GetDeliverableValue());
            Assert.AreEqual(7, d.GetDeliverableVolume());
            Assert.AreEqual(14m, d.GetDeliverableVolumeCost());
            Assert.AreEqual(2m, d.GetDeliverableUnitCost());
            Assert.AreEqual(7, d.AggregatedPlannedVolume);
            Assert.AreEqual(15m, d.AggregatedPlannedValue);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Deliverable_EqualityAndHash_BasedOnDeliverableCode()
        {
            var a = Deliverable(5, 1m);
            var b = Deliverable(5, 9m);
            var c = Deliverable(6, 1m);

            Assert.IsTrue(a.Equals(b));
            Assert.IsFalse(a.Equals(c));
            Assert.IsFalse(a.Equals("x"));
            Assert.AreEqual(a.GetHashCode(), b.GetHashCode());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliverablePeriod_GetValue_AggregateMismatch_ReturnsZero()
        {
            Assert.AreEqual(0m, Period(10m, 1, 1m, aggregate: false).GetDeliverablePeriodValue(true));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliverablePeriod_GetValue_UsesPlannedValueWhenSet()
        {
            Assert.AreEqual(10m, Period(10m, 3, 2m).GetDeliverablePeriodValue(false));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliverablePeriod_GetValue_ZeroValue_CalculatesFromVolumeAndUnitCost()
        {
            Assert.AreEqual(6m, Period(0m, 3, 2m).GetDeliverablePeriodValue(false));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliverablePeriod_GetValue_ZeroValueAndNoVolume_ReturnsZero()
        {
            Assert.AreEqual(0m, Period(0m, 0, 2m).GetDeliverablePeriodValue(false));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CalculateAndSetPlannedValue_SetsPlannedValue()
        {
            var p = Period(0m, 4, 2.5m);
            p.CalculateAndSetPlannedValue();
            Assert.AreEqual(10m, p.plannedValue);

            var q = Period(7m, 4, 2.5m);
            q.CalculateAndSetPlannedValue();
            Assert.AreEqual(7m, q.plannedValue);
        }
    }
}
