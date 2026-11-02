namespace ActualsPull.UnitTest.Adapters
{
    using System;
    using System.Collections.Generic;
    using ActualsPull.Adapters;
    using ActualsPull.StubInfrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using System.Linq;
    using DTOs;

    [TestClass]
    public class DcStubAdapterTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void DcStubAdapter_ShouldGetClosedCollectionsSinceDate()
        {
            // arrange
            Mock<IAzureTableStore> azureTableStoreMock = new Mock<IAzureTableStore>();
            azureTableStoreMock.Setup(r => r.GetAllRows<ReportedActual>(It.IsAny<string>())).ReturnsAsync(new List<ReportedActual>
            {
                new ReportedActual
                {
                    CollectionType = "ALLF",
                    CollectionReturnCode = "A53"
                },
                new ReportedActual
                {
                    CollectionType = "ALLF",
                    CollectionReturnCode = "A53"
                },
                new ReportedActual
                {
                    CollectionType = "APPS",
                    CollectionReturnCode = "APPS32"
                },
                new ReportedActual
                {
                    CollectionType = "APPS",
                    CollectionReturnCode = "APPS32"
                },
                new ReportedActual
                {
                    CollectionType = "APPS",
                    CollectionReturnCode = "APPS32"
                }
            });

            DcStubAdapter dcStubAdapter = new DcStubAdapter(azureTableStoreMock.Object, "table_name");

            // act
            IReadOnlyCollection<ClosedCollection> closedCollections = dcStubAdapter.GetClosedCollectionsSince(DateTime.Now).Result;

            // assert
            Assert.AreEqual(2, closedCollections.Count, "The number of closed collections is not right");
            Assert.AreEqual(1, closedCollections.Count(cc => cc.CollectionType == "ALLF"), "The number of ALLF closed collections is not right");
            Assert.AreEqual(1, closedCollections.Count(cc => cc.CollectionType == "APPS"), "The number of APPS closed collections is not right");
            Assert.AreEqual(2, closedCollections.Single(cc => cc.CollectionType == "ALLF").TotalItems, "The number of TotalItems for ALLF closed collections is not right");
            Assert.AreEqual(3, closedCollections.Single(cc => cc.CollectionType == "APPS").TotalItems, "The number of TotalItems for APPS closed collections is not right");
        }
    }
}
