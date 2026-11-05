namespace PaymentManagement.Calculation.Tests.Extensions
{
    using System.Collections.Generic;
    using Calculation.Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class ListExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void GetItemAtIndexOrNone_ReturnsItemForValidIndex()
        {
            var items = new List<string> { "first", "second" };

            var result = items.GetItemAtIndexOrNone(1);

            Assert.IsTrue(result.HasValue);
            result.Match(
                some: item => Assert.AreEqual("second", item),
                none: () => Assert.Fail("Expected an item at index 1."));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetItemAtIndexOrNone_ReturnsNoneForOutOfRangeIndexes()
        {
            var items = new List<string> { "first" };

            Assert.IsFalse(items.GetItemAtIndexOrNone(-1).HasValue);
            Assert.IsFalse(items.GetItemAtIndexOrNone(1).HasValue);
        }
    }
}
