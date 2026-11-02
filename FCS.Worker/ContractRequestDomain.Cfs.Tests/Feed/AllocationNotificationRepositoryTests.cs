namespace ContractRequestDomain.Cfs.Tests.Feed
{
    using System.Collections.Generic;
    using System.Linq;
    using Cfs.Feed.Dtos;
    using Cfs.Feed.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using Optional;
    using SFA.FCT.ContractRequestDomain.DataStore;
    using SFA.FCT.ContractRequestDomain.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using UnitTests.Common;

    [TestClass]
    public class AllocationNotificationRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void AllocationNotificationRepository_AddRange_ShouldStoreEntitiesInTableInExpectedOrder()
        {
            IReadOnlyCollection<string> allocationIds = Enumerable.Range(1, 20).Select(i => i.ToString()).ToList();

            // arrange
            using (ContractRequestDbContext context = new ContractRequestDbContext())
            {
                context.AllocationNotifications.RemoveAll();
                context.SaveChanges();
            }

            AllocationNotificationRepository repository = new AllocationNotificationRepository();

            // act
            using (ContractRequestDbContext context = new ContractRequestDbContext())
            {
                repository.AddRange(
                    connectionInfo: new ConnectionInfo(null, context.Database.Connection),
                    allocationNotifications: allocationIds.Select(id => new AllocationNotification
                    {
                        AllocationId = id,
                        VersionNumber = 1,
                        Ukprn = int.Parse(id),
                        Status = ProcessingStatus.New,
                        FeedPageNumber = int.Parse(id)
                    }).ToList()).Wait();
            }

            // assert
            using (ContractRequestDbContext context = new ContractRequestDbContext())
            {
                IReadOnlyCollection<AllocationNotification> allocationNotifications = context.AllocationNotifications.OrderBy(an => an.Id).ToList();
                Assert.AreEqual(allocationIds.Count, allocationNotifications.Count, "Unexpected number of allocation notifications stored");
                Assert.AreEqual("1", allocationNotifications.First().AllocationId, "First AllocationId was incorrect");
                Assert.AreEqual("20", allocationNotifications.Last().AllocationId, "Last AllocationId was incorrect");

                allocationIds.ForEach(id => Assert.IsNotNull(allocationNotifications.SingleOrDefault(an => an.AllocationId == id), "Expected allocation notification not stored"));
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AllocationNotificationRepository_AddRange_ShouldThrowStorageExceptionWhenDuplicateAllocationIdAndVersionNumberPresent()
        {
            const string allocationId = "1";
            const int versionNumber = 1;
            const int feedPageNumber = 1;
            bool expectedExceptionThrown = false;

            // arrange
            using (ContractRequestDbContext context = new ContractRequestDbContext())
            {
                context.AllocationNotifications.RemoveWhere(an => an.AllocationId == allocationId);
                context.AllocationNotifications.Add(new AllocationNotification
                {
                    AllocationId = allocationId,
                    VersionNumber = versionNumber,
                    Ukprn = int.Parse(allocationId),
                    Status = ProcessingStatus.New,
                    FeedPageNumber = feedPageNumber
                });
                context.SaveChanges();
            }

            AllocationNotificationRepository repository = new AllocationNotificationRepository();

            // act
            using (ContractRequestDbContext context = new ContractRequestDbContext())
            {
                try
                {
                    repository.AddRange(
                        connectionInfo: new ConnectionInfo(null, context.Database.Connection),
                        allocationNotifications: new List<AllocationNotification>
                        {
                            new AllocationNotification
                            {
                                AllocationId = allocationId,
                                VersionNumber = versionNumber,
                                Ukprn = int.Parse(allocationId),
                                Status = ProcessingStatus.New,
                                FeedPageNumber = feedPageNumber
                            }
                        }).Wait();
                }
                catch (System.AggregateException ex) when (ex.InnerException is System.Data.Entity.Infrastructure.DbUpdateException)
                {
                    expectedExceptionThrown = true;
                }
            }

            Assert.IsTrue(expectedExceptionThrown, "Expected exception not thrown");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AllocationNotificationRepository_AddRange_ShouldStoreEntityInTableWhenSameAllocationIdWithDifferentVersionNumberPresent()
        {
            const string allocationId = "1";

            // arrange
            using (ContractRequestDbContext context = new ContractRequestDbContext())
            {
                context.AllocationNotifications.RemoveWhere(an => an.AllocationId == allocationId);
                context.AllocationNotifications.Add(new AllocationNotification
                {
                    AllocationId = allocationId,
                    VersionNumber = 1,
                    Ukprn = int.Parse(allocationId),
                    Status = ProcessingStatus.New,
                    FeedPageNumber = int.Parse(allocationId)
                });
                context.SaveChanges();
            }

            AllocationNotificationRepository repository = new AllocationNotificationRepository();

            // act
            using (ContractRequestDbContext context = new ContractRequestDbContext())
            {
                repository.AddRange(
                    connectionInfo: new ConnectionInfo(null, context.Database.Connection),
                    allocationNotifications: new List<AllocationNotification>
                    {
                        new AllocationNotification
                        {
                            AllocationId = allocationId,
                            VersionNumber = 2,
                            Ukprn = int.Parse(allocationId),
                            Status = ProcessingStatus.New,
                            FeedPageNumber = int.Parse(allocationId)
                        }
                    }).Wait();
            }

            // assert
            using (ContractRequestDbContext context = new ContractRequestDbContext())
            {
                IReadOnlyCollection<AllocationNotification> allocationNotifications = context.AllocationNotifications.Where(an => an.AllocationId == allocationId).ToList();
                Assert.IsNotNull(allocationNotifications.SingleOrDefault(an => an.VersionNumber == 1), "Version 1 no longer present in storage");
                Assert.IsNotNull(allocationNotifications.SingleOrDefault(an => an.VersionNumber == 2), "Version 2 not added to storage");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AllocationNotificationRepository_GetCurrentBookmark_ShouldReturnMostRecentBookmark()
        {
            IReadOnlyCollection<Bookmark> allocationIds = new List<Bookmark>
            {
                new Bookmark("A", 1),
                new Bookmark("B", 1),
                new Bookmark("C", 2),
                new Bookmark("D", 3)
            };

            // arrange
            using (ContractRequestDbContext context = new ContractRequestDbContext())
            {
                context.AllocationNotifications.RemoveAll();
                allocationIds.ForEach(bk => context.AllocationNotifications.Add(new AllocationNotification
                {
                    AllocationId = bk.AllocationId,
                    VersionNumber = 1,
                    Ukprn = 12345,
                    Status = ProcessingStatus.New,
                    FeedPageNumber = bk.FeedPageNumber
                }));
                context.SaveChanges();
            }

            AllocationNotificationRepository repository = new AllocationNotificationRepository();
            Option<Bookmark> optionBookmark;

            // act
            using (ContractRequestDbContext context = new ContractRequestDbContext())
            {
                optionBookmark = repository.GetCurrentBookmark(new ConnectionInfo(null, context.Database.Connection)).Result;
            }

            // assert
            Bookmark assertBookmark = null;
            optionBookmark.Match(some: x => { assertBookmark = x; }, none: () => Assert.Fail("GetCurrentBookmark method did not return a bookmark"));
            Assert.AreEqual("D", assertBookmark.AllocationId, "Unexpected current bookmark AllocationId returned");
            Assert.AreEqual(3, assertBookmark.FeedPageNumber, "Unexpected current bookmark FeedPageNumber returned");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AllocationNotificationRepository_GetCurrentBookmark_ShouldReturnNullWhenNoAllocationNotificationsAreStored()
        {
            // arrange
            using (ContractRequestDbContext context = new ContractRequestDbContext())
            {
                context.AllocationNotifications.RemoveAll();
                context.SaveChanges();
            }

            AllocationNotificationRepository repository = new AllocationNotificationRepository();
            Option<Bookmark> optionBookmark;

            // act
            using (ContractRequestDbContext context = new ContractRequestDbContext())
            {
                optionBookmark = repository.GetCurrentBookmark(new ConnectionInfo(null, context.Database.Connection)).Result;
            }

            // assert
            optionBookmark.Match(some: x => { Assert.Fail("GetCurrentBookmark method incorrectly returned a bookmark"); }, none: () => { });
        }
    }
}
