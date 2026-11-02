namespace ContractRequestDomain.Cfs.Tests.Feed
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Cfs.Feed.Dtos;
    using Cfs.Feed.Repositories;
    using Cfs.Feed.Services;
    using Cfs.Infrastructure;
    using Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using MoreLinq;
    using NServiceBus;
    using NServiceBus.Testing;
    using Optional;
    using SFA.FCT.ContractRequestDomain.DataStore;
    using SFA.FCT.ContractRequestDomain.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging.Interfaces;
    using UnitTests.Common;

    [TestClass]
    public class AllocationNotificationServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void AllocationNotificationService_ShouldRequestFirstPageOfFeedWhenNoBookmarkStored()
        {
            // arrange
            Mock<IAllocationNotificationRepository> repositoryMock = new Mock<IAllocationNotificationRepository>();
            repositoryMock
                .Setup(m => m.GetCurrentBookmark(It.IsAny<ConnectionInfo>()))
                .Returns(Task.FromResult(Option.None<Bookmark>()));

            Mock<IAllocationNotificationFeedReader> feedReaderMock = new Mock<IAllocationNotificationFeedReader>();
            feedReaderMock
                .Setup(m => m.GetAtomPage(It.IsAny<int>()))
                .Returns(new AtomPage
                {
                    Link = new[]
                    {
                        new AtomLink
                        {
                            Href = "https://pp-api-calculate-funding.education.gov.uk/api/v1/allocations/notifications?pageRef=1",
                            Rel = "self"
                        }
                    },
                    AtomEntry = new[]
                    {
                        new AtomEntry
                        {
                            Content = new AtomContent
                            {
                                Allocation = new AtomAllocation
                                {
                                    Provider = new AtomProvider()
                                }
                            }
                        }
                    }
                });

            AllocationNotificationService service = new AllocationNotificationService(
                Mock.Of<ILogger>(),
                repositoryMock.Object,
                feedReaderMock.Object);

            // act
            service.ReadLatestNotifications(null, () => Task.FromResult(0)).Wait();

            // assert
            feedReaderMock.Verify(m => m.GetAtomPage(1), Times.Once, "IAllocationNotificationFeedReader was not called for page 1");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationNotificationService_ShouldRequestBookmarkedPageWhenBookmarkStored()
        {
            const int bookmarkedPageNumber = 101;

            // arrange
            Mock<IAllocationNotificationRepository> repositoryMock = new Mock<IAllocationNotificationRepository>();
            repositoryMock
                .Setup(m => m.GetCurrentBookmark(It.IsAny<ConnectionInfo>()))
                .Returns(Task.FromResult(Option.Some(new Bookmark("ALLOC-1", bookmarkedPageNumber))));

            Mock<IAllocationNotificationFeedReader> feedReaderMock = new Mock<IAllocationNotificationFeedReader>();
            feedReaderMock
                .Setup(m => m.GetAtomPage(It.IsAny<int>()))
                .Returns(new AtomPage
                {
                    Link = new[]
                    {
                        new AtomLink
                        {
                            Href = "https://pp-api-calculate-funding.education.gov.uk/api/v1/allocations/notifications?pageRef=1",
                            Rel = "self"
                        }
                    },
                    AtomEntry = new[]
                    {
                        new AtomEntry
                        {
                            Content = new AtomContent
                            {
                                Allocation = new AtomAllocation
                                {
                                    Provider = new AtomProvider()
                                }
                            }
                        }
                    }
                });

            AllocationNotificationService service = new AllocationNotificationService(
                Mock.Of<ILogger>(),
                repositoryMock.Object,
                feedReaderMock.Object);

            // act
            service.ReadLatestNotifications(null, () => Task.FromResult(0)).Wait();

            // assert
            feedReaderMock.Verify(m => m.GetAtomPage(bookmarkedPageNumber), Times.Once, "IAllocationNotificationFeedReader was not called for bookmarked page");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationNotificationService_ShouldStoreLaterItemsAfterBookmarkOnSamePage()
        {
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationNotificationService_ShouldTriggerFurtherReadingWhenPageBeingProcessedIsNotLastPage()
        {
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationNotificationService_ShouldTriggerFurtherReadingWhenBookmarkIsLatestItemOnPage()
        {
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationNotificationService_ShouldAddAllocationNotificationsInOrderOfOldestToLatest()
        {
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AllocationNotificationService_ShouldStoreAllAllocationNotificationsInCorrectOrder()
        {
            IReadOnlyCollection<string> allocationIds = Enumerable.Range(1, 20).Select(i => i.ToString()).ToList();

            // arrange
            using (ContractRequestDbContext context = new ContractRequestDbContext())
            {
                context.AllocationNotifications.RemoveAll();
                context.SaveChanges();
            }

            using (ContractRequestDbContext context = new ContractRequestDbContext())
            {
                Mock<ISessionConnectionFactory> sessionConnectionFactoryMock = new Mock<ISessionConnectionFactory>();
                sessionConnectionFactoryMock
                    .Setup(m => m.GetConnection(It.IsAny<IMessageHandlerContext>()))
                    .Returns(new ConnectionInfo(null, context.Database.Connection));

                Mock<IAllocationNotificationFeedReader> allocationNotificationFeedReaderMock = new Mock<IAllocationNotificationFeedReader>();
                allocationNotificationFeedReaderMock
                    .Setup(m => m.GetAtomPage(It.IsAny<int>()))
                    .Returns(new AtomPage
                    {
                        Link = new[]
                        {
                            new AtomLink
                            {
                                Href = "https://pp-api-calculate-funding.education.gov.uk/api/v1/allocations/notifications?pageRef=1",
                                Rel = "self"
                            }
                        },
                        AtomEntry = allocationIds.Select(id => new AtomEntry
                        {
                            Id = id,
                            Content = new AtomContent
                            {
                                Allocation = new AtomAllocation
                                {
                                    Provider = new AtomProvider { UkPrn = int.Parse(id) },
                                    AllocationVersionNumber = 1
                                }
                            }
                        }).ToArray()
                    });

                AllocationNotificationService allocationNotificationService = new AllocationNotificationService(
                    Mock.Of<ILogger>(),
                    new AllocationNotificationRepository(),
                    allocationNotificationFeedReaderMock.Object);

                // act
                allocationNotificationService.ReadLatestNotifications(
                    sessionConnectionFactoryMock.Object.GetConnection(new TestableMessageHandlerContext()), () => Task.FromResult(0)).Wait();
            }

            // assert
            using (ContractRequestDbContext context = new ContractRequestDbContext())
            {
                IReadOnlyCollection<AllocationNotification> allocationNotifications = context.AllocationNotifications.ToList();
                Assert.AreEqual(allocationIds.Count, allocationNotifications.Count, "Unexpected number of allocation notifications stored");
                allocationIds.ForEach(id => Assert.IsNotNull(allocationNotifications.SingleOrDefault(an => an.AllocationId == id), "Expected allocation notification not stored"));
                Assert.AreEqual("20", allocationNotifications.First().AllocationId, "Incorrect ordering of stored allocation notifications");
                Assert.AreEqual("1", allocationNotifications.Last().AllocationId, "Incorrect ordering of stored allocation notifications");
            }
        }
    }
}
