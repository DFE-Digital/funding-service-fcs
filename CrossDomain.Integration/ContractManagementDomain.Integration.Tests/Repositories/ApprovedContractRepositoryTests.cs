namespace SFA.FCT.ContractManagementDomain.Integration.Tests.Repositories
{
    using System;
    using System.Linq;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using CrossDomain.Integration.Entities.Data;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using UnitTests.Common;

    [TestClass]
    public class ApprovedContractRepositoryTests
    {
        private const string ContractNumber = "Test-Contract";
        private const int Version = 1;
        private const int Subversion = 1;
        private const string AllocNumber1 = "Test-Allocation1";
        private const string AllocNumber2 = "Test-Allocation2";
        private const string AllocNumber3 = "Test-Allocation3";
        private const string FundingType = "TFTYPE";
        private const string FundingPeriod = "TEST1213";
        private const int Ukprn = 88888888;
        private const string OrganisationId = "Test-org";

        [TestMethod, TestCategory("IntegrationTest")]
        public void ApprovedContractRepository_HasOutstandingPayments_WhenContractAllocationsAllHaveNoOutstandingPayments_ShouldReturnFalse()
        {
            // Act
            ClearDownDataForContractNumbers(new[] { ContractNumber });
            ClearDownFundingTypeFundingPeriod(FundingType, FundingPeriod);
            CreateFundingTypeFundingPeriod(FundingType, FundingPeriod);

            using (ContractManagementDbContext dbContext = new ContractManagementDbContext())
            {
                int approvedContractId = CreateApprovedContract(ContractNumber, Version, Subversion, FundingType, FundingPeriod, Ukprn, OrganisationId, dbContext);
                AddContractAllocationToContractInContext(approvedContractId, AllocNumber1, false, dbContext);
                AddContractAllocationToContractInContext(approvedContractId, AllocNumber2, false, dbContext);
                dbContext.SaveChanges();
            }

            ApprovedContractRepository approvedContractAllocationRepository = new ApprovedContractRepository();

            // Act
            bool hasOutstandingPayments = approvedContractAllocationRepository.HasOutstandingPayments(ContractNumber, Version, Subversion,
                ConnectionInfo.CreateFrom(new ContractManagementDbContext().Database.Connection));

            // Assert
            Assert.IsFalse(hasOutstandingPayments);

            // Clean up
            ClearDownDataForContractNumbers(new[] { ContractNumber });
            ClearDownFundingTypeFundingPeriod(FundingType, FundingPeriod);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ApprovedContractRepository_HasOutstandingPayments_WhenAllocationsHaveNoOutstandingPaymentsButOneNotSet_ShouldReturnFalse()
        {
            // Act
            ClearDownDataForContractNumbers(new[] { ContractNumber });
            ClearDownFundingTypeFundingPeriod(FundingType, FundingPeriod);
            CreateFundingTypeFundingPeriod(FundingType, FundingPeriod);

            using (ContractManagementDbContext dbContext = new ContractManagementDbContext())
            {
                int approvedContractId = CreateApprovedContract(ContractNumber, Version, Subversion, FundingType, FundingPeriod, Ukprn, OrganisationId, dbContext);
                AddContractAllocationToContractInContext(approvedContractId, AllocNumber1, null, dbContext);
                AddContractAllocationToContractInContext(approvedContractId, AllocNumber2, false, dbContext);
                dbContext.SaveChanges();
            }

            ApprovedContractRepository approvedContractAllocationRepository = new ApprovedContractRepository();

            // Act
            bool hasOutstandingPayments = approvedContractAllocationRepository.HasOutstandingPayments(ContractNumber, Version, Subversion,
                ConnectionInfo.CreateFrom(new ContractManagementDbContext().Database.Connection));

            // Assert
            Assert.IsFalse(hasOutstandingPayments);

            // Clean up
            ClearDownDataForContractNumbers(new[] { ContractNumber });
            ClearDownFundingTypeFundingPeriod(FundingType, FundingPeriod);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ApprovedContractRepository_HasOutstandingPayments_WhenContractAllocationHasOutstandingPayments_ShouldReturnTrue()
        {
            // Act
            ClearDownDataForContractNumbers(new[] { ContractNumber });
            ClearDownFundingTypeFundingPeriod(FundingType, FundingPeriod);
            CreateFundingTypeFundingPeriod(FundingType, FundingPeriod);

            using (ContractManagementDbContext dbContext = new ContractManagementDbContext())
            {
                int approvedContractId = CreateApprovedContract(ContractNumber, Version, Subversion, FundingType, FundingPeriod, Ukprn, OrganisationId, dbContext);
                AddContractAllocationToContractInContext(approvedContractId, AllocNumber1, false, dbContext);
                AddContractAllocationToContractInContext(approvedContractId, AllocNumber2, false, dbContext);
                AddContractAllocationToContractInContext(approvedContractId, AllocNumber3, true, dbContext);
                dbContext.SaveChanges();
            }

            ApprovedContractRepository approvedContractAllocationRepository = new ApprovedContractRepository();

            // Act
            bool hasOutstandingPayments = approvedContractAllocationRepository.HasOutstandingPayments(ContractNumber, Version, Subversion,
                ConnectionInfo.CreateFrom(new ContractManagementDbContext().Database.Connection));

            // Assert
            Assert.IsTrue(hasOutstandingPayments);

            // Clean up
            ClearDownDataForContractNumbers(new[] { ContractNumber });
            ClearDownFundingTypeFundingPeriod(FundingType, FundingPeriod);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ApprovedContractRepository_ShouldReturnFundingTypeFundingPeriod()
        {
            // Arrange
            ClearDownDataForContractNumbers(new[] { ContractNumber });
            ClearDownFundingTypeFundingPeriod(FundingType, FundingPeriod);
            CreateFundingTypeFundingPeriod(FundingType, FundingPeriod);

            using (ContractManagementDbContext dbContext = new ContractManagementDbContext())
            {
                int approvedContractId = CreateApprovedContract(ContractNumber, Version, Subversion, FundingType, FundingPeriod, Ukprn, OrganisationId, dbContext);
                
                dbContext.SaveChanges();
            }

            ApprovedContractRepository approvedContractAllocationRepository = new ApprovedContractRepository();

            // Act
            FundingTypeFundingPeriod fundingTypeFundingPeriod = approvedContractAllocationRepository.GetFundingTypeFundingPeriodForContract(ContractNumber, Version, Subversion,
                ConnectionInfo.CreateFrom(new ContractManagementDbContext().Database.Connection));

            // Assert
            Assert.AreEqual(FundingType, fundingTypeFundingPeriod.FundingTypeCode, "The funding type returned is not correct");
            Assert.AreEqual(FundingPeriod, fundingTypeFundingPeriod.FundingPeriodName, "The funding period returned is not correct");

            // Clean up
            ClearDownDataForContractNumbers(new[] { ContractNumber });
            ClearDownFundingTypeFundingPeriod(FundingType, FundingPeriod);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ApprovedContractRepository_ShouldReturnContractLatestForAllocation()
        {
            // Arrange
            const string allocationNumber = "Test Alloc";
            const string anotherContract = "Test Contract";
            ClearDownDataForContractNumbers(new[] { ContractNumber, anotherContract });
            ClearDownFundingTypeFundingPeriod(FundingType, FundingPeriod);
            CreateFundingTypeFundingPeriod(FundingType, FundingPeriod);

            using (ContractManagementDbContext dbContext = new ContractManagementDbContext())
            {
                CreateApprovedContract(anotherContract, Version, Subversion, FundingType, FundingPeriod, Ukprn, OrganisationId, dbContext);
                int approvedContractId = CreateApprovedContract(ContractNumber, Version, Subversion, FundingType, FundingPeriod, Ukprn, OrganisationId, dbContext);
                dbContext.ApprovedContractAllocations.Add(new ApprovedContractAllocation
                {
                    ApprovedContractId = approvedContractId,
                    ContractAllocationNumber = allocationNumber
                });
                approvedContractId = CreateApprovedContract(ContractNumber, Version + 1, Subversion, FundingType, FundingPeriod, Ukprn, OrganisationId, dbContext);
                dbContext.ApprovedContractAllocations.Add(new ApprovedContractAllocation
                {
                    ApprovedContractId = approvedContractId,
                    ContractAllocationNumber = allocationNumber
                });

                dbContext.SaveChanges();
            }

            using (ContractManagementDbContext dbContext = new ContractManagementDbContext())
            {
                ApprovedContractRepository approvedContractAllocationRepository = new ApprovedContractRepository();
                dbContext.Database.Log = s => System.Diagnostics.Debug.WriteLine(s);
                // Act
                ApprovedContract approvedContract = approvedContractAllocationRepository.GetContractForAllocationNumber(allocationNumber,
                    ConnectionInfo.CreateFrom(dbContext.Database.Connection));

                // Assert
                Assert.AreEqual(ContractNumber, approvedContract.ContractNumber, "The contract number is incorrect");
                Assert.AreEqual(Version + 1, approvedContract.ContractVersionNumber, "The contract version number is incorrect");
                Assert.AreEqual(1, approvedContract.ApprovedContractAllocations.Count, "The number of allocations returned is incorrect");
                Assert.AreEqual(allocationNumber, approvedContract.ApprovedContractAllocations.First().ContractAllocationNumber, "The contract allocation number is incorrect");
            }

            // Clean up
            ClearDownDataForContractNumbers(new[] { ContractNumber });
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

        private static int CreateApprovedContract(string contractNumber, int version, int subversion, string fundingType, string fundingPeriod, 
                                                  int ukprn, string organisationId, ContractManagementDbContext dbContext)
        {
            ApprovedContract approvedContract = dbContext.ApprovedContracts.Add(
                new ApprovedContract(contractNumber, version, subversion, fundingType, fundingPeriod, ukprn, organisationId,
                                     string.Empty, DateTime.Now.AddDays(7).Date, DateTime.Now.AddYears(1).Date));
            dbContext.SaveChanges();
            return approvedContract.ApprovedContractId;
        }

        private static void AddContractAllocationToContractInContext(int approvedContractId, string contractAllocationNumber, bool? hasOutStandingPayments, ContractManagementDbContext dbContext)
        {
            dbContext.ApprovedContractAllocations.Add(
                new ApprovedContractAllocation()
                {
                    ApprovedContractId = approvedContractId,
                    ContractAllocationNumber = contractAllocationNumber,
                    HasOutstandingPayments = hasOutStandingPayments
                });
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
