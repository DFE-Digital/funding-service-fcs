namespace PerformanceManagementDomain.Tests.ReconciliationCalculationEndpoint.Repositories
{
    using System;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using System.Linq;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using UnitTests.Common;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models.Allocation;
    using System.Collections.Generic;

    [TestClass]
    public class ContractAllocationDeliverableRepositoryTests
    {
        private readonly string testAllocationNumber = "FindByAllocationNo";
        private const string ContractAllocationNumber1 = "TEST_ALLOCATION_NO_1";
        private const string ContractAllocationNumber2 = "TEST_ALLOCATION_NO_2";

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractAllocationDeliverableRepository_FindByAllocationNumber_ShouldReturnCorrectContractAllocationDeliverables()
        {
            // Arrange
            using (var context = new PerformanceManagementDbContext())
            {
                context.ContractAllocations.RemoveByKey(testAllocationNumber);
                context.SaveChanges();
            }

            DateTime now = DateTime.Now;

            ContractAllocation testContractAllocation = new ContractAllocation(testAllocationNumber, now, now.AddDays(1))
            {
                Contract = CreateAllocationContract(),
                Contractor = CreateAllocationContractor(),
                FundingType = CreateAllocationFundingType(),
                Period = CreatePeriod(),
                LastModifiedDate = now
            };
            ContractAllocationDeliverable testContractAllocationDeliverable1 = new ContractAllocationDeliverable(testAllocationNumber, 1,10.01m);
            ContractAllocationDeliverable testContractAllocationDeliverable2 = new ContractAllocationDeliverable(testAllocationNumber, 2, 20.02m);
            ContractAllocationDeliverable testContractAllocationDeliverable3 = new ContractAllocationDeliverable(testAllocationNumber, 3, 30.03m);

            using (var context = new PerformanceManagementDbContext())
            {
                context.ContractAllocations.Add(testContractAllocation);
                context.SaveChanges();
                context.ContractAllocationDeliverables.Add(testContractAllocationDeliverable1);
                context.ContractAllocationDeliverables.Add(testContractAllocationDeliverable2);
                context.ContractAllocationDeliverables.Add(testContractAllocationDeliverable3);
                context.SaveChanges();
            }
            
            using (var context = new PerformanceManagementDbContext())
            {
                ConnectionInfo connectionInfo = new ConnectionInfo(null, context.Database.Connection);
                var repository = new ContractAllocationDeliverableRepository();
                // act
                var assertContractAllocationDeliverables = repository.FindByAllocationNumber(testAllocationNumber, connectionInfo).Result;

                // assert
                Assert.IsNotNull(assertContractAllocationDeliverables, "No ContractAllocationDeliverables returned");
                Assert.AreEqual(3, assertContractAllocationDeliverables.Count, "Incorrect number of ContractAllocationDeliverables returned");
                var assertPlannedValue = assertContractAllocationDeliverables.Single(cad => cad.DeliverableCode == 3).PlannedValue;
                Assert.AreEqual(30.03m, assertPlannedValue, "Incorrect planned value returned");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractAllocationDeliverableRepository_StoreContractAllocationDeliverables_ShouldCorrectlyRefreshContractAllocationDeliverableStorageWhenExistingEntitiesArePresent()
        {
            // arrange
            using (var context = new PerformanceManagementDbContext())
            {
                context.ContractAllocations.RemoveByKey(ContractAllocationNumber1);
                context.ContractAllocations.RemoveByKey(ContractAllocationNumber2);
                context.SaveChanges();
            }

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
                ConnectionInfo connectionInfo = new ConnectionInfo(null, context.Database.Connection);

                ContractAllocationDeliverableRepository repository = new ContractAllocationDeliverableRepository();

                // act
                repository.StoreContractAllocationDeliverables(new List<ContractAllocationDeliverable>
                {
                    new ContractAllocationDeliverable(contractAllocationNumber: ContractAllocationNumber1, deliverableCode: 1, plannedValue: 150),
                    new ContractAllocationDeliverable(contractAllocationNumber: ContractAllocationNumber1, deliverableCode: 2, plannedValue: 250),
                    new ContractAllocationDeliverable(contractAllocationNumber: ContractAllocationNumber1, deliverableCode: 5, plannedValue: 550),
                    new ContractAllocationDeliverable(contractAllocationNumber: ContractAllocationNumber1, deliverableCode: 6, plannedValue: 650)
                }, connectionInfo).Wait();
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


        private static Contract CreateAllocationContract()
        {
            return new Contract
            {
                ContractNumber = "CONTRACTNO",
                ApprovalDate = DateTime.Now,
                VersionNumber = 1,
                SubVersionNumber = 1
            };
        }

        private static Contractor CreateAllocationContractor()
        {
            return new Contractor
            {
                LegalName = "LEGALNAME",
                OrganisationIdentifier = "IDENTIFIER",
                UKPRN = 1111
            };
        }

        private static FundingType CreateAllocationFundingType()
        {
            return new FundingType
            {
                FundingTypeCode = "FUNDINGTYPECODE",
                FundingTypeName = "FUNDINGTYPENAME"
            };
        }

        private static Period CreatePeriod()
        {
            return new Period
            {
                PeriodTypeName = "PERIODTYPENAME"
            };
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