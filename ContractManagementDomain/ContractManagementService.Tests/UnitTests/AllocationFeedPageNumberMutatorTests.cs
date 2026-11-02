using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.ContractManagementService.AtomFeed;

namespace ContractManagementService.Tests.UnitTests
{
    [TestClass, TestCategory("UnitTest")]
    public class AllocationFeedPageNumberMutatorTests
    {
        [TestMethod]
        public void MutatePageNumberIn_ConvertsOneBasedPageToZeroBasedPage()
        {
            var mutator = new AllocationFeedPageNumberMutator();

            Assert.AreEqual(0, mutator.MutatePageNumberIn(1));
            Assert.AreEqual(4, mutator.MutatePageNumberIn(5));
        }

        [TestMethod]
        public void MutatePageNumberOut_ConvertsZeroBasedPageToOneBasedPage()
        {
            var mutator = new AllocationFeedPageNumberMutator();

            Assert.AreEqual(1, mutator.MutatePageNumberOut(0));
            Assert.AreEqual(5, mutator.MutatePageNumberOut(4));
        }
    }
}
