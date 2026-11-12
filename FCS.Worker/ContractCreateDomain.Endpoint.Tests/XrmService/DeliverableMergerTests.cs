namespace ContractCreateDomain.Endpoint.Tests.XrmService
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Endpoint.XrmService.DTOs;
    using Endpoint.XrmService.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class DeliverableMergerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void MergeDeliverables_ReturnsTheCurrentDeliverables()
        {
            var current = new List<Deliverable> { BuildDeliverable("D1", BuildPeriod(2016, 1)) };

            IList<Deliverable> result = DeliverableMerger.MergeDeliverables(current, new List<Deliverable>());

            Assert.AreSame(current, result);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MergeDeliverables_NoMatchingPreviousDeliverable_LeavesPeriodUnchanged()
        {
            DeliverablePeriod period = BuildPeriod(2016, 1);
            var current = new List<Deliverable> { BuildDeliverable("D1", period) };
            var previous = new List<Deliverable> { BuildDeliverable("OTHER", BuildPeriod(2016, 1, actualValue: 5m)) };

            DeliverableMerger.MergeDeliverables(current, previous);

            Assert.IsFalse(period.Modified);
            Assert.IsNull(period.ActualValue);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MergeDeliverables_NoMatchingPreviousPeriod_LeavesPeriodUnchanged()
        {
            DeliverablePeriod period = BuildPeriod(2016, 1);
            var current = new List<Deliverable> { BuildDeliverable("D1", period) };
            var previous = new List<Deliverable> { BuildDeliverable("D1", BuildPeriod(2016, 2, actualValue: 5m)) };

            DeliverableMerger.MergeDeliverables(current, previous);

            Assert.IsFalse(period.Modified);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MergeDeliverables_CurrentPeriodHasNoActuals_CopiesAllValuesFromPreviousPeriod()
        {
            DeliverablePeriod period = BuildPeriod(2016, 1);
            var current = new List<Deliverable> { BuildDeliverable("D1", period) };
            Guid capping = Guid.NewGuid(), profile = Guid.NewGuid(), reconciliation = Guid.NewGuid();
            DeliverablePeriod previousPeriod = BuildPeriod(2016, 1, actualValue: 10m);
            previousPeriod.ActualVolume = 3;
            previousPeriod.BalancingPaymentValue = 1m;
            previousPeriod.CappedPaymentValue = 2m;
            previousPeriod.NetPaymentValue = 3m;
            previousPeriod.PaymentPosted = true;
            previousPeriod.ProfilePaymentValue = 4m;
            previousPeriod.ReconciliationPaymentValue = 5m;
            previousPeriod.CappingSubnominalId = capping;
            previousPeriod.ProfileSubnominalId = profile;
            previousPeriod.ReconcilliationSubnominalId = reconciliation;
            var previous = new List<Deliverable> { BuildDeliverable("D1", previousPeriod) };

            DeliverableMerger.MergeDeliverables(current, previous);

            Assert.IsTrue(period.Modified);
            Assert.AreEqual(10m, period.ActualValue);
            Assert.AreEqual(3, period.ActualVolume);
            Assert.AreEqual(1m, period.BalancingPaymentValue);
            Assert.AreEqual(2m, period.CappedPaymentValue);
            Assert.AreEqual(3m, period.NetPaymentValue);
            Assert.AreEqual(true, period.PaymentPosted);
            Assert.AreEqual(4m, period.ProfilePaymentValue);
            Assert.AreEqual(5m, period.ReconciliationPaymentValue);
            Assert.AreEqual(capping, period.CappingSubnominalId);
            Assert.AreEqual(profile, period.ProfileSubnominalId);
            Assert.AreEqual(reconciliation, period.ReconcilliationSubnominalId);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MergeDeliverables_CurrentPeriodHasZeroActuals_StillTakesPreviousValues()
        {
            DeliverablePeriod period = BuildPeriod(2016, 1, actualValue: 0m);
            period.ActualVolume = 0;
            var current = new List<Deliverable> { BuildDeliverable("D1", period) };
            var previous = new List<Deliverable> { BuildDeliverable("D1", BuildPeriod(2016, 1, actualValue: 7m)) };

            DeliverableMerger.MergeDeliverables(current, previous);

            Assert.IsTrue(period.Modified);
            Assert.AreEqual(7m, period.ActualValue);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MergeDeliverables_CurrentPeriodHasActualValue_IsNotOverwritten()
        {
            DeliverablePeriod period = BuildPeriod(2016, 1, actualValue: 4m);
            var current = new List<Deliverable> { BuildDeliverable("D1", period) };
            var previous = new List<Deliverable> { BuildDeliverable("D1", BuildPeriod(2016, 1, actualValue: 9m)) };

            DeliverableMerger.MergeDeliverables(current, previous);

            Assert.IsFalse(period.Modified);
            Assert.AreEqual(4m, period.ActualValue);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MergeDeliverables_CurrentPeriodHasActualVolume_IsNotOverwritten()
        {
            DeliverablePeriod period = BuildPeriod(2016, 1);
            period.ActualVolume = 2;
            var current = new List<Deliverable> { BuildDeliverable("D1", period) };
            var previous = new List<Deliverable> { BuildDeliverable("D1", BuildPeriod(2016, 1, actualValue: 9m)) };

            DeliverableMerger.MergeDeliverables(current, previous);

            Assert.IsFalse(period.Modified);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MergeDeliverables_PreviousPeriodWithOnlyVolume_IsIgnored()
        {
            DeliverablePeriod period = BuildPeriod(2016, 1);
            DeliverablePeriod previousPeriod = BuildPeriod(2016, 1);
            previousPeriod.ActualVolume = 6;
            var current = new List<Deliverable> { BuildDeliverable("D1", period) };
            var previous = new List<Deliverable> { BuildDeliverable("D1", previousPeriod) };

            DeliverableMerger.MergeDeliverables(current, previous);

            Assert.IsFalse(period.Modified);
            Assert.IsNull(period.ActualVolume);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MergeDeliverables_PreviousPeriodIdenticalToCurrent_IsNotMarkedModified()
        {
            DeliverablePeriod period = BuildPeriod(2016, 1);
            var current = new List<Deliverable> { BuildDeliverable("D1", period) };
            var previous = new List<Deliverable> { BuildDeliverable("D1", BuildPeriod(2016, 1)) };

            DeliverableMerger.MergeDeliverables(current, previous);

            Assert.IsFalse(period.Modified);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MergeDeliverables_OnlyChangedSubnominalDiffers_CopiesAndMarksModified()
        {
            DeliverablePeriod period = BuildPeriod(2016, 1);
            DeliverablePeriod previousPeriod = BuildPeriod(2016, 1);
            previousPeriod.ProfileSubnominalId = Guid.NewGuid();
            var current = new List<Deliverable> { BuildDeliverable("D1", period) };
            var previous = new List<Deliverable> { BuildDeliverable("D1", previousPeriod) };

            DeliverableMerger.MergeDeliverables(current, previous);

            Assert.IsTrue(period.Modified);
            Assert.AreEqual(previousPeriod.ProfileSubnominalId, period.ProfileSubnominalId);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MergeDeliverables_MergesEachDeliverableAgainstItsOwnPrevious()
        {
            DeliverablePeriod first = BuildPeriod(2016, 1);
            DeliverablePeriod second = BuildPeriod(2016, 1);
            var current = new List<Deliverable> { BuildDeliverable("D1", first), BuildDeliverable("D2", second) };
            var previous = new List<Deliverable>
            {
                BuildDeliverable("D1", BuildPeriod(2016, 1, actualValue: 1m)),
                BuildDeliverable("D2", BuildPeriod(2016, 1, actualValue: 2m))
            };

            DeliverableMerger.MergeDeliverables(current, previous);

            Assert.AreEqual(1m, first.ActualValue);
            Assert.AreEqual(2m, second.ActualValue);
        }

        private static Deliverable BuildDeliverable(string code, params DeliverablePeriod[] periods)
        {
            return new Deliverable { DeliverableCode = code, DeliverablePeriods = periods.ToList() };
        }

        private static DeliverablePeriod BuildPeriod(int year, int periodNumber, decimal? actualValue = null)
        {
            return new DeliverablePeriod { Year = year, PeriodNumber = periodNumber, ActualValue = actualValue };
        }
    }
}
