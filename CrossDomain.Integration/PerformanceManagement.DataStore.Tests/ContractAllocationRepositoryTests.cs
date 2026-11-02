namespace PerformanceManagement.DataStore.Tests
{
    using System;
    using System.Collections.Generic;
    using System.Data.Entity.Validation;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models.Allocation;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Repositories;

    [TestClass]
    public class ContractAllocationRepositoryTests
    {
        const string ContractAllocationNumberTest = "Some number";
        const string OtherContractAllocationNumberTest = "Some other number";

        [TestInitialize]
        public void TestCleanup()
        {
            try
            {
                using (var context = new PerformanceManagementDbContext())
                {
                    context.ContractAllocations.Where(ca => ca.AllocationNumber == ContractAllocationNumberTest || ca.AllocationNumber == OtherContractAllocationNumberTest)
                        .ForEach(ca => context.ContractAllocations.Remove(ca));

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
        public void ContractAllocationRepository_ShouldUpdateExisting()
        {
            try
            {
                // arrange
                DateTime now = DateTime.Now;
                ContractAllocation contractAllocation = CreateContractAllocation(ContractAllocationNumberTest, now);

                using (var context = new PerformanceManagementDbContext())
                {
                    context.ContractAllocations.Add(contractAllocation);
                    context.SaveChanges();
                }

                // act
               
                using (var context = new PerformanceManagementDbContext())
                {
                    contractAllocation = context.ContractAllocations.Find(ContractAllocationNumberTest);

                    contractAllocation.EndDate = now.AddDays(2);
                    context.SaveChanges();
                }

                using (var context = new PerformanceManagementDbContext())
                {
                    contractAllocation = context.ContractAllocations.Find(ContractAllocationNumberTest);
                }


                // assert
                Assert.AreEqual(now.AddDays(2).Date, contractAllocation.EndDate.GetValueOrDefault().Date);
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
        public void ContractAllocationRepository_ShouldGetPlannedValueWhenOnePresent()
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

            // act
            decimal? plannedValue;
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                ContractAllocationRepository repository = new ContractAllocationRepository(context);
                plannedValue = repository.GetPlannedValueForAllocation(ContractAllocationNumberTest);
            }

            // assert 
            Assert.AreEqual(1000, plannedValue);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractAllocationRepository_ShouldGetPlannedValueOfZeroWhenDeliverablesAreNotPresent()
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
            decimal? plannedValue;
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                ContractAllocationRepository repository = new ContractAllocationRepository(context);
                plannedValue = repository.GetPlannedValueForAllocation(ContractAllocationNumberTest);
            }

            // assert 
            Assert.AreEqual(0, plannedValue);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractAllocationRepository_ShouldGetPlannedValueOfNullWhenTheAllocationIsNotPresent()
        {
            // arrange
            
            decimal? plannedValue;
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                ContractAllocationRepository repository = new ContractAllocationRepository(context);
                
                // act
                plannedValue = repository.GetPlannedValueForAllocation(ContractAllocationNumberTest);
            }

            // assert 
            Assert.AreEqual(null, plannedValue);
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
