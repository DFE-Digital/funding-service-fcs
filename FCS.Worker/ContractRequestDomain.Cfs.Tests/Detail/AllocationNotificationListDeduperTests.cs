namespace ContractRequestDomain.Cfs.Tests.Detail
{
    using System.Collections.Generic;
    using System.Linq;
    using ContractRequestDomain.Cfs.Detail.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractRequestDomain.DataStore.Model;

    [TestClass]
    public class AllocationNotificationListDeduperTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void AllocationNotificationListDeduper_WhenListContainsDuplicateUkprn_ShouldReturnOldestForEachUkprn()
        {
            // arrange
            const int ukprn = 1;
            List<AllocationNotification> allocationNotifications = new List<AllocationNotification>
            {
                new AllocationNotification
                {
                    Id = 1,
                    Ukprn = ukprn,
                    AllocationId = "a1",
                    Status = ProcessingStatus.New,
                    VersionNumber = 1
                },
                new AllocationNotification
                {
                    Id = 2,
                    Ukprn = ukprn,
                    AllocationId = "a1",
                    Status = ProcessingStatus.New,
                    VersionNumber = 1
                },
                new AllocationNotification
                {
                    Id = 3,
                    Ukprn = ukprn,
                    AllocationId = "a1",
                    Status = ProcessingStatus.New,
                    VersionNumber = 1
                },
                new AllocationNotification
                {
                    Id = 4,
                    Ukprn = ukprn,
                    AllocationId = "a1",
                    Status = ProcessingStatus.New,
                    VersionNumber = 1
                },
            };

            // act
            IReadOnlyCollection<AllocationNotification> dedupedList = allocationNotifications.ToDedupedList();

            // assert
            Assert.AreEqual(1, dedupedList.Count, "The count in the list is incorrect");
            Assert.AreEqual(1, dedupedList.First().Id, "The Id of the returned object is incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationNotificationListDeduper_WhenListContainsDuplicateUkprns_ThenReturnOldestForEachUkprn()
        {
            // arrange
            const int ukprn = 1;
            const int ukprn2 = 2;
            List<AllocationNotification> allocationNotifications = new List<AllocationNotification>
            {
                new AllocationNotification
                {
                    Id = 1,
                    Ukprn = ukprn,
                    AllocationId = "a1",
                    Status = ProcessingStatus.New,
                    VersionNumber = 1
                },
                new AllocationNotification
                {
                    Id = 2,
                    Ukprn = ukprn,
                    AllocationId = "a1",
                    Status = ProcessingStatus.New,
                    VersionNumber = 1
                },
                new AllocationNotification
                {
                    Id = 3,
                    Ukprn = ukprn,
                    AllocationId = "a1",
                    Status = ProcessingStatus.New,
                    VersionNumber = 1
                },
                new AllocationNotification
                {
                    Id = 4,
                    Ukprn = ukprn,
                    AllocationId = "a1",
                    Status = ProcessingStatus.New,
                    VersionNumber = 1
                },

                new AllocationNotification
                {
                    Id = 5,
                    Ukprn = ukprn2,
                    AllocationId = "a1",
                    Status = ProcessingStatus.New,
                    VersionNumber = 1
                },
                new AllocationNotification
                {
                    Id = 6,
                    Ukprn = ukprn2,
                    AllocationId = "a1",
                    Status = ProcessingStatus.New,
                    VersionNumber = 1
                },
                new AllocationNotification
                {
                    Id = 7,
                    Ukprn = ukprn2,
                    AllocationId = "a1",
                    Status = ProcessingStatus.New,
                    VersionNumber = 1
                },
                new AllocationNotification
                {
                    Id = 8,
                    Ukprn = ukprn2,
                    AllocationId = "a1",
                    Status = ProcessingStatus.New,
                    VersionNumber = 1
                },
            };

            // act
            IReadOnlyCollection<AllocationNotification> dedupedList = allocationNotifications.ToDedupedList();

            // assert
            Assert.AreEqual(2, dedupedList.Count, "The count in the list is incorrect");
            Assert.AreEqual(1, dedupedList.First().Id, "The Id of the first returned object is incorrect");
            Assert.AreEqual(5, dedupedList.Skip(1).First().Id, "The Id of the second returned object is incorrect");
        }
    }
}
