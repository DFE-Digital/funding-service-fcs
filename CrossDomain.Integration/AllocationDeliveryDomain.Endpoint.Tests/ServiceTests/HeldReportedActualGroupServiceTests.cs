namespace AllocationDeliveryDomain.Endpoint.Tests.ServiceTests
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Dto;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Services;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using System;

    [TestClass]
    public class HeldReportedActualGroupServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void HeldReportedActualGroupService_ShouldGetThePartitionKeysWhenTheHeldFspsMatchTheConfig()
        {
            // arrange
            const string testFsp = "Some FSP";
            const string testOrgId = "org1";
            const string testUop = "uop";
            Mock<IHeldReportedActualGroupQueryRepository> heldReportedActualGroupQueryRepositoryMock = new Mock<IHeldReportedActualGroupQueryRepository>();
            heldReportedActualGroupQueryRepositoryMock.Setup(r => r.GetHeldAllocationGrps(It.IsAny<ConnectionInfo>()))
                .Returns(new List<AllocationGrpWithCollectionReturns>
                {
                    new AllocationGrpWithCollectionReturns(testFsp, testOrgId, testUop ,new List<CollectionReturnWithPartitionKey>
                    {
                        new CollectionReturnWithPartitionKey(collectionReturnCode:"CR1", collectionType: "CT1", partitionKey: "PK1"),
                        new CollectionReturnWithPartitionKey(collectionReturnCode: "CR2", collectionType: "CT2", partitionKey: "PK2"),
                    })
                });

            Mock<IAzureRepository<ActualsCollectionTypeSummary>> azureActualsCollectionTypeSummaryRepositoryMock = new Mock<IAzureRepository<ActualsCollectionTypeSummary>>();
            azureActualsCollectionTypeSummaryRepositoryMock.Setup(r => r.GetRows())
                .Returns(new List<ActualsCollectionTypeSummary>());

            Mock<IHeldFspCollectionConfigRepository> configRepositoryMock = new Mock<IHeldFspCollectionConfigRepository>();
            configRepositoryMock.Setup(r => r.GetCollectionReturns(It.IsAny<ConnectionInfo>(), testFsp)).ReturnsAsync(
                new List<IReadOnlyCollection<CollectionReturn>>
                {
                    new List<CollectionReturn>
                    {
                        new CollectionReturn("CR1", "CT1"),
                        new CollectionReturn("CR2", "CT2")
                    }
                });

            var closedCollectionRepositoryMock = new Mock<IClosedCollectionRepository>();
            closedCollectionRepositoryMock.Setup(cc => cc.GetClosedCollections())
                .Returns(new List<ClosedCollection>());

            HeldReportedActualGroupService heldReportedActualGroupService = new HeldReportedActualGroupService(heldReportedActualGroupQueryRepositoryMock.Object,
                azureActualsCollectionTypeSummaryRepositoryMock.Object,
                configRepositoryMock.Object, closedCollectionRepositoryMock.Object);

            // act
            IReadOnlyCollection<HeldActualsForAllocationGrpIdentifier> partitionKeyCollections = heldReportedActualGroupService.GetPartitionKeyGroups(new ConnectionInfo(null, null));

            // assert
            Assert.AreEqual(1, partitionKeyCollections.Count, "The number of collections of partition keys is incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void HeldReportedActualGroupService_ShouldGetThePartitionKeys_EmptyList_WhenTheHeldFspsAreOneCollectionShort()
        {
            // arrange
            const string testFsp = "Some FSP";
            const string testOrgId = "org1";
            const string testUop = "uop";
            Mock<IHeldReportedActualGroupQueryRepository> heldReportedActualGroupQueryRepositoryMock = new Mock<IHeldReportedActualGroupQueryRepository>();
            heldReportedActualGroupQueryRepositoryMock.Setup(r => r.GetHeldAllocationGrps(It.IsAny<ConnectionInfo>()))
                .Returns(new List<AllocationGrpWithCollectionReturns>
                {
                    new AllocationGrpWithCollectionReturns(testFsp, testOrgId, testUop, new List<CollectionReturnWithPartitionKey>
                    {
                        new CollectionReturnWithPartitionKey(collectionReturnCode:"CR1", collectionType: "CT1", partitionKey: "PK1")
                    })
                });

            Mock<IAzureRepository<ActualsCollectionTypeSummary>> azureActualsCollectionTypeSummaryRepositoryMock = new Mock<IAzureRepository<ActualsCollectionTypeSummary>>();
            azureActualsCollectionTypeSummaryRepositoryMock.Setup(r => r.GetRows())
                .Returns(new List<ActualsCollectionTypeSummary>
                {
                    new ActualsCollectionTypeSummary("CT2", "CR2", totalRows: 21),
                    new ActualsCollectionTypeSummary("CT3", "CR3", totalRows: 10)
                });

            Mock<IHeldFspCollectionConfigRepository> configRepositoryMock = new Mock<IHeldFspCollectionConfigRepository>();
            configRepositoryMock.Setup(r => r.GetCollectionReturns(It.IsAny<ConnectionInfo>(), testFsp)).ReturnsAsync(
                new List<IReadOnlyCollection<CollectionReturn>>
                {
                    new List<CollectionReturn>
                    {
                        new CollectionReturn("CR1", "CT1"),
                        new CollectionReturn("CR2", "CT2")
                    }
                });

            var closedCollectionRepositoryMock = new Mock<IClosedCollectionRepository>();
            closedCollectionRepositoryMock.Setup(cc => cc.GetClosedCollections())
                .Returns(new List<ClosedCollection>());


            HeldReportedActualGroupService heldReportedActualGroupService = new HeldReportedActualGroupService(heldReportedActualGroupQueryRepositoryMock.Object,
                azureActualsCollectionTypeSummaryRepositoryMock.Object,
                configRepositoryMock.Object, closedCollectionRepositoryMock.Object);

            // act
            IReadOnlyCollection<HeldActualsForAllocationGrpIdentifier> partitionKeyCollections = heldReportedActualGroupService.GetPartitionKeyGroups(new ConnectionInfo(null, null));

            // assert
            Assert.AreEqual(0, partitionKeyCollections.Count, "The number of collections of partition keys is incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void HeldReportedActualGroupService_ShouldGetThePartitionKeys_WhenTheHeldFspsAreOneCollectionShort_ButTheAzureTableHasTheMissingOne()
        {
            // arrange
            const string testFsp = "Some FSP";
            const string testOrgId = "org1";
            const string testUop = "uop";
            Mock<IHeldReportedActualGroupQueryRepository> heldReportedActualGroupQueryRepositoryMock = new Mock<IHeldReportedActualGroupQueryRepository>();
            heldReportedActualGroupQueryRepositoryMock.Setup(r => r.GetHeldAllocationGrps(It.IsAny<ConnectionInfo>()))
                .Returns(new List<AllocationGrpWithCollectionReturns>
                {
                    new AllocationGrpWithCollectionReturns(testFsp, testOrgId, testUop, new List<CollectionReturnWithPartitionKey>
                    {
                        new CollectionReturnWithPartitionKey(collectionReturnCode:"CR1", collectionType: "CT1", partitionKey: "PK1"),
                    })
                });

            Mock<IAzureRepository<ActualsCollectionTypeSummary>> azureActualsCollectionTypeSummaryRepositoryMock = new Mock<IAzureRepository<ActualsCollectionTypeSummary>>();
            azureActualsCollectionTypeSummaryRepositoryMock.Setup(r => r.GetRows())
                .Returns(new List<ActualsCollectionTypeSummary>
                {
                    new ActualsCollectionTypeSummary("CT2", "CR2", totalRows: 0),
                    new ActualsCollectionTypeSummary("CT3", "CR3", totalRows: 10)
                });

            Mock<IHeldFspCollectionConfigRepository> configRepositoryMock = new Mock<IHeldFspCollectionConfigRepository>();
            configRepositoryMock.Setup(r => r.GetCollectionReturns(It.IsAny<ConnectionInfo>(), testFsp)).ReturnsAsync(
                new List<IReadOnlyCollection<CollectionReturn>>
                {
                    new List<CollectionReturn>
                    {
                        new CollectionReturn("CR1", "CT1"),
                        new CollectionReturn("CR2", "CT2")
                    }
                });

            var closedCollectionRepositoryMock = new Mock<IClosedCollectionRepository>();
            closedCollectionRepositoryMock.Setup(cc => cc.GetClosedCollections())
                .Returns(new List<ClosedCollection>());

            HeldReportedActualGroupService heldReportedActualGroupService = new HeldReportedActualGroupService(heldReportedActualGroupQueryRepositoryMock.Object,
                azureActualsCollectionTypeSummaryRepositoryMock.Object,
                configRepositoryMock.Object, closedCollectionRepositoryMock.Object);

            // act
            IReadOnlyCollection<HeldActualsForAllocationGrpIdentifier> partitionKeyCollections = heldReportedActualGroupService.GetPartitionKeyGroups(new ConnectionInfo(null, null));

            // assert
            Assert.AreEqual(1, partitionKeyCollections.Count, "The number of collections of partition keys is incorrect");
            Assert.IsFalse(partitionKeyCollections.First().PartitionKeys.Contains(null), "The partition group contains empty PKs");
            Assert.AreEqual(1, partitionKeyCollections.First().PartitionKeys.Count, "The number partition keys is incorrect");
            Assert.IsTrue(partitionKeyCollections.First().PartitionKeys.Contains("PK1"), "The partition group does not contain the correct PK");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void HeldReportedActualGroupService_ShouldGetThePartitionKeys_WhenTheHeldFspsAreOneCollectionShort_ButThePaasClosedCollectionsTableHasTheMissingOne()
        {
            // arrange
            const string testFsp = "Some FSP";
            const string testOrgId = "org1";
            const string testUop = "uop";

            var heldReportedActualGroupQueryRepositoryMock = new Mock<IHeldReportedActualGroupQueryRepository>();
            heldReportedActualGroupQueryRepositoryMock.Setup(r => r.GetHeldAllocationGrps(It.IsAny<ConnectionInfo>()))
                .Returns(new List<AllocationGrpWithCollectionReturns>
                {
                    new AllocationGrpWithCollectionReturns(testFsp, testOrgId, testUop, new List<CollectionReturnWithPartitionKey>
                    {
                        new CollectionReturnWithPartitionKey(collectionReturnCode:"CR1", collectionType: "CT1", partitionKey: "PK1"),
                    })
                });

            var azureActualsCollectionTypeSummaryRepositoryMock = new Mock<IAzureRepository<ActualsCollectionTypeSummary>>();
            azureActualsCollectionTypeSummaryRepositoryMock.Setup(r => r.GetRows())
                .Returns(new List<ActualsCollectionTypeSummary>());

            var configRepositoryMock = new Mock<IHeldFspCollectionConfigRepository>();
            configRepositoryMock.Setup(r => r.GetCollectionReturns(It.IsAny<ConnectionInfo>(), testFsp)).ReturnsAsync(
                new List<IReadOnlyCollection<CollectionReturn>>
                {
                    new List<CollectionReturn>
                    {
                        new CollectionReturn("CR1", "CT1"),
                        new CollectionReturn("CR2", "CT2")
                    }
                });

            var closedCollectionRepositoryMock = new Mock<IClosedCollectionRepository>();
            closedCollectionRepositoryMock.Setup(cc => cc.GetClosedCollections())
                .Returns(new List<ClosedCollection>
                    {
                        new ClosedCollection("CT2", "CR2", new DateTime(2020, 01, 31), 0),
                        new ClosedCollection("CT3", "CR3", new DateTime(2020, 01, 31), 10)
                    }
                );

            var heldReportedActualGroupService = new HeldReportedActualGroupService(heldReportedActualGroupQueryRepositoryMock.Object,
                azureActualsCollectionTypeSummaryRepositoryMock.Object,
                configRepositoryMock.Object, closedCollectionRepositoryMock.Object);

            // act
            var partitionKeyCollections = heldReportedActualGroupService.GetPartitionKeyGroups(new ConnectionInfo(null, null));

            // assert
            Assert.AreEqual(1, partitionKeyCollections.Count, "The number of collections of partition keys is incorrect");
            Assert.IsFalse(partitionKeyCollections.First().PartitionKeys.Contains(null), "The partition group contains empty PKs");
            Assert.AreEqual(1, partitionKeyCollections.First().PartitionKeys.Count, "The number partition keys is incorrect");
            Assert.IsTrue(partitionKeyCollections.First().PartitionKeys.Contains("PK1"), "The partition group does not contain the correct PK");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void HeldReportedActualGroupService_ShouldGetThePartitionKeys_WhenThereAreTwoHeldFsps_ThatMatchTheConfig_ButOneOfTheCollectionsDoesNotMatchConfigSoShouldNotAppearInResults()
        {
            // arrange
            const string testFsp = "Some FSP";
            const string testFsp2 = "Some FSP2";
            const string testOrgId = "org1";
            const string testOrgId2 = "org2";
            const string testUop = "uop";
            Mock<IHeldReportedActualGroupQueryRepository> heldReportedActualGroupQueryRepositoryMock = new Mock<IHeldReportedActualGroupQueryRepository>();
            heldReportedActualGroupQueryRepositoryMock.Setup(r => r.GetHeldAllocationGrps(It.IsAny<ConnectionInfo>()))
                .Returns(new List<AllocationGrpWithCollectionReturns>
                {
                    new AllocationGrpWithCollectionReturns(testFsp, testOrgId, testUop, new List<CollectionReturnWithPartitionKey>
                    {
                        new CollectionReturnWithPartitionKey(collectionReturnCode:"CR1", collectionType: "CT1", partitionKey: "PK1"),
                        new CollectionReturnWithPartitionKey(collectionReturnCode: "CR2", collectionType: "CT2", partitionKey: "PK2"),
                    }),
                    new AllocationGrpWithCollectionReturns(testFsp2, testOrgId, testUop, new List<CollectionReturnWithPartitionKey>
                    {
                        new CollectionReturnWithPartitionKey(collectionReturnCode:"CR3", collectionType: "CT3", partitionKey: "PK3"),
                        new CollectionReturnWithPartitionKey(collectionReturnCode: "CR4", collectionType: "CT4", partitionKey: "PK4"),
                    }),
                    new AllocationGrpWithCollectionReturns(testFsp2, testOrgId2, testUop, new List<CollectionReturnWithPartitionKey>
                    {
                        new CollectionReturnWithPartitionKey(collectionReturnCode:"CR5", collectionType: "CT5", partitionKey: "PK5"),
                        new CollectionReturnWithPartitionKey(collectionReturnCode: "CR6", collectionType: "CT6", partitionKey: "PK6"),
                    })
                });

            Mock<IAzureRepository<ActualsCollectionTypeSummary>> azureActualsCollectionTypeSummaryRepositoryMock = new Mock<IAzureRepository<ActualsCollectionTypeSummary>>();
            azureActualsCollectionTypeSummaryRepositoryMock.Setup(r => r.GetRows())
                .Returns(new List<ActualsCollectionTypeSummary>
                {
                    new ActualsCollectionTypeSummary("CT5", "CR5", totalRows: 0),
                    new ActualsCollectionTypeSummary("CT3", "CR3", totalRows: 10)
                });

            Mock<IHeldFspCollectionConfigRepository> configRepositoryMock = new Mock<IHeldFspCollectionConfigRepository>();
            configRepositoryMock.Setup(r => r.GetCollectionReturns(It.IsAny<ConnectionInfo>(), testFsp)).ReturnsAsync(
                new List<IReadOnlyCollection<CollectionReturn>>
                {
                    new List<CollectionReturn>
                    {
                        new CollectionReturn("CR1", "CT1"),
                        new CollectionReturn("CR2", "CT2")
                    }
                });
            configRepositoryMock.Setup(r => r.GetCollectionReturns(It.IsAny<ConnectionInfo>(), testFsp2)).ReturnsAsync(
                new List<IReadOnlyCollection<CollectionReturn>>
                {
                    new List<CollectionReturn>
                    {
                        new CollectionReturn("CR3", "CT3"),
                        new CollectionReturn("CR4", "CT4")
                    }
                });

            var closedCollectionRepositoryMock = new Mock<IClosedCollectionRepository>();
            closedCollectionRepositoryMock.Setup(cc => cc.GetClosedCollections())
                .Returns(new List<ClosedCollection>());


            HeldReportedActualGroupService heldReportedActualGroupService = new HeldReportedActualGroupService(heldReportedActualGroupQueryRepositoryMock.Object,
                azureActualsCollectionTypeSummaryRepositoryMock.Object,
                configRepositoryMock.Object, closedCollectionRepositoryMock.Object);

            // act
            IReadOnlyCollection<HeldActualsForAllocationGrpIdentifier> partitionKeyGroups = heldReportedActualGroupService.GetPartitionKeyGroups(new ConnectionInfo(null, null));

            // assert
            Assert.AreEqual(2, partitionKeyGroups.Count, "The number of collections of partition keys is incorrect");

            Assert.IsTrue(partitionKeyGroups.Any(pkCollection => pkCollection.PartitionKeys.Contains("PK4") && pkCollection.PartitionKeys.Contains("PK3")), "No group contains PK4 and PK4");
            Assert.IsTrue(partitionKeyGroups.Any(pkCollection => pkCollection.PartitionKeys.Contains("PK1") && pkCollection.PartitionKeys.Contains("PK2")), "No group contains PK1 and PK2");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void HeldReportedActualGroupService_ShouldGetThePartitionKeys_WhenThereAreLotsOfHeldFsps_Where2MatchTheConfig()
        {
            // arrange
            const string testFsp = "Some FSP";
            const string testOrgId = "org1";
            const string testUop = "uop";
            const string testOrgId2 = "org2";
            const string testUop2 = "uop2";
            Mock<IHeldReportedActualGroupQueryRepository> heldReportedActualGroupQueryRepositoryMock = new Mock<IHeldReportedActualGroupQueryRepository>();
            heldReportedActualGroupQueryRepositoryMock.Setup(r => r.GetHeldAllocationGrps(It.IsAny<ConnectionInfo>()))
                .Returns(new List<AllocationGrpWithCollectionReturns>
                {
                    new AllocationGrpWithCollectionReturns(testFsp, testOrgId, testUop, new List<CollectionReturnWithPartitionKey>
                    {
                        new CollectionReturnWithPartitionKey(collectionReturnCode:"CR1", collectionType: "CT1", partitionKey: "PK1"),
                        new CollectionReturnWithPartitionKey(collectionReturnCode: "CR2", collectionType: "CT2", partitionKey: "PK2")
                    }),
                    new AllocationGrpWithCollectionReturns(testFsp, testOrgId2, testUop2, new List<CollectionReturnWithPartitionKey>
                    {
                        new CollectionReturnWithPartitionKey(collectionReturnCode:"CR1", collectionType: "CT1", partitionKey: "PK3"),
                        new CollectionReturnWithPartitionKey(collectionReturnCode: "CR2", collectionType: "CT2", partitionKey: "PK4")
                    })
                });

            Mock<IAzureRepository<ActualsCollectionTypeSummary>> azureActualsCollectionTypeSummaryRepositoryMock = new Mock<IAzureRepository<ActualsCollectionTypeSummary>>();
            azureActualsCollectionTypeSummaryRepositoryMock.Setup(r => r.GetRows())
                .Returns(new List<ActualsCollectionTypeSummary>
                {
                    new ActualsCollectionTypeSummary("CT7", "CR7", totalRows: 0),
                    new ActualsCollectionTypeSummary("CT3", "CR3", totalRows: 10)
                });

            Mock<IHeldFspCollectionConfigRepository> configRepositoryMock = new Mock<IHeldFspCollectionConfigRepository>();
            configRepositoryMock.Setup(r => r.GetCollectionReturns(It.IsAny<ConnectionInfo>(), testFsp)).ReturnsAsync(
                new List<IReadOnlyCollection<CollectionReturn>>
                {
                    new List<CollectionReturn>
                    {
                        new CollectionReturn("CR1", "CT1"),
                        new CollectionReturn("CR2", "CT2")
                    }
                });

            var closedCollectionRepositoryMock = new Mock<IClosedCollectionRepository>();
            closedCollectionRepositoryMock.Setup(cc => cc.GetClosedCollections())
                .Returns(new List<ClosedCollection>());

            HeldReportedActualGroupService heldReportedActualGroupService = new HeldReportedActualGroupService(
                heldReportedActualGroupQueryRepositoryMock.Object,
                azureActualsCollectionTypeSummaryRepositoryMock.Object,
                configRepositoryMock.Object, closedCollectionRepositoryMock.Object);

            // act
            IReadOnlyCollection<HeldActualsForAllocationGrpIdentifier> partitionKeyGroups = heldReportedActualGroupService.GetPartitionKeyGroups(new ConnectionInfo(null, null));

            // assert
            Assert.AreEqual(2, partitionKeyGroups.Count, "The number of collections of partition keys is incorrect");

            Assert.IsTrue(partitionKeyGroups.Any(pkCollection => pkCollection.PartitionKeys.Contains("PK1") && pkCollection.PartitionKeys.Contains("PK2")), "No group contains PK1 and PK2");
            Assert.IsTrue(partitionKeyGroups.Any(pkCollection => pkCollection.PartitionKeys.Contains("PK3") && pkCollection.PartitionKeys.Contains("PK4")), "No group contains PK3 and PK4");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void HeldReportedActualGroupService_ShouldGetThePartitionKeys_WhenThereAreLotsOfHeldFsps_Where2MatchTheConfigButForDifferentOrgs()
        {
            // arrange
            const string testFsp = "Some FSP";
            const string testOrgId = "org1";
            const string testUop = "uop";
            const string testOrgId2 = "org2";
            const string testUop2 = "uop2";
            Mock<IHeldReportedActualGroupQueryRepository> heldReportedActualGroupQueryRepositoryMock = new Mock<IHeldReportedActualGroupQueryRepository>();
            heldReportedActualGroupQueryRepositoryMock.Setup(r => r.GetHeldAllocationGrps(It.IsAny<ConnectionInfo>()))
                .Returns(new List<AllocationGrpWithCollectionReturns>
                {
                    new AllocationGrpWithCollectionReturns(testFsp, testOrgId, testUop, new List<CollectionReturnWithPartitionKey>
                    {
                        new CollectionReturnWithPartitionKey(collectionReturnCode:"CR1", collectionType: "CT1", partitionKey: "PK1"),
                    }),
                    new AllocationGrpWithCollectionReturns(testFsp, testOrgId2, testUop2, new List<CollectionReturnWithPartitionKey>
                    {
                        new CollectionReturnWithPartitionKey(collectionReturnCode: "CR2", collectionType: "CT2", partitionKey: "PK4")
                    })
                });

            Mock<IAzureRepository<ActualsCollectionTypeSummary>> azureActualsCollectionTypeSummaryRepositoryMock = new Mock<IAzureRepository<ActualsCollectionTypeSummary>>();
            azureActualsCollectionTypeSummaryRepositoryMock.Setup(r => r.GetRows())
                .Returns(new List<ActualsCollectionTypeSummary>
                {
                    new ActualsCollectionTypeSummary("CT7", "CR7", totalRows: 0),
                    new ActualsCollectionTypeSummary("CT3", "CR3", totalRows: 10)
                });

            Mock<IHeldFspCollectionConfigRepository> configRepositoryMock = new Mock<IHeldFspCollectionConfigRepository>();
            configRepositoryMock.Setup(r => r.GetCollectionReturns(It.IsAny<ConnectionInfo>(), testFsp)).ReturnsAsync(
                new List<IReadOnlyCollection<CollectionReturn>>
                {
                    new List<CollectionReturn>
                    {
                        new CollectionReturn("CR1", "CT1"),
                        new CollectionReturn("CR2", "CT2")
                    }
                });

            var closedCollectionRepositoryMock = new Mock<IClosedCollectionRepository>();
            closedCollectionRepositoryMock.Setup(cc => cc.GetClosedCollections())
                .Returns(new List<ClosedCollection>());

            HeldReportedActualGroupService heldReportedActualGroupService = new HeldReportedActualGroupService(heldReportedActualGroupQueryRepositoryMock.Object,
                azureActualsCollectionTypeSummaryRepositoryMock.Object,
                configRepositoryMock.Object, closedCollectionRepositoryMock.Object);

            // act
            IReadOnlyCollection<HeldActualsForAllocationGrpIdentifier> partitionKeyGroups = heldReportedActualGroupService.GetPartitionKeyGroups(new ConnectionInfo(null, null));

            // assert
            Assert.AreEqual(2, partitionKeyGroups.Count, "The number of collections of partition keys is incorrect");

            Assert.IsTrue(partitionKeyGroups.Any(pkCollection => pkCollection.PartitionKeys.Contains("PK1")), "No group contains PK1");
            Assert.IsTrue(partitionKeyGroups.Any(pkCollection => pkCollection.PartitionKeys.Contains("PK4")), "No group contains PK4");
        }
    }
}
