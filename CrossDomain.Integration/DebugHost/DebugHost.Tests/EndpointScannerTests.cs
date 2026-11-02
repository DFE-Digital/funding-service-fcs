namespace SFA.FCT.FCTDebugHost.Tests
{
    using System;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class EndpointScannerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void EndpointScanner_ShouldFindTheExpectedEndpoint()
        {
            // act
            Type[] types = EndpointScanner.GetEndpointTypes();

            // assert
            Assert.IsTrue(types.Contains(typeof(EndpointForScannerTestToFind)), "No types returned from scanner");
        }
    }
}
