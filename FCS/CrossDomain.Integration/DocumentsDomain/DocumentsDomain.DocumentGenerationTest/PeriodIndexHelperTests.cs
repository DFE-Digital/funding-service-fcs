namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests
{
    using System.Linq;
    using DocumentDefiner.DocumentPartCreators;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class PeriodIndexHelperTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void PeriodIndexHelper_Should_ReturnCorrectColumnIndexForEachCalendarMonthPeriod()
        {
            // assert
            Assert.AreEqual(0, PeriodIndexHelper.GetColumnIndexOfPeriod(8));
            Assert.AreEqual(1, PeriodIndexHelper.GetColumnIndexOfPeriod(9));
            Assert.AreEqual(2, PeriodIndexHelper.GetColumnIndexOfPeriod(10));
            Assert.AreEqual(3, PeriodIndexHelper.GetColumnIndexOfPeriod(11));
            Assert.AreEqual(4, PeriodIndexHelper.GetColumnIndexOfPeriod(12));
            Assert.AreEqual(5, PeriodIndexHelper.GetColumnIndexOfPeriod(1));
            Assert.AreEqual(6, PeriodIndexHelper.GetColumnIndexOfPeriod(2));
            Assert.AreEqual(7, PeriodIndexHelper.GetColumnIndexOfPeriod(3));
            Assert.AreEqual(8, PeriodIndexHelper.GetColumnIndexOfPeriod(4));
            Assert.AreEqual(9, PeriodIndexHelper.GetColumnIndexOfPeriod(5));
            Assert.AreEqual(10, PeriodIndexHelper.GetColumnIndexOfPeriod(6));
            Assert.AreEqual(11, PeriodIndexHelper.GetColumnIndexOfPeriod(7));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PeriodIndexHelper_ShouldGetZeroPeriodTotalValuesAugToJuly()
        {
            // assert
            var fullContract = PeriodIndexHelper.GetZeroPeriodTotalValuesAugToJuly(0, 11);

            Assert.AreEqual(12, fullContract.Count);
            Assert.AreEqual(true, fullContract.All(p => p.Value == 0M), "All values are not zero for full contract");

            // act
            var shortContract = PeriodIndexHelper.GetZeroPeriodTotalValuesAugToJuly(5, 6);

            // assert
            Assert.AreEqual(12, shortContract.Count, "a short contract should return a full contract of periods");
            Assert.AreEqual(2, shortContract.Count(p => p.Value == 0M), "a short contract should have 2 periods of zeros");
        }   
    }
}