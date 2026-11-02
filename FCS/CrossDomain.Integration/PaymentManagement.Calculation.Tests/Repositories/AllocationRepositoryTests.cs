namespace PaymentManagement.Calculation.Tests.Repositories
{
    using System.Linq;
    using Calculation.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model;

    [TestClass]
    public class AllocationRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void AllocationRepository_GetPreviousVersion_ShouldGetLatestVersionLessThanCurrent()
        {
            // arrange
            const string allocationNumber = "AN1234";

            ClearAllAllocations(allocationNumber);

            CreateAllocation(allocationNumber, 1);
            CreateAllocation(allocationNumber, 2);
            CreateAllocation(allocationNumber, 3);

            // act
            using (var context = new PaymentSchedulePolicyContext())
            {
                AllocationQueryRepository queryRepository = new AllocationQueryRepository();

                var optionalVersion = queryRepository.GetPreviousVersion(allocationNumber, 3,
                    ConnectionInfo.CreateFrom(context.Database.Connection));
                
                // assert
                optionalVersion.Match(some: version => { Assert.AreEqual(2, version, "The version is not correct"); },
                    none: () =>
                    {
                        Assert.Fail("We have not returned anything");
                    });
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AllocationRepository_GetPreviousVersion_ShouldGetNoneWhenThereArentAnyEarlierVersions()
        {
            // arrange
            const string allocationNumber = "AN1234";

            ClearAllAllocations(allocationNumber);

            CreateAllocation(allocationNumber, 1);

            // act
            using (var context = new PaymentSchedulePolicyContext())
            {
                AllocationQueryRepository queryRepository = new AllocationQueryRepository();

                var optionalVersion = queryRepository.GetPreviousVersion(allocationNumber, 1,
                    ConnectionInfo.CreateFrom(context.Database.Connection));

                // assert
                optionalVersion.Match(some: version => { Assert.Fail("The version should not have been returned"); },
                    none: () =>{});
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AllocationRepository_IsPayableFcrPublishedForAllocation_ShouldReturnTrueWhenAllocationInPublishedTable()
        {
            // arrange
            const string allocationNumber = "AN1235";

            ClearAllocationFromPublishedTable(allocationNumber);

            CreateAllocationInPublishedTable(allocationNumber);

            // act
            using (var context = new PaymentSchedulePolicyContext())
            {
                AllocationQueryRepository queryRepository = new AllocationQueryRepository();

                var isPayableFcrPublishedForAllocation = queryRepository.IsPayableFcrPublishedForAllocation(allocationNumber,
                    ConnectionInfo.CreateFrom(context.Database.Connection));

                // assert
                Assert.IsTrue(isPayableFcrPublishedForAllocation);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AllocationRepository_IsPayableFcrPublishedForAllocation_ShouldReturnFalseWhenAllocationNotInPublishedTable()
        {
            // arrange
            const string allocationNumber = "AN1236";

            ClearAllocationFromPublishedTable(allocationNumber);

            // act
            using (var context = new PaymentSchedulePolicyContext())
            {
                AllocationQueryRepository queryRepository = new AllocationQueryRepository();

                var isPayableFcrPublishedForAllocation = queryRepository.IsPayableFcrPublishedForAllocation(allocationNumber,
                    ConnectionInfo.CreateFrom(context.Database.Connection));

                // assert
                Assert.IsFalse(isPayableFcrPublishedForAllocation);
            }
        }

        private void CreateAllocationInPublishedTable(string allocationNumber)
        {
            using (var context = new PaymentSchedulePolicyContext())
            {
                context.PublishedPayableFcrAllocations.Add(new PublishedPayableFcrAllocation(allocationNumber));

                context.SaveChanges();
            }
        }

        private void CreateAllocation(string allocationNumber, int versionNumber)
        {
            using (var context = new PaymentSchedulePolicyContext())
            {
                context.Allocations.Add(new Allocation
                {
                    AllocationNumber = allocationNumber,
                    VersionNumber = versionNumber,
                    FundingStreamPeriodCode = "some fsp"
                });

                context.SaveChanges();
            }
        }

        private void ClearAllAllocations(string allocationNumber)
        {
            using (var context = new PaymentSchedulePolicyContext())
            {
                context.Allocations.Where(a => a.AllocationNumber == allocationNumber)
                    .ToList()
                    .ForEach(a => context.Allocations.Remove(a));

                context.SaveChanges();
            }
        }

        private void ClearAllocationFromPublishedTable(string allocationNumber)
        {
            using (var context = new PaymentSchedulePolicyContext())
            {
                context.PublishedPayableFcrAllocations.Where(a => a.AllocationNumber == allocationNumber)
                    .ToList()
                    .ForEach(a => context.PublishedPayableFcrAllocations.Remove(a));

                context.SaveChanges();
            }
        }
    }
}
