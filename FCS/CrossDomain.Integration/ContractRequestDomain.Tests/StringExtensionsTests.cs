namespace ContractRequestDomain.Tests
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Extensions;

    [TestClass]
    public class StringExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void StringExtensions_ShouldNotTruncateIfLengthLessThanMax()
        {
            const string testStr = "1111";

            string newStr = testStr.Truncate(10);

            Assert.AreEqual(testStr, newStr);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void StringExtensions_ShouldTruncateIfLengthGreaterThanMax()
        {
            const string testStr = "1111";

            string newStr = testStr.Truncate(2);

            Assert.AreEqual("11", newStr);
        }
    }
}
