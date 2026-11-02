namespace ContractCreateDomain.Integration.XrmService.Tests.Unit
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.Integration.XrmService.Entities;

    [TestClass]
    public class DeliverableHelperTest
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CanMerge()
        {
            var current = SetupTest(0);
            var previous = SetupTest(100);

            var mergedDeliverables = DeliverableHelper.MergeDeliverables(current, previous);

            foreach (var p in previous)
            {
                var merged = mergedDeliverables.FirstOrDefault(m => m.DeliverableCode.Equals(p.DeliverableCode));

                Assert.IsTrue(merged != null, "Merged deliverable does not exist for deliverable code {0}", p.DeliverableCode);

                foreach (var pd in p.DeliverablePeriods)
                {
                    var mpd = merged.DeliverablePeriods.FirstOrDefault(mp => mp.PeriodNumber.Equals(pd.PeriodNumber) && mp.Year.Equals(pd.Year));

                    Assert.IsTrue(mpd != null, "Merged period does not exist for deliverable code {0}", p.DeliverableCode);
                    Assert.IsTrue(pd.ActualValue.Equals(mpd.ActualValue), "Actual value is not merged for deliverable code {0}, period {1}, year, {2}, should be {3}, actually {4}", p.DeliverableCode, pd.PeriodNumber, pd.Year, pd.ActualValue, mpd.ActualValue);
                    Assert.IsTrue(pd.ActualVolume.Equals(mpd.ActualVolume), "ActualVolume is not merged, should be {0}, actually {1}", pd.ActualVolume, mpd.ActualVolume);
                }
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CanMergeWithSomeNullsAndExistingValues()
        {
            var current = SetupTest(0);
            var previous = SetupTest(100);

            var p1 = previous.FirstOrDefault(p => p.DeliverableCode.Equals("1"));

            Assert.IsTrue(p1 != null, "Merged deliverable does not exist for deliverable code {0}", "1");

            foreach (var pd in p1.DeliverablePeriods)
            {
                pd.ActualValue = null;
            }

            // check that current values not overwritten
            var p2 = previous.FirstOrDefault(p => p.DeliverableCode.Equals("2"));

            Assert.IsTrue(p2 != null, "Merged deliverable does not exist for deliverable code {0}", "2");
            decimal value = 17;
            foreach (var pd in p2.DeliverablePeriods)
            {
                pd.ActualValue = value;
                value += 17;
            }

            var mergedDeliverables = DeliverableHelper.MergeDeliverables(current, previous);

            foreach (var p in previous)
            {
                var merged = mergedDeliverables.FirstOrDefault(m => m.DeliverableCode.Equals(p.DeliverableCode));

                Assert.IsTrue(merged != null, "Merged deliverable does not exist for deliverable code {0}", p.DeliverableCode);

                // check deliverables for code 1 not modified
                if (p.DeliverableCode.Equals("1") || p.DeliverableCode.Equals("2"))
                {
                    Assert.IsFalse(p.DeliverablePeriods.Any(pd => pd.Modified.Equals(true)), "Deliverable Periods for deliverable code {0} were modified", p.DeliverableCode);
                }

                foreach (var pd in p.DeliverablePeriods)
                {
                    var mpd = merged.DeliverablePeriods.FirstOrDefault(mp => mp.PeriodNumber.Equals(pd.PeriodNumber) && mp.Year.Equals(pd.Year));

                    Assert.IsTrue(mpd != null, "Merged period does not exist for deliverable code {0}", p.DeliverableCode);
                    Assert.IsTrue(pd.ActualValue.Equals(mpd.ActualValue), "Actual value is not merged for deliverable code {0}, period {1}, year, {2}, should be {3}, actually {4}", p.DeliverableCode, pd.PeriodNumber, pd.Year, pd.ActualValue, mpd.ActualValue);
                    Assert.IsTrue(pd.ActualVolume.Equals(mpd.ActualVolume), "ActualVolume is not merged, should be {0}, actually {1}", pd.ActualVolume, mpd.ActualVolume);
                }
            }
        }

        private List<Deliverable> SetupTest(decimal actual)
        {
            var deliverables = new List<Deliverable>();

            for (int i = 1; i <= 12; i++)
            {
                var d = new Deliverable
                {
                    DeliverableCode = i.ToString(),
                    Id = new Guid()
                };

                for (int p = 1; p <= 12; p++)
                {
                    var dp = new DeliverablePeriod
                    {
                        Year = 2015,
                        PeriodNumber = p,
                        ActualValue = actual
                    };

                    d.DeliverablePeriods.Add(dp);
                }

                deliverables.Add(d);
            }

            return deliverables;
        }
    }
}
