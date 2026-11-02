namespace AllocationDeliveryDomain.Endpoint.Tests.ActualsPull
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using AllocationDelivery.Messages.DTOs;
    using Endpoint.ActualsPull.Adapters;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;

    [TestClass]
    public class DcStubAdapterTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void DcStubAdapter_ShouldGetClosedCollectionsSinceDate()
        {
            // arrange
            Mock<IAzureTableStore> azureTableStoreMock = new Mock<IAzureTableStore>();
            azureTableStoreMock.Setup(r => r.GetRows<ReportedActual>(It.IsAny<string>())).Returns(
                new List<ReportedActual>
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

            DcStubAdapter dcStubAdapter = new DcStubAdapter(azureTableStoreMock.Object, Mock.Of<IEnvironmentContext>());

            // act
            IReadOnlyCollection<ClosedCollection> closedCollections =
                dcStubAdapter.GetClosedCollectionsSince(DateTime.Now).Result;

            // assert
            Assert.AreEqual(2, closedCollections.Count, "The number of closed collections is not right");
            Assert.AreEqual(1, closedCollections.Count(cc => cc.CollectionType == "ALLF"),
                "The number of ALLF closed collections is not right");
            Assert.AreEqual(1, closedCollections.Count(cc => cc.CollectionType == "APPS"),
                "The number of APPS closed collections is not right");
            Assert.AreEqual(2, closedCollections.Single(cc => cc.CollectionType == "ALLF").TotalRowCount,
                "The number of TotalItems for ALLF closed collections is not right");
            Assert.AreEqual(3, closedCollections.Single(cc => cc.CollectionType == "APPS").TotalRowCount,
                "The number of TotalItems for APPS closed collections is not right");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DcStubAdapter_ShouldGetClosedCollectionsForTheRightPage()
        {
            // arrange
            Mock<IAzureTableStore> azureTableStoreMock = new Mock<IAzureTableStore>();
            azureTableStoreMock.Setup(r => r.GetRows<ReportedActual>(It.IsAny<string>())).Returns(
                new List<ReportedActual>
                {
                    new ReportedActual
                    {
                        CollectionType = "ALLF",
                        CollectionReturnCode = "A53",
                        Period = "202008"
                    },
                    new ReportedActual
                    {
                        CollectionType = "ALLF",
                        CollectionReturnCode = "A53",
                        Period = "202008"
                    },
                    new ReportedActual
                    {
                        CollectionType = "APPS",
                        CollectionReturnCode = "APPS32",
                        DeliverableCode = "1",
                        Period = "202008"
                    },
                    new ReportedActual
                    {
                        CollectionType = "APPS",
                        CollectionReturnCode = "APPS32",
                        DeliverableCode = "2",
                        Period = "202008"
                    },
                    new ReportedActual
                    {
                        CollectionType = "APPS",
                        CollectionReturnCode = "APPS32",
                        DeliverableCode = "3",
                        Period = "202008"
                    },
                    new ReportedActual
                    {
                        CollectionType = "APPS",
                        CollectionReturnCode = "APPS32",
                        DeliverableCode = "4",
                        Period = "202008"
                    },
                    new ReportedActual
                    {
                        CollectionType = "APPS",
                        CollectionReturnCode = "APPS32",
                        DeliverableCode = "5",
                        Period = "202008"
                    },
                    new ReportedActual
                    {
                        CollectionType = "APPS",
                        CollectionReturnCode = "APPS32",
                        DeliverableCode = "6",
                        Period = "202008"
                    }
                });

            DcStubAdapter dcStubAdapter = new DcStubAdapter(azureTableStoreMock.Object, Mock.Of<IEnvironmentContext>());

            // act
            var pageOfActuals = dcStubAdapter.GetClosedCollectionsPage("APPS", "APPS32", 2, 2).Result;

            // assert
            Assert.AreEqual(2, pageOfActuals.Count, "The number of actuals is not right");
            Assert.IsTrue(pageOfActuals.Any(a => a.DeliverableCode == 3), "Deliverable code 3 is not present");
            Assert.IsTrue(pageOfActuals.Any(a => a.DeliverableCode == 4), "Deliverable code 4 is not present");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DcStubAdapter_ShouldGetCorrectNumberOfRowsForPartialPage()
        {
            // arrange
            Mock<IAzureTableStore> azureTableStoreMock = new Mock<IAzureTableStore>();
            azureTableStoreMock.Setup(r => r.GetRows<ReportedActual>(It.IsAny<string>())).Returns(
                new List<ReportedActual>
                {
                    new ReportedActual
                    {
                        CollectionType = "APPS",
                        CollectionReturnCode = "APPS32",
                        DeliverableCode = "1",
                        Period = "202008",
                        UoPCode = string.Empty
                    },
                    new ReportedActual
                    {
                        CollectionType = "APPS",
                        CollectionReturnCode = "APPS32",
                        DeliverableCode = "2",
                        Period = "202008",
                        UoPCode = string.Empty
                    },
                    new ReportedActual
                    {
                        CollectionType = "APPS",
                        CollectionReturnCode = "APPS32",
                        DeliverableCode = "3",
                        Period = "202008",
                        UoPCode = string.Empty
                    }
                });

            DcStubAdapter dcStubAdapter = new DcStubAdapter(azureTableStoreMock.Object, Mock.Of<IEnvironmentContext>());

            // act
            var pageOfActuals = dcStubAdapter.GetClosedCollectionsPage("APPS", "APPS32", 2, 2).Result;

            // assert
            Assert.AreEqual(1, pageOfActuals.Count, "The number of actuals is not right");
            Assert.IsTrue(pageOfActuals.Any(a => a.DeliverableCode == 3), "Deliverable code 3 is not present");
            Assert.IsTrue(pageOfActuals.All(a => a.UopCode == null), "The Uop Code should be null if the reported actuals had an empty string");
        }
    }
}
