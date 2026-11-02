namespace SFA.FCT.ContractManagementDomain.Integration.Tests.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Linq;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using CrossDomain.Integration.Entities.Data;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using UnitTests.Common;

    [TestClass]
    public class ApprovedContractAllocationRepositoryTests
    {

        private const string ContractId = "Test-contract";
        private const string AllocNumber = "Test-Alloc";
        private const string FundingType = "TestFT";
        private const string FundingPeriod = "T1213";
        private const int Ukprn = 88888888;
        private const string OrganisationId = "Test-org";

        [TestMethod, TestCategory("IntegrationTest")]
        public void ApprovedContractAllocationRepository_SetOutstandingPaymentsIndicator_WhenExistingValueIsNull_ShouldUpdateToGivenValue()
        {
            // Arrange
            ClearDownDataForContractNumbers(new[] { ContractId });
            ClearDownFundingTypeFundingPeriod(FundingType, FundingPeriod);
            CreateFundingTypeFundingPeriod(FundingType, FundingPeriod);
            IList<ApprovedContractAllocation> GetAllocationsallocations() => new[] {new ApprovedContractAllocation {ContractAllocationNumber = AllocNumber}};

            using (ContractManagementDbContext dbContext = new ContractManagementDbContext())
            {
                dbContext.ApprovedContracts.Add(CreateApprovedContract(ContractId, 1, 0, FundingType, FundingPeriod, Ukprn, OrganisationId, GetAllocationsallocations()));
                dbContext.ApprovedContracts.Add(CreateApprovedContract(ContractId, 2, 0, FundingType, FundingPeriod, Ukprn, OrganisationId, GetAllocationsallocations()));
                dbContext.SaveChanges();
            }

            // Act
            ApprovedContractAllocationRepository approvedContractAllocationRepository = new ApprovedContractAllocationRepository(new ContractManagementDbContext());
            approvedContractAllocationRepository.SetOutstandingPaymentsIndicator(AllocNumber, true, ConnectionInfo.CreateFrom(new ContractManagementDbContext().Database.Connection));

            // Assert
            using (ContractManagementDbContext dbContext = new ContractManagementDbContext())
            {
                var lastApprovedContract = dbContext.ApprovedContracts.Include(c => c.ApprovedContractAllocations).Single(c =>
                    c.ContractNumber == ContractId && c.ContractVersionNumber == 2);

                ApprovedContractAllocation approvedContractAllocation = lastApprovedContract.ApprovedContractAllocations.Single(ca => ca.ContractAllocationNumber == AllocNumber);

                Assert.IsTrue(approvedContractAllocation.HasOutstandingPayments.Value, "The latest version should have out standing payment");

                var replacedApprovedContract = dbContext.ApprovedContracts.Include(c => c.ApprovedContractAllocations).Single(c =>
                    c.ContractNumber == ContractId && c.ContractVersionNumber == 1);

                ApprovedContractAllocation replacedContractAllocation = replacedApprovedContract.ApprovedContractAllocations.Single(ca => ca.ContractAllocationNumber == AllocNumber);

                Assert.IsNull(replacedContractAllocation.HasOutstandingPayments, "The HasOutstandingPayments should not be set for the replaced allocation");
            }
            ClearDownDataForContractNumbers(new[] { ContractId });
            ClearDownFundingTypeFundingPeriod(FundingType, FundingPeriod);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ApprovedContractAllocationRepository_SetOutstandingPaymentsIndicator_WhenExistingValueIsNotNull_ShouldUpdateToGivenValue()
        {
            // Arrange
            ClearDownDataForContractNumbers(new[] { ContractId });
            ClearDownFundingTypeFundingPeriod(FundingType, FundingPeriod);
            CreateFundingTypeFundingPeriod(FundingType, FundingPeriod);
            IList<ApprovedContractAllocation> allocations = new[]
            {
                new ApprovedContractAllocation() {ContractAllocationNumber = AllocNumber, HasOutstandingPayments = true}
            };

            using (ContractManagementDbContext dbContext = new ContractManagementDbContext())
            {
                dbContext.ApprovedContracts.Add(CreateApprovedContract(ContractId, 1, 0, FundingType, FundingPeriod, Ukprn, OrganisationId, allocations));
                dbContext.SaveChanges();
            }

            // Act
            ApprovedContractAllocationRepository approvedContractAllocationRepository = new ApprovedContractAllocationRepository(new ContractManagementDbContext());
            approvedContractAllocationRepository.SetOutstandingPaymentsIndicator(AllocNumber, false, ConnectionInfo.CreateFrom(new ContractManagementDbContext().Database.Connection));

            // Assert
            using (ContractManagementDbContext dbContext = new ContractManagementDbContext())
            {
                ApprovedContractAllocation approvedContractAllocation = dbContext.ApprovedContractAllocations.Single(ca => ca.ContractAllocationNumber == AllocNumber);
                Assert.IsFalse(approvedContractAllocation.HasOutstandingPayments.Value);
            }
            ClearDownDataForContractNumbers(new[] { ContractId });
            ClearDownFundingTypeFundingPeriod(FundingType, FundingPeriod);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ApprovedContractAllocationRepository_GetAllocationNumbersForApprovedContract_ShouldReturnExpectedAllocationNumbers()
        {
            // Arrange
            const string otherContractNumber = "other-contract;";
            string[] expectedAllocationNumbers = {"Alloc-11", "Alloc-12", "Alloc-13"};
            ClearDownDataForContractNumbers(new[] { ContractId, otherContractNumber });
            ClearDownFundingTypeFundingPeriod(FundingType, FundingPeriod);
            CreateFundingTypeFundingPeriod(FundingType, FundingPeriod);

            var allocations1 = expectedAllocationNumbers.Select(ea => new ApprovedContractAllocation {ContractAllocationNumber = ea});
            IList<ApprovedContractAllocation> allocations2 = new[]
            {
                new ApprovedContractAllocation {ContractAllocationNumber = "Alloc-21"},
                new ApprovedContractAllocation {ContractAllocationNumber = "Alloc-22"}
            };

            using (ContractManagementDbContext dbContext = new ContractManagementDbContext())
            {
                dbContext.ApprovedContracts.Add(CreateApprovedContract(ContractId, 1, 0, FundingType, FundingPeriod, Ukprn, OrganisationId, allocations1.ToList()));
                dbContext.ApprovedContracts.Add(CreateApprovedContract(otherContractNumber, 1, 0, FundingType, FundingPeriod, Ukprn, OrganisationId, allocations2));
                dbContext.SaveChanges();
            }

            using (ContractManagementDbContext dbContext = new ContractManagementDbContext())
            {
                ApprovedContractAllocationRepository approvedContractAllocationRepository = new ApprovedContractAllocationRepository(dbContext);
                // Act
                IReadOnlyCollection<string> allocationNumbers = approvedContractAllocationRepository.GetAllocationNumbersForApprovedContract(
                    ContractId,
                    1,
                    0,
                    new ConnectionInfo(null, dbContext.Database.Connection));

                // Assert
                Assert.AreEqual(expectedAllocationNumbers.Length, allocationNumbers.Count); 
                expectedAllocationNumbers.ForEach(ea =>
                {
                    Assert.IsTrue(allocationNumbers.Contains(ea), $"Allocation number {ea} was not in the list of returned allocation numbers");
                });
            }
            ClearDownDataForContractNumbers(new[] { ContractId });
            ClearDownFundingTypeFundingPeriod(FundingType, FundingPeriod);
        }

        private void ClearDownFundingTypeFundingPeriod(string fundingType, string fundingPeriod)
        {
            using (ContractManagementDbContext dbContext = new ContractManagementDbContext())
            {
                string[] contractNumbersUsingFundingType =
                    dbContext
                    .ApprovedContracts
                    .Where(ac => ac.FundingPeriod == fundingPeriod && ac.FundingType == fundingType)
                    .Select(ac => ac.ContractNumber)
                    .ToArray();

                ClearDownDataForContractNumbers(contractNumbersUsingFundingType);
                dbContext.FundingTypeFundingPeriodItems.Where(ftfp => ftfp.FundingTypeCode == fundingType && ftfp.FundingPeriodName == fundingPeriod).ForEach(ftfp => dbContext.FundingTypeFundingPeriodItems.Remove(ftfp));
                dbContext.SaveChanges();
            }
        }

        private void CreateFundingTypeFundingPeriod(string fundingType, string fundingPeriod)
        {
            using (ContractManagementDbContext dbContext = new ContractManagementDbContext())
            {
                dbContext.FundingTypeFundingPeriodItems.Add(new FundingTypeFundingPeriod
                {
                    FundingTypeCode = fundingType,
                    FundingPeriodName = fundingPeriod
                });

                dbContext.SaveChanges();
            }
        }

        private static ApprovedContract CreateApprovedContract(string contractNumber, int version, int subversion, string fundingType, string fundingPeriod,
                                                               int ukprn, string organisationId, IList<ApprovedContractAllocation> approvedAllocations = null)
        {
            return new ApprovedContract(contractNumber, version, subversion, fundingType, fundingPeriod, ukprn, organisationId, 
                                        string.Empty, DateTime.Now.AddDays(7).Date, DateTime.Now.AddYears(1).Date)
            {
                ApprovedContractAllocations = approvedAllocations
            };
        }

        private static void ClearDownDataForContractNumbers(string[] contractNumbers)
        {
            using (ContractManagementDbContext dbContext = new ContractManagementDbContext())
            {
                var contractIdsToDelete = dbContext.ApprovedContracts.Where(c => contractNumbers.Contains(c.ContractNumber)).Select(c => c.ApprovedContractId).ToList();
                dbContext.ApprovedContracts.RemoveWhere(c => contractIdsToDelete.Contains(c.ApprovedContractId));
                dbContext.ApprovedContractAllocations.RemoveWhere(ca => contractIdsToDelete.Contains(ca.ApprovedContractId));
                dbContext.SaveChanges();
            }
        }
    }
}
