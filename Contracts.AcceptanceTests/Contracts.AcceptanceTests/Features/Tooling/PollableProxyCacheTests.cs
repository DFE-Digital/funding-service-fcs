namespace SFA.FCT.Contracts.AcceptanceTests.Features.Tooling
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Utilities;

    [TestClass]
    public class PollableProxyCacheTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void PollableProxyCache_GetItemIfAvailable_ShouldReturnItemWhenItemAvailableAfterItemWasInitiallyUnavailable()
        {
            // arrange
            PollableProxyCache<TestType> proxyCache = new PollableProxyCache<TestType>();
            const string key = "Key1";

            TestType firstReturnValue = proxyCache.GetItemIfAvailable(key, () => null);
            Assert.IsNull(firstReturnValue);

            TestType secondReturnValue = proxyCache.GetItemIfAvailable(key, () => new TestType());
            Assert.IsNotNull(secondReturnValue);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PollableProxyCache_GetItemIfAvailable_ShouldReturnSameCachedInstanceForSameKey()
        {
            // arrange
            PollableProxyCache<TestType> proxyCache = new PollableProxyCache<TestType>();
            const string key = "Key1";

            TestType firstReturnValue = proxyCache.GetItemIfAvailable(key, () => new TestType());
            TestType secondReturnValue = proxyCache.GetItemIfAvailable(key, () => new TestType());

            Assert.AreSame(firstReturnValue, secondReturnValue);
        }

        private class TestType
        {
        }
    }
}
