namespace PMD.PaymentSchedule.DataStore.Tests.RepositoryTests
{
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Repositories;

    [TestClass]
    public class PublishedPayableFcrAllocationRepositoryIntegrationTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void PublishedPayableFcrAllocationRepository_Add_ShouldAddCorrectAllocationNumberToStorageWhenItDoesNotAlreadyExistInStorage()
        {
            // arrange 
            const string testAllocationNumber = "Alloc_Test";

            using (var context = new PaymentSchedulePolicyContext())
            {
                context.Database.ExecuteSqlCommand($"DELETE PaymentSchedule.PublishedPayableFcrAllocation WHERE AllocationNumber = '{testAllocationNumber}'");
            }

            int numberOfRecordsBeforeCallingRepository;
            using (var context = new PaymentSchedulePolicyContext())
            {
                numberOfRecordsBeforeCallingRepository = context.PublishedPayableFcrAllocations.Count();
            }

            // act 
            using (var context = new PaymentSchedulePolicyContext())
            {
                PublishedPayableFcrAllocationRepository repository = new PublishedPayableFcrAllocationRepository();
                repository.Add(testAllocationNumber, ConnectionInfo.CreateFrom(context.Database.Connection));
            }

            // assert 
            using (var context = new PaymentSchedulePolicyContext())
            {
                int numberOfRecordsAfterCallingRespository = context.PublishedPayableFcrAllocations.Count();

                PublishedPayableFcrAllocation persistedTestAllocationNumber = context.PublishedPayableFcrAllocations.Find(testAllocationNumber);

                Assert.AreEqual(numberOfRecordsBeforeCallingRepository + 1, numberOfRecordsAfterCallingRespository, "Incorrect number of 'Published Payable FCR Allocations' in storage");
                Assert.IsNotNull(persistedTestAllocationNumber, $" Added 'Published Payable FCR Allocation' not in storage. AllocationNumber - '{testAllocationNumber}'");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PublishedPayableFcrAllocationRepository_Add_ShouldNotAddAllocationNumberToStorageWhenItAlreadyExistsInStorage()
        {
            // arrange 
            const string testAllocationNumber = "Alloc_Test";

            using (var context = new PaymentSchedulePolicyContext())
            {
                context.Database.ExecuteSqlCommand($"DELETE PaymentSchedule.PublishedPayableFcrAllocation WHERE AllocationNumber = '{testAllocationNumber}'");
                context.Database.ExecuteSqlCommand($"INSERT PaymentSchedule.PublishedPayableFcrAllocation(AllocationNumber) VALUES('{testAllocationNumber}')");
            }

            int numberOfRecordsBeforeCallingRepository;
            using (var context = new PaymentSchedulePolicyContext())
            {
                numberOfRecordsBeforeCallingRepository = context.PublishedPayableFcrAllocations.Count();
            }

            // act 
            using (var context = new PaymentSchedulePolicyContext())
            {
                PublishedPayableFcrAllocationRepository repository = new PublishedPayableFcrAllocationRepository();
                repository.Add(testAllocationNumber, ConnectionInfo.CreateFrom(context.Database.Connection));
            }

            // assert 
            using (var context = new PaymentSchedulePolicyContext())
            {
                int numberOfRecordsAfterCallingRespository = context.PublishedPayableFcrAllocations.Count();

                Assert.AreEqual(numberOfRecordsBeforeCallingRepository, numberOfRecordsAfterCallingRespository, "Incorrect number of 'Published Payable FCR Allocations' in storage");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PublishedPayableFcrAllocationRepository_IsPayableFcrPublishedForAllocation_ShouldReturnTrueWhenAllocationNumberHeldInStorage()
        {
            // arrange 
            const string testAllocationNumber = "Alloc_Test";

            using (var context = new PaymentSchedulePolicyContext())
            {
                context.Database.ExecuteSqlCommand($"DELETE PaymentSchedule.PublishedPayableFcrAllocation WHERE AllocationNumber = '{testAllocationNumber}'");
                context.Database.ExecuteSqlCommand($"INSERT PaymentSchedule.PublishedPayableFcrAllocation(AllocationNumber) VALUES('{testAllocationNumber}')");
            }

            // act 
            using (var context = new PaymentSchedulePolicyContext())
            {
                PublishedPayableFcrAllocationRepository repository = new PublishedPayableFcrAllocationRepository();
                bool isPayableFcrPublishedForAllocation = repository.IsPayableFcrPublishedForAllocation(testAllocationNumber,
                    ConnectionInfo.CreateFrom(context.Database.Connection));

                // assert
                Assert.IsTrue(isPayableFcrPublishedForAllocation);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PublishedPayableFcrAllocationRepository_IsPayableFcrPublishedForAllocation_ShouldReturnFalseWhenAllocationNumberNotHeldInStorage()
        {
            // arrange 
            const string testAllocationNumber = "Alloc_Test";

            using (var context = new PaymentSchedulePolicyContext())
            {
                context.Database.ExecuteSqlCommand($"DELETE PaymentSchedule.PublishedPayableFcrAllocation WHERE AllocationNumber = '{testAllocationNumber}'");
            }

            // act 
            using (var context = new PaymentSchedulePolicyContext())
            {
                PublishedPayableFcrAllocationRepository repository = new PublishedPayableFcrAllocationRepository();
                bool isPayableFcrPublishedForAllocation = repository.IsPayableFcrPublishedForAllocation(testAllocationNumber,
                    ConnectionInfo.CreateFrom(context.Database.Connection));

                // assert
                Assert.IsFalse(isPayableFcrPublishedForAllocation);
            }
        }
    }
}
