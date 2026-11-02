namespace PMD.PaymentSchedule.DataStore.Tests.RepositoryTests
{
    using System;
    using System.Data.Entity.Core.EntityClient;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Repositories;

    [TestClass]
    public class PaymentSchedulePolicyContextTests
    {
        private const string AllocationNumberTest = "FAKE-1";
        private const int VersionNumberTest = 2;

        [TestInitialize]
        public void Setup()
        {
            using (var context = new PaymentSchedulePolicyContext())
            {
                context.Allocations
                    .Where(a => a.AllocationNumber == AllocationNumberTest)
                    .ToList()
                    .ForEach(a => context.Allocations.Remove(a));

                context.SaveChanges();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentSchedulePolicyContext_Should_GetPreviousApprovedContractVersionNumberFromPaymentSchedule()
        {
            // arrange
            var allocationRepo = new AllocationRepository();

            using (var context = new PaymentSchedulePolicyContext())
            {
                context.Allocations.Add(new Allocation
                {
                    AllocationNumber = AllocationNumberTest,
                    VersionNumber = VersionNumberTest,
                    ContractVersionNumber = VersionNumberTest,
                    FundingStreamPeriodCode = "someFSP"
                });

                context.Allocations.Add(new Allocation
                {
                    AllocationNumber = AllocationNumberTest,
                    VersionNumber = VersionNumberTest - 1,
                    ContractVersionNumber = VersionNumberTest - 1,
                    FundingStreamPeriodCode = "someFSP"
                });

                context.SaveChanges();
            }

            // act
            var previousVersionNumber = allocationRepo.GetPreviousApprovedContractVersionNumberFromPaymentSchedule(
                AllocationNumberTest,
                VersionNumberTest,
                ConnectionInfo.CreateFrom(new PaymentSchedulePolicyContext().Database.Connection));

            // assert
            Assert.AreEqual(1, previousVersionNumber);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentSchedulePolicyContext_Should_ThrowExpectionWhenCalling_GetPreviousApprovedContractVersionNumberFromPaymentScheduleWhenNonExists()
        {
            // arrange
            var allocationRepo = new AllocationRepository();
            using (var context = new PaymentSchedulePolicyContext())
            {
                context.Allocations.Add(new Allocation
                {
                    AllocationNumber = AllocationNumberTest,
                    VersionNumber = VersionNumberTest,
                    ContractVersionNumber = VersionNumberTest,
                    FundingStreamPeriodCode = "someFSP"
                });

                context.SaveChanges();
            }

            bool hasThrownException = false;

            // act
            using (var context = new PaymentSchedulePolicyContext())
            {
                try
                {
                        allocationRepo.GetPreviousApprovedContractVersionNumberFromPaymentSchedule(AllocationNumberTest,
                            VersionNumberTest, ConnectionInfo.CreateFrom(new PaymentSchedulePolicyContext().Database.Connection));
                }
                catch (ArgumentException)
                {
                    hasThrownException = true;
                }
            }

            // assert
            Assert.IsTrue(hasThrownException);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentSchedulePolicyContext_Should_HasPreviousAllocationVersionReturnTrue_WhenPreviousVersionExists()
        {
            // arrange
            var allocationRepo = new AllocationRepository();
            using (var context = new PaymentSchedulePolicyContext())
            {
                context.Allocations.Add(new Allocation
                {
                    AllocationNumber = AllocationNumberTest,
                    VersionNumber = VersionNumberTest,
                    ContractVersionNumber = VersionNumberTest,
                    FundingStreamPeriodCode = "someFSP"
                });

                context.Allocations.Add(new Allocation
                {
                    AllocationNumber = AllocationNumberTest,
                    VersionNumber = VersionNumberTest - 1,
                    ContractVersionNumber = VersionNumberTest - 1,
                    FundingStreamPeriodCode = "someFSP"
                });

                context.SaveChanges();
            }

            // act
            var hasPreviousVersion = allocationRepo.HasPreviousAllocationVersion(AllocationNumberTest, VersionNumberTest,
                ConnectionInfo.CreateFrom(new PaymentSchedulePolicyContext().Database.Connection));

            // assert
            Assert.IsTrue(hasPreviousVersion);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentSchedulePolicyContext_Should_HasPreviousAllocationVersionReturnFalse_WhenPreviousVersionDoesNotExist()
        {
            // arrange
            var allocationRepo = new AllocationRepository();
            using (var context = new PaymentSchedulePolicyContext())
            {
                context.Allocations.Add(new Allocation
                {
                    AllocationNumber = AllocationNumberTest,
                    VersionNumber = VersionNumberTest - 1,
                    ContractVersionNumber = VersionNumberTest - 1,
                    FundingStreamPeriodCode = "someFSP"
                });

                context.SaveChanges();
            }

            // act
            var hasPreviousVersion = allocationRepo.HasPreviousAllocationVersion(AllocationNumberTest, VersionNumberTest - 1,
                ConnectionInfo.CreateFrom(new PaymentSchedulePolicyContext().Database.Connection));

            // assert
            Assert.IsFalse(hasPreviousVersion);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AllocationRepository_ShouldUpdateAnExistingAllocation()
        {
            // arrange
            const string testAllocationNumber = "Alloc_Test";
            const int testVersionNumber = 1;
            
            using (var context = new PaymentSchedulePolicyContext())
            {
                context.Allocations.Where(a => a.AllocationNumber == testAllocationNumber)
                   .ForEach(a => context.Allocations.Remove(a));

                context.SaveChanges();
            }

            using (var context = new PaymentSchedulePolicyContext())
            {
                context.Allocations.Add(new Allocation
                {
                    AllocationNumber = testAllocationNumber,
                    VersionNumber = testVersionNumber,
                    FundingStreamPeriodCode = "someFSP"
                });

                context.SaveChanges();
            }

            DateTime testDateTime = DateTime.Now.ToUniversalTime();

            // act
            using (var context = new PaymentSchedulePolicyContext())
            {
                AllocationRepository repository = new AllocationRepository();

                repository.AddOrUpdate(new Allocation
                {
                    AllocationNumber = testAllocationNumber,
                    VersionNumber = testVersionNumber,
                    AllocationStartDate = testDateTime,
                    FundingStreamPeriodCode = "someFSP"
                }, ConnectionInfo.CreateFrom(context.Database.Connection));
            }

            // assert
            using (var context = new PaymentSchedulePolicyContext())
            {
                var matchingAllocation = context.Allocations.Find(testAllocationNumber, testVersionNumber);

                Assert.AreEqual(testDateTime.Date, matchingAllocation.AllocationStartDate.Value.Date, "The date doesn't match");
                Assert.AreEqual(testDateTime.Hour, matchingAllocation.AllocationStartDate.Value.Hour, "The hours don't match");
                Assert.AreEqual(testDateTime.Minute, matchingAllocation.AllocationStartDate.Value.Minute, "The minutes don't match");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AllocationRepository_ShouldInsertWhenThereIsNoExistingAllocation()
        {
            // arrange
            const string testAllocationNumber = "Alloc_Test";
            const int testVersionNumber = 1;

            using (var context = new PaymentSchedulePolicyContext())
            {
                context.Allocations.Where(a => a.AllocationNumber == testAllocationNumber)
                   .ForEach(a => context.Allocations.Remove(a));

                context.SaveChanges();
            }

            DateTime testDateTime = DateTime.Now.ToUniversalTime();

            // act
            using (var context = new PaymentSchedulePolicyContext())
            {
                AllocationRepository repository = new AllocationRepository();

                repository.AddOrUpdate(new Allocation
                {
                    AllocationNumber = testAllocationNumber,
                    VersionNumber = testVersionNumber,
                    AllocationStartDate = testDateTime,
                    FundingStreamPeriodCode = "someFSP"
                }, ConnectionInfo.CreateFrom(context.Database.Connection));
            }

            // assert
            using (var context = new PaymentSchedulePolicyContext())
            {
                var matchingAllocation = context.Allocations.Find(testAllocationNumber, testVersionNumber);


                Assert.AreEqual(testDateTime.Date, matchingAllocation.AllocationStartDate.Value.Date, "The date doesn't match");
                Assert.AreEqual(testDateTime.Hour, matchingAllocation.AllocationStartDate.Value.Hour, "The hours don't match");
                Assert.AreEqual(testDateTime.Minute, matchingAllocation.AllocationStartDate.Value.Minute, "The minutes don't match");
            }
        }
    }
}