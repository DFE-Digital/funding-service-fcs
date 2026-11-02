namespace PerformanceManagement.DataStore.Tests
{
    using System;
    using System.Collections.Generic;
    using System.Data.SqlClient;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models.Allocation;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Repositories;

    [TestClass]
    public class ContractAllocationDeliverableRepositoryTests
    {
        private const string ContractAllocationNumber1 = "TEST_ALLOCATION_NO_1";
        private const string ContractAllocationNumber2 = "TEST_ALLOCATION_NO_2";

        [TestInitialize, TestCleanup]
        public void TestCleanup()
        {
            using (var context = new PerformanceManagementDbContext())
            {
                context.Database.ExecuteSqlCommand(
                    "DELETE FROM PerformanceManagement.ContractAllocation WHERE AllocationNumber = @contractAllocationNumber",
                    new SqlParameter("@contractAllocationNumber", ContractAllocationNumber1));
                context.Database.ExecuteSqlCommand(
                    "DELETE FROM PerformanceManagement.ContractAllocation WHERE AllocationNumber = @contractAllocationNumber",
                    new SqlParameter("@contractAllocationNumber", ContractAllocationNumber2));
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractAllocationDeliverableRepository_ShouldCorrectlyRefreshContractAllocationDeliverableStorageWhenExistingEntitiesArePresent_EvenIfWeHaveSelectedThemAlready()
        {
            // arrange
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                DateTime now = DateTime.Now;
                ContractAllocation contractAllocation = CreateContractAllocation(ContractAllocationNumber1, now);
                context.ContractAllocations.Add(contractAllocation);

                contractAllocation = CreateContractAllocation(ContractAllocationNumber2, now);
                context.ContractAllocations.Add(contractAllocation);

                context.ContractAllocationDeliverables.AddRange(new List<ContractAllocationDeliverable>
                {
                    new ContractAllocationDeliverable(contractAllocationNumber: ContractAllocationNumber1, deliverableCode: 1, plannedValue: 100),
                    new ContractAllocationDeliverable(contractAllocationNumber: ContractAllocationNumber1, deliverableCode: 2, plannedValue: 200),
                    new ContractAllocationDeliverable(contractAllocationNumber: ContractAllocationNumber1, deliverableCode: 3, plannedValue: 300),
                    new ContractAllocationDeliverable(contractAllocationNumber: ContractAllocationNumber1, deliverableCode: 4, plannedValue: 400),

                    new ContractAllocationDeliverable(contractAllocationNumber: ContractAllocationNumber2, deliverableCode: 1, plannedValue: 100),
                    new ContractAllocationDeliverable(contractAllocationNumber: ContractAllocationNumber2, deliverableCode: 2, plannedValue: 200),
                    new ContractAllocationDeliverable(contractAllocationNumber: ContractAllocationNumber2, deliverableCode: 3, plannedValue: 300),
                    new ContractAllocationDeliverable(contractAllocationNumber: ContractAllocationNumber2, deliverableCode: 4, plannedValue: 400),
                });
                context.SaveChanges();
            }

          
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                ContractAllocationDeliverableRepository repository = new ContractAllocationDeliverableRepository(context);

                // act
                repository.StoreContractAllocationDeliverables(new List<ContractAllocationDeliverable>
                {
                    new ContractAllocationDeliverable(contractAllocationNumber: ContractAllocationNumber1, deliverableCode: 1, plannedValue: 150),
                    new ContractAllocationDeliverable(contractAllocationNumber: ContractAllocationNumber1, deliverableCode: 2, plannedValue: 250),
                    new ContractAllocationDeliverable(contractAllocationNumber: ContractAllocationNumber1, deliverableCode: 5, plannedValue: 550),
                    new ContractAllocationDeliverable(contractAllocationNumber: ContractAllocationNumber1, deliverableCode: 6, plannedValue: 650)
                });
            }

            // assert 
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                // assert allocation 1 has been changed correctly
                List<ContractAllocationDeliverable> changedAllocationEntities = context.ContractAllocationDeliverables
                    .Where(d => d.ContractAllocationNumber == ContractAllocationNumber1)
                    .ToList();

                Assert.AreEqual(4, changedAllocationEntities.Count, "Incorrect number of changed allocation entities in storage after update.");

                Assert.IsNotNull(changedAllocationEntities.SingleOrDefault(d => d.DeliverableCode == 1), "Deliverable 1 is not present after update.");
                Assert.IsNotNull(changedAllocationEntities.SingleOrDefault(d => d.DeliverableCode == 2), "Deliverable 2 is not present after update.");
                Assert.IsNull(changedAllocationEntities.SingleOrDefault(d => d.DeliverableCode == 3), "Deliverable 3 is present after update.");
                Assert.IsNull(changedAllocationEntities.SingleOrDefault(d => d.DeliverableCode == 4), "Deliverable 4 is present after update.");
                Assert.IsNotNull(changedAllocationEntities.SingleOrDefault(d => d.DeliverableCode == 5), "Deliverable 5 is not present after update.");
                Assert.IsNotNull(changedAllocationEntities.SingleOrDefault(d => d.DeliverableCode == 6), "Deliverable 6 is not present after update.");

                Assert.AreEqual(150, changedAllocationEntities.Single(d => d.DeliverableCode == 1).PlannedValue, "Incorrect value for deliverable 1 after update.");
                Assert.AreEqual(250, changedAllocationEntities.Single(d => d.DeliverableCode == 2).PlannedValue, "Incorrect value for deliverable 2 after update.");
                Assert.AreEqual(550, changedAllocationEntities.Single(d => d.DeliverableCode == 5).PlannedValue, "Incorrect value for deliverable 5 after update.");
                Assert.AreEqual(650, changedAllocationEntities.Single(d => d.DeliverableCode == 6).PlannedValue, "Incorrect value for deliverable 6 after update.");

                // assert allocation 2 is unchanged
                List<ContractAllocationDeliverable> unchangedAllocationEntities = context.ContractAllocationDeliverables
                    .Where(d => d.ContractAllocationNumber == ContractAllocationNumber2)
                    .ToList();

                Assert.AreEqual(4, unchangedAllocationEntities.Count, "Incorrect number of unchanged allocation entities in storage after update.");

                Assert.IsNotNull(unchangedAllocationEntities.SingleOrDefault(d => d.DeliverableCode == 1), "Unchanged deliverable 1 is not present after update.");
                Assert.IsNotNull(unchangedAllocationEntities.SingleOrDefault(d => d.DeliverableCode == 2), "Unchanged deliverable 2 is not present after update.");
                Assert.IsNotNull(unchangedAllocationEntities.SingleOrDefault(d => d.DeliverableCode == 3), "Unchanged deliverable 3 is not present after update.");
                Assert.IsNotNull(unchangedAllocationEntities.SingleOrDefault(d => d.DeliverableCode == 4), "Unchanged deliverable 4 is not present after update.");
            }
        }

        private ContractAllocation CreateContractAllocation(string allocationNumber, DateTime now)
        {
            ContractAllocation contractAllocation = new ContractAllocation(allocationNumber, now,
                     now.AddDays(1));
            contractAllocation.Contract = new Contract();
            contractAllocation.Contractor = new Contractor();
            contractAllocation.FundingType = new FundingType();
            contractAllocation.Period = new Period();
            contractAllocation.Contractor.LegalName = "some name";
            contractAllocation.Contractor.OrganisationIdentifier = "some id";
            contractAllocation.Contractor.UKPRN = 10;
            contractAllocation.Contract.ContractNumber = "some number";
            contractAllocation.Contract.ApprovalDate = DateTime.Now;
            contractAllocation.Contract.SubVersionNumber = 1;
            contractAllocation.Contract.VersionNumber = 1;
            contractAllocation.FundingType.FundingTypeCode = "FT";
            contractAllocation.FundingType.FundingTypeName = "FT";
            contractAllocation.Period.PeriodTypeName = "some ptn";

            return contractAllocation;
        }
    }
}
