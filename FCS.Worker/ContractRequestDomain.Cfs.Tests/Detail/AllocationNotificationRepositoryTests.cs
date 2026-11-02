namespace ContractRequestDomain.Cfs.Tests.Detail
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using ContractRequestDomain.Cfs.Detail.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using SFA.FCT.ContractRequestDomain.DataStore;
    using SFA.FCT.ContractRequestDomain.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class AllocationNotificationRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void AllocationNotificationRepository_ShouldGetNewAllocationNotifications()
        {
            // arrange
            DeleteAllNotifications();
            using (var context = new ContractRequestDbContext())
            {
                context.AllocationNotifications.Add(new AllocationNotification
                {
                    AllocationId = "A1",
                    Status = ProcessingStatus.New,
                    Ukprn = 12,
                    VersionNumber = 1
                });

                context.AllocationNotifications.Add(new AllocationNotification
                {
                    AllocationId = "A2",
                    Status = ProcessingStatus.Processing,
                    Ukprn = 123,
                    VersionNumber = 1
                });

                context.SaveChanges();
            }

            // act
            using (var context = new ContractRequestDbContext())
            {
                context.Database.Log = s => System.Diagnostics.Debug.WriteLine(s);

                AllocationNotificationRepository repository = new AllocationNotificationRepository();

                IReadOnlyCollection<AllocationNotification> allocationNotifications = repository
                    .GetNewAllocationNotificationsThatAreNotInProgress(new ConnectionInfo(transaction: null,
                        connection: context.Database.Connection)).Result;

                // assert
                Assert.AreEqual(1, allocationNotifications.Count);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AllocationNotificationRepository_ShouldGetNewAllocationNotifications_WhenMatchingUkprnsAreInProcess()
        {
            // arrange
            DeleteAllNotifications();
            using (var context = new ContractRequestDbContext())
            {
                context.AllocationNotifications.Add(new AllocationNotification
                {
                    AllocationId = "A1",
                    Status = ProcessingStatus.New,
                    Ukprn = 12,
                    VersionNumber = 1
                });

                context.AllocationNotifications.Add(new AllocationNotification
                {
                    AllocationId = "A2",
                    Status = ProcessingStatus.Processing,
                    Ukprn = 123,
                    VersionNumber = 1
                });

                context.AllocationNotifications.Add(new AllocationNotification
                {
                    AllocationId = "A1",
                    Status = ProcessingStatus.Processing,
                    Ukprn = 12,
                    VersionNumber = 2
                });

                context.SaveChanges();
            }

            // act
            using (var context = new ContractRequestDbContext())
            {
                context.Database.Log = s => System.Diagnostics.Debug.WriteLine(s);

                AllocationNotificationRepository repository = new AllocationNotificationRepository();

                IReadOnlyCollection<AllocationNotification> allocationNotifications = repository
                    .GetNewAllocationNotificationsThatAreNotInProgress(new ConnectionInfo(transaction: null,
                        connection: context.Database.Connection)).Result;

                // assert
                Assert.AreEqual(0, allocationNotifications.Count);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task AllocationNotificationRepository_ShouldSetAllocationNotificationsToProcessing()
        {
            // arrange
            DeleteAllNotifications();
            using (var context = new ContractRequestDbContext())
            {
                context.AllocationNotifications.Add(new AllocationNotification
                {
                    AllocationId = "A1",
                    Status = ProcessingStatus.New,
                    Ukprn = 12,
                    VersionNumber = 1
                });

                context.AllocationNotifications.Add(new AllocationNotification
                {
                    AllocationId = "A2",
                    Status = ProcessingStatus.New,
                    Ukprn = 123,
                    VersionNumber = 1
                });

                context.AllocationNotifications.Add(new AllocationNotification
                {
                    AllocationId = "A1",
                    Status = ProcessingStatus.Processing,
                    Ukprn = 12,
                    VersionNumber = 2
                });

                context.SaveChanges();
            }

            // act
            using (var context = new ContractRequestDbContext())
            {
                context.Database.Log = s => System.Diagnostics.Debug.WriteLine(s);

                AllocationNotificationRepository repository = new AllocationNotificationRepository();

                await repository
                    .SetAllocationNotificationsToProcessing(new ConnectionInfo(null, context.Database.Connection),
                        context.AllocationNotifications.Select(a => a.Id).ToList());
            }

            // assert
            using (var context = new ContractRequestDbContext())
            {
                Assert.AreEqual(3, context.AllocationNotifications.Count(a => a.Status == ProcessingStatus.Processing));
            }
        }

        private void DeleteAllNotifications()
        {
            using (var context = new ContractRequestDbContext())
            {
                context.AllocationNotifications.ForEach(an => context.AllocationNotifications.Remove(an));

                context.SaveChanges();
            }
        }
    }
}
