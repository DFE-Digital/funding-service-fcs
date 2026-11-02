namespace ContractManagementDomain.Endpoint.Tests.ContractApproved.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Linq;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using Endpoint.ContractApproved.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using UnitTests.Common;

    [TestClass]
    public class ApprovedContractRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ApprovedContractRepository_Add_ShouldCreateApprovedContractRecordAndSomeApprovedContractAllocations()
        {
            const string contractNumber = "Test-Contract";
            const int version = 1;
            const int subversion = 1;
            const string allocNumber1 = "Test-Allocation1";
            const string allocNumber2 = "Test-Allocation2";
            const string allocNumber3 = "Test-Allocation3";
            const string fundingType = "TFTYPE";
            const string fundingPeriod = "TEST1213";
            const int ukprn = 88888888;
            const string organisationId = "Test-org";

            // Arrange
            ClearDownDataForContractNumbers(new[] { contractNumber });
            ClearDownFundingTypeFundingPeriod(fundingType, fundingPeriod);
            CreateFundingTypeFundingPeriod(fundingType, fundingPeriod);

            var approvedContract =
                new ApprovedContract(contractNumber, version, subversion, fundingType, fundingPeriod, ukprn, organisationId,
                                     string.Empty, DateTime.Now.AddDays(7).Date, DateTime.Now.AddYears(1).Date)
                {
                    ApprovedContractAllocations = new List<ApprovedContractAllocation>
                    {
                        new ApprovedContractAllocation {ContractAllocationNumber = allocNumber1},
                        new ApprovedContractAllocation {ContractAllocationNumber = allocNumber2},
                        new ApprovedContractAllocation {ContractAllocationNumber = allocNumber3}
                    }
                };

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                IApprovedContractRepository approvedContractRepository = new ApprovedContractRepository();
                ConnectionInfo connectionInfo = new ConnectionInfo(null, context.Database.Connection);

                // Act
                approvedContractRepository.Add(approvedContract, connectionInfo).Wait();
            }

            // Assert
            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                var assertedApprovedContract = context.ApprovedContracts
                    .Where(ac => ac.ContractNumber == contractNumber)
                    .Include(ca => ca.ApprovedContractAllocations)
                    .Single();

                Assert.AreEqual(version, assertedApprovedContract.ContractVersionNumber,
                    "Incorrect contract version number stored");
                Assert.AreEqual(subversion, assertedApprovedContract.ContractSubVersionNumber,
                    "Incorrect contract subversion number stored");
                Assert.AreEqual(3, assertedApprovedContract.ApprovedContractAllocations.Count,
                    "Expected 3 contract allocation records to be stored");
                Assert.IsTrue(assertedApprovedContract.ApprovedContractAllocations.First().ContractAllocationNumber == allocNumber1,
                    $"'{allocNumber1} Allocation record was expected to be stored");
                Assert.AreEqual(fundingType, assertedApprovedContract.FundingType, "Funding type was incorrect");
                Assert.AreEqual(fundingPeriod, assertedApprovedContract.FundingPeriod, "Funding type was incorrect");
            }
            ClearDownDataForContractNumbers(new[] { contractNumber });
            ClearDownFundingTypeFundingPeriod(fundingType, fundingPeriod);
        }

        private static void ClearDownFundingTypeFundingPeriod(string fundingType, string fundingPeriod)
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
                dbContext.FundingTypeFundingPeriodItems
                    .Where(ftfp => ftfp.FundingTypeCode == fundingType && ftfp.FundingPeriodName == fundingPeriod)
                    .ToList()
                    .ForEach(ftfp => dbContext.FundingTypeFundingPeriodItems.Remove(ftfp));
                dbContext.SaveChanges();
            }
        }

        private static void CreateFundingTypeFundingPeriod(string fundingType, string fundingPeriod)
        {
            using (ContractManagementDbContext dbContext = new ContractManagementDbContext())
            {
                dbContext.FundingTypeFundingPeriodItems.Add(new FundingTypeFundingPeriod
                {
                    FundingTypeCode = fundingType,
                    FundingPeriodName = fundingPeriod,
                    SkipDocumentMerge = false,
                    SkipCaseloadAssignment = false,
                    SkipReviewAndInternalApproval = false,
                    DocumentsRequired = false,
                    AreContractsOpenEnded = true
                });

                dbContext.SaveChanges();
            }
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
