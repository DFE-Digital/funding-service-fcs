namespace ContractRequestDomain.Cfs.Tests
{
    using System.Linq;
    using System.Threading.Tasks;
    using ContractRequest.Cfs.AllocationCreated.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using SFA.FCT.ContractRequestDomain.DataStore;
    using SFA.FCT.ContractRequestDomain.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class CfsAllocationCreatedAllocationNotificationRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public async Task AllocationNotificationRepository_ShouldSetAllocationNotificationToComplete()
        {
            // arrange
            DeleteAllNotifications();
            using (var context = new ContractRequestDbContext())
            {
                context.AllocationNotifications.Add(new AllocationNotification
                {
                    AllocationId = "A1",
                    Status = ProcessingStatus.Processing,
                    Ukprn = 12,
                    VersionNumber = 1
                });

                context.AllocationNotifications.Add(new AllocationNotification
                {
                    AllocationId = "A1",
                    Status = ProcessingStatus.New,
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

                await repository.SetAllocationNotificationToComplete(
                    new ConnectionInfo(null, context.Database.Connection), allocationId: "A1", versionNumber: 1);
            }

            // assert
            using (var context = new ContractRequestDbContext())
            {
                var assertAllocationNotifications = context.AllocationNotifications.Where(an => an.AllocationId == "A1").ToList();
                Assert.AreEqual(2, assertAllocationNotifications.Count(), "Incorrect number of AllocationNotifications returned");

                var assertAllocationNotification1 = assertAllocationNotifications.Single(an => an.AllocationId == "A1" && an.VersionNumber == 1);
                Assert.AreEqual(ProcessingStatus.Complete, assertAllocationNotification1.Status, "Incorrect ProcessingStatus returned for version 1");

                var assertAllocationNotification2 = assertAllocationNotifications.Single(an => an.AllocationId == "A1" && an.VersionNumber == 2);
                Assert.AreEqual(ProcessingStatus.New, assertAllocationNotification2.Status, "Incorrect ProcessingStatus returned for version 2");
            }
        }

        private static void DeleteAllNotifications()
        {
            using (var context = new ContractRequestDbContext())
            {
                context.AllocationNotifications.ForEach(an => context.AllocationNotifications.Remove(an));

                context.SaveChanges();
            }
        }
    }
}