namespace FCT.Operations.Cda.Tests
{
    using System.Linq;
    using Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class BatchTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void BatchShouldWork()
        {
            var batches = Enumerable.Range(0, 21).Batch(6);

            Assert.AreEqual(4, batches.Count(), "The number of batches is incorrect");
            Assert.AreEqual(6, batches.First().Count(), "The number in the first batch is incorrect");
            Assert.AreEqual(3, batches.Skip(3).First().Count(), "The number in the last batch is incorrect");
        }
    }
}
