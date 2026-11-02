namespace AllocationDeliveryDomain.Endpoint.Tests.ActualsPull
{
    using Endpoint.ActualsPull;
    using Endpoint.ActualsPull.Adapters;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;

    [TestClass]
    public class DcAdapterExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void DcAdapterExtensions_GetNumPages_ShouldRoundUpAnyDecimalToNextPage()
        {
            int totalNumRows = 11;
            int pageSize = 10;

            IDcAdapter adapter = new DcStubAdapter(null, Mock.Of<IEnvironmentContext>());

            // act
            int numPages = adapter.GetNumPages(totalNumRows, pageSize);

            // assert
            Assert.AreEqual(2, numPages);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DcAdapterExtensions_GetNumPages_ShouldReturnZeroWhenTotalNumRowsIsZero()
        {
            int totalNumRows = 0;
            int pageSize = 10;

            IDcAdapter adapter = new DcStubAdapter(null, Mock.Of<IEnvironmentContext>());

            // act
            int numPages = adapter.GetNumPages(totalNumRows, pageSize);

            // assert
            Assert.AreEqual(0, numPages);
        }
    }
}
