namespace PerformanceManagementDomain.Tests.ReconciliationCalculationEndpoint.Repositories
{
    using System;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models.Allocation;
    using UnitTests.Common;
    using System.Collections.Generic;
    using System.Data.Entity.Validation;
    using System.Linq;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;

    [TestClass]
    public class ContractAllocationRepositoryTests
    {
        private const string ContractAllocationNumberTest = "Some number";
        private const string OtherContractAllocationNumberTest = "Some other number";
        private const string ContractAllocationNumberFindTest = "AllocationNumberFind";

        [TestInitialize]
        public void TestCleanup()
        {
            try
            {
                using (var context = new PerformanceManagementDbContext())
                {
                    List<string> contractAllocationNumbersList = new List<string> { ContractAllocationNumberTest, OtherContractAllocationNumberTest, ContractAllocationNumberFindTest };

                    context.ContractAllocations.RemoveWhere(ca => contractAllocationNumbersList.Contains(ca.AllocationNumber));
                    context.SaveChanges();
                }
            }
            catch (DbEntityValidationException ex)
            {
                var errorMessages = ex.EntityValidationErrors
                    .SelectMany(x => x.ValidationErrors)
                    .Select(x => x.ErrorMessage);

                var fullErrorMessage = String.Join("; ", errorMessages);

                var exceptionMessage = String.Concat(ex.Message, " The validation errors are: ", fullErrorMessage);

                Assert.Fail(exceptionMessage);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractAllocationRepository_Find_ShouldGetAllocation()
        {
            // arrange
            DateTime now = DateTime.Now;
            
            using (var context = new PerformanceManagementDbContext())
            {
                ContractAllocation contractAllocation = CreateContractAllocation(ContractAllocationNumberFindTest, now);

                context.ContractAllocations.Add(contractAllocation);
                context.SaveChanges();
            }

            using (var context = new PerformanceManagementDbContext())
            {
                ConnectionInfo connectionInfo = new ConnectionInfo(null, context.Database.Connection);
                ContractAllocationRepository contractAllocationRepository = new ContractAllocationRepository();

                // act
                var contractAllocationAssert = contractAllocationRepository.Find(ContractAllocationNumberFindTest, connectionInfo).Result;

                // assert
                Assert.IsNotNull(contractAllocationAssert, "Unexpected null result returned");
                Assert.AreEqual(FormatDateTime(now), FormatDateTime(contractAllocationAssert.StartDate), "Unexpected allocation StartDate returned");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractAllocationRepository_Find_ShouldReturnNullWhenAllocationDoesNotExist()
        {
            // arrange
            using (var context = new PerformanceManagementDbContext())
            {
                ConnectionInfo connectionInfo = new ConnectionInfo(null, context.Database.Connection);
                ContractAllocationRepository contractAllocationRepository = new ContractAllocationRepository();

                // act
                var contractAllocationAssert = contractAllocationRepository.Find(ContractAllocationNumberFindTest, connectionInfo).Result;

                // assert
                Assert.IsNull(contractAllocationAssert, "Unexpected not null result returned");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractAllocationRepository_AddOrUpdateAllocation_ShouldUpdateExisting()
        {
            try
            {
                // arrange
                DateTime now = DateTime.Now;
                ContractAllocation arrangeContractAllocation = CreateContractAllocation(ContractAllocationNumberTest, now);
                string assertOrgId;

                using (var context = new PerformanceManagementDbContext())
                {
                    context.ContractAllocations.Add(arrangeContractAllocation);
                    context.SaveChanges();
                }

                using (var context = new PerformanceManagementDbContext())
                {
                    ContractAllocationRepository repository = new ContractAllocationRepository();
                    ConnectionInfo connectionInfo = new ConnectionInfo(null, context.Database.Connection);
                    ContractAllocation actContractAllocation = repository.Find(ContractAllocationNumberTest, connectionInfo).Result;

                    actContractAllocation.EndDate = now.AddDays(2);
                    actContractAllocation.Contract.ApprovalDate = now.AddDays(2);
                    assertOrgId = actContractAllocation.Contractor.OrganisationIdentifier + " Updated";
                    actContractAllocation.Contractor.OrganisationIdentifier = assertOrgId;

                    // act
                    repository.AddOrUpdateAllocation(actContractAllocation, connectionInfo).Wait();
                }

                using (var context = new PerformanceManagementDbContext())
                {
                    var assertContractAllocation = context.ContractAllocations.Find(ContractAllocationNumberTest);
                    // assert
                    Assert.AreEqual(now.AddDays(2).Date, assertContractAllocation.EndDate.GetValueOrDefault().Date, "EndDate was not updated");
                    Assert.AreEqual(now.AddDays(2).Date, assertContractAllocation.Contract.ApprovalDate.Date, "Contract ApprovalDate was not updated");
                    Assert.AreEqual(assertOrgId, assertContractAllocation.Contractor.OrganisationIdentifier, "Contractor OrganisationIdentifier was not updated");
                }
            }
            catch (DbEntityValidationException ex)
            {
                var errorMessages = ex.EntityValidationErrors
                    .SelectMany(x => x.ValidationErrors)
                    .Select(x => x.ErrorMessage);

                var fullErrorMessage = string.Join("; ", errorMessages);

                var exceptionMessage = string.Concat(ex.Message, " The validation errors are: ", fullErrorMessage);

                Assert.Fail(exceptionMessage);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractAllocationRepository_AddOrUpdateAllocation_ShouldAddNewAllocation()
        {
            try
            {
                // arrange
                DateTime now = DateTime.Now;

                using (var context = new PerformanceManagementDbContext())
                {
                    ContractAllocationRepository repository = new ContractAllocationRepository();
                    ConnectionInfo connectionInfo = new ConnectionInfo(null, context.Database.Connection);
                    ContractAllocation actContractAllocation = CreateContractAllocation(ContractAllocationNumberTest, now);

                    // act
                    repository.AddOrUpdateAllocation(actContractAllocation, connectionInfo).Wait();
                }

                using (var context = new PerformanceManagementDbContext())
                {
                    var assertContractAllocation = context.ContractAllocations.Find(ContractAllocationNumberTest);
                    // assert
                    Assert.IsNotNull(assertContractAllocation, "Contract Allocation was not added");
                    Assert.AreEqual(FormatDateTime(now), FormatDateTime(assertContractAllocation.StartDate), "StartDate was incorrect");
                }
            }
            catch (DbEntityValidationException ex)
            {
                var errorMessages = ex.EntityValidationErrors
                    .SelectMany(x => x.ValidationErrors)
                    .Select(x => x.ErrorMessage);

                var fullErrorMessage = string.Join("; ", errorMessages);

                var exceptionMessage = string.Concat(ex.Message, " The validation errors are: ", fullErrorMessage);

                Assert.Fail(exceptionMessage);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractAllocationRepository_GetAllocationsPlannedValue_ShouldGetPlannedValueWhenOnePresent()
        {
            // arrange
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                DateTime now = DateTime.Now;
                ContractAllocation contractAllocation = CreateContractAllocation(ContractAllocationNumberTest, now);
                context.ContractAllocations.Add(contractAllocation);
                contractAllocation = CreateContractAllocation(OtherContractAllocationNumberTest, now);
                context.ContractAllocations.Add(contractAllocation);
                context.ContractAllocationDeliverables.AddRange(new List<ContractAllocationDeliverable>
                {
                    new ContractAllocationDeliverable(contractAllocationNumber: ContractAllocationNumberTest, deliverableCode: 1, plannedValue: 100),
                    new ContractAllocationDeliverable(contractAllocationNumber: ContractAllocationNumberTest, deliverableCode: 2, plannedValue: 200),
                    new ContractAllocationDeliverable(contractAllocationNumber: ContractAllocationNumberTest, deliverableCode: 3, plannedValue: 300),
                    new ContractAllocationDeliverable(contractAllocationNumber: ContractAllocationNumberTest, deliverableCode: 4, plannedValue: 400),

                    new ContractAllocationDeliverable(contractAllocationNumber: OtherContractAllocationNumberTest, deliverableCode: 1, plannedValue: 100),
                    new ContractAllocationDeliverable(contractAllocationNumber: OtherContractAllocationNumberTest, deliverableCode: 2, plannedValue: 200),
                    new ContractAllocationDeliverable(contractAllocationNumber: OtherContractAllocationNumberTest, deliverableCode: 3, plannedValue: 300),
                    new ContractAllocationDeliverable(contractAllocationNumber: OtherContractAllocationNumberTest, deliverableCode: 4, plannedValue: 1000),
                });

                context.SaveChanges();
            }

            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                ContractAllocationRepository repository = new ContractAllocationRepository();
                ConnectionInfo connectionInfo = new ConnectionInfo(null, context.Database.Connection);
                var allocationNumbers = new List<string> { ContractAllocationNumberTest, OtherContractAllocationNumberTest };

                //act
                var allocationsPlannedValue = repository.GetAllocationsWithPlannedValue(allocationNumbers, connectionInfo).Result;

                // assert 
                Assert.AreEqual(1000, allocationsPlannedValue.Single(a => a.AllocationNumber == ContractAllocationNumberTest).PlannedValue, 
                    $"Incorrect allocation planned value for returned '{ContractAllocationNumberTest}' allocation number");
                Assert.AreEqual(1600, allocationsPlannedValue.Single(a => a.AllocationNumber == OtherContractAllocationNumberTest).PlannedValue, 
                    $"Incorrect allocation planned value for returned '{OtherContractAllocationNumberTest}' allocation number");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractAllocationRepository_GetAllocationsPlannedValue_ShouldGetPlannedValueOfZeroWhenDeliverablesAreNotPresent()
        {
            // arrange
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                DateTime now = DateTime.Now;
                ContractAllocation contractAllocation = CreateContractAllocation(ContractAllocationNumberTest, now);
                context.ContractAllocations.Add(contractAllocation);
                contractAllocation = CreateContractAllocation(OtherContractAllocationNumberTest, now);
                context.ContractAllocations.Add(contractAllocation);
                context.ContractAllocationDeliverables.AddRange(new List<ContractAllocationDeliverable>
                {
                    new ContractAllocationDeliverable(contractAllocationNumber: OtherContractAllocationNumberTest, deliverableCode: 1, plannedValue: 100),
                    new ContractAllocationDeliverable(contractAllocationNumber: OtherContractAllocationNumberTest, deliverableCode: 2, plannedValue: 200),
                    new ContractAllocationDeliverable(contractAllocationNumber: OtherContractAllocationNumberTest, deliverableCode: 3, plannedValue: 300),
                    new ContractAllocationDeliverable(contractAllocationNumber: OtherContractAllocationNumberTest, deliverableCode: 4, plannedValue: 1000),
                });
                context.SaveChanges();
            }

            // act
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                ContractAllocationRepository repository = new ContractAllocationRepository();
                ConnectionInfo connectionInfo = new ConnectionInfo(null, context.Database.Connection);
                var allocationNumbers = new List<string> { ContractAllocationNumberTest };

                //act
                var allocationsPlannedValue = repository.GetAllocationsWithPlannedValue(allocationNumbers, connectionInfo).Result;

                // assert 
                Assert.AreEqual(0, allocationsPlannedValue.Single(a => a.AllocationNumber == ContractAllocationNumberTest).PlannedValue, 
                    $"Incorrect allocation planned value for returned '{ContractAllocationNumberTest}' allocation number");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractAllocationRepository_GetAllocationsPlannedValue_ShouldNotReturnPlannedValueForAllocationNumberWhenNotPresent()
        {
            // arrange
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                ContractAllocationRepository repository = new ContractAllocationRepository();
                ConnectionInfo connectionInfo = new ConnectionInfo(null, context.Database.Connection);

                // act
                var assertDictionary = repository.GetAllocationsWithPlannedValue(new List<string>{ ContractAllocationNumberTest }, connectionInfo).Result;
                
                Assert.AreEqual(0 , assertDictionary.Count);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractAllocationRepository_GetAllocationsPlannedValue_ShouldGetPlannedValuesforANumberOfAllocations()
        {
            // arrange
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                DateTime now = DateTime.Now;
                ContractAllocation contractAllocation = CreateContractAllocation(ContractAllocationNumberTest, now);
                context.ContractAllocations.Add(contractAllocation);
                context.ContractAllocationDeliverables.AddRange(new List<ContractAllocationDeliverable>
                {
                    new ContractAllocationDeliverable(contractAllocationNumber: ContractAllocationNumberTest, deliverableCode: 1, plannedValue: 10),
                    new ContractAllocationDeliverable(contractAllocationNumber: ContractAllocationNumberTest, deliverableCode: 2, plannedValue: 20),
                    new ContractAllocationDeliverable(contractAllocationNumber: ContractAllocationNumberTest, deliverableCode: 3, plannedValue: 30),
                    new ContractAllocationDeliverable(contractAllocationNumber: ContractAllocationNumberTest, deliverableCode: 4, plannedValue: 100),
                });

                contractAllocation = CreateContractAllocation(OtherContractAllocationNumberTest, now);
                context.ContractAllocations.Add(contractAllocation);
                context.ContractAllocationDeliverables.AddRange(new List<ContractAllocationDeliverable>
                {
                    new ContractAllocationDeliverable(contractAllocationNumber: OtherContractAllocationNumberTest, deliverableCode: 1, plannedValue: 100),
                    new ContractAllocationDeliverable(contractAllocationNumber: OtherContractAllocationNumberTest, deliverableCode: 2, plannedValue: 200),
                    new ContractAllocationDeliverable(contractAllocationNumber: OtherContractAllocationNumberTest, deliverableCode: 3, plannedValue: 300),
                    new ContractAllocationDeliverable(contractAllocationNumber: OtherContractAllocationNumberTest, deliverableCode: 4, plannedValue: 1000),
                });
                context.SaveChanges();
            }

            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                ContractAllocationRepository repository = new ContractAllocationRepository();
                ConnectionInfo connectionInfo = new ConnectionInfo(null, context.Database.Connection);

                // act
                var allocationNumbers = new List<string> {ContractAllocationNumberTest, OtherContractAllocationNumberTest};

                var allocationsPlannedValue = repository.GetAllocationsWithPlannedValue(allocationNumbers, connectionInfo).Result;

                // assert 
                Assert.AreEqual(160, allocationsPlannedValue.Single(a => a.AllocationNumber == ContractAllocationNumberTest).PlannedValue, $"Incorrect allocation planned value for returned '{ContractAllocationNumberTest}' allocation number");
                Assert.AreEqual(1600, allocationsPlannedValue.Single(a => a.AllocationNumber == OtherContractAllocationNumberTest).PlannedValue, $"Incorrect allocation planned value for returned '{OtherContractAllocationNumberTest}' allocation number");
            }
        }


        private static string FormatDateTime(DateTime dateTime)
        {
            return dateTime.ToString("dd/MM/yyyy HH:mm:ss");
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
            contractAllocation.Contract.ApprovalDate = now;
            contractAllocation.Contract.SubVersionNumber = 1;
            contractAllocation.Contract.VersionNumber = 1;
            contractAllocation.FundingType.FundingTypeCode = "FT";
            contractAllocation.FundingType.FundingTypeName = "FT";
            contractAllocation.Period.PeriodTypeName = "some ptn";

            return contractAllocation;
        }
    }
}