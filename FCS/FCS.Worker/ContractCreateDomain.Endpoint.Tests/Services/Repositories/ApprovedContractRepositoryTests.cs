namespace ContractCreateDomain.Endpoint.Tests.Services.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using Endpoint.Services.Repositories;
    using Infrastructure.Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class ApprovedContractRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ApprovedContractRepository_FindByMasterContractNumber_ShouldReturnApprovedContractsForGivenMasterContractNumber()
        {
            // arrange
            DateTime contractStartDate = DateTime.Now.AddDays(7).Date;
            DateTime? contractEndDate = DateTime.Now.AddYears(1).Date;

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                context.ApprovedContracts.RemoveAll();

                context.ApprovedContracts.Add(new ApprovedContract(
                    "MAIN-1",
                    1,
                    0,
                    "AEB",
                    "AY1819",
                    12345,
                    "ORG12345",
                    "ESFA-1",
                    contractStartDate,
                    contractEndDate)
                {
                    ApprovedContractAllocations = new List<ApprovedContractAllocation> {new ApprovedContractAllocation {ContractAllocationNumber = "AEB-1"}}
                });
                context.ApprovedContracts.Add(new ApprovedContract(
                    "MAIN-2",
                    1,
                    0,
                    "AEB",
                    "AY1819",
                    67890,
                    "ORG67890",
                    "ESFA-2",
                    contractStartDate,
                    contractEndDate)
                {
                    ApprovedContractAllocations = new List<ApprovedContractAllocation> {new ApprovedContractAllocation {ContractAllocationNumber = "AEB-2"}}
                });
                context.ApprovedContracts.Add(new ApprovedContract(
                    "MAIN-3",
                    1,
                    0,
                    "AEB",
                    "AY1920",
                    12345,
                    "ORG12345",
                    "ESFA-1",
                    contractStartDate,
                    contractEndDate)
                {
                    ApprovedContractAllocations = new List<ApprovedContractAllocation> {new ApprovedContractAllocation {ContractAllocationNumber = "AEB-3"}}
                });
                context.ApprovedContracts.Add(new ApprovedContract(
                    "MAIN-3",
                    2,
                    0,
                    "AEB",
                    "AY1920",
                    12345,
                    "ORG12345",
                    "ESFA-1",
                    contractStartDate,
                    contractEndDate)
                {
                    ApprovedContractAllocations = new List<ApprovedContractAllocation>
                    {
                        new ApprovedContractAllocation
                        {
                            ContractAllocationNumber = "AEB-3",
                            TotalPlannedValue = 200m,
                            ApprovedContractDeliverables = new List<ApprovedContractDeliverable>
                            {
                                new ApprovedContractDeliverable("AEB-3", 1, 100m, 25, null)
                            }
                        }
                    }
                });

                context.SaveChanges();

            }

            ApprovedContractRepository approvedContractRepository = new ApprovedContractRepository();

            // act
            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                IReadOnlyCollection<ApprovedContract> contractsWithCommonMaster =
                    approvedContractRepository.FindLatestByMasterContractNumber("ESFA-1", new ConnectionInfo(null, context.Database.Connection)).Result;

                // assert
                Assert.IsNotNull(contractsWithCommonMaster, "Null return result");
                Assert.AreEqual(2, contractsWithCommonMaster.Count, "Unexpected number of contracts returned");
                Assert.IsNotNull(contractsWithCommonMaster.SingleOrDefault(c => c.ContractNumber == "MAIN-1"), "Expected contract not returned");
                Assert.IsNull(contractsWithCommonMaster.SingleOrDefault(c => c.ContractNumber == "MAIN-2"), "Unexpected contract returned");
                Assert.IsNotNull(contractsWithCommonMaster.SingleOrDefault(c => c.ContractNumber == "MAIN-3"), "Expected contract not returned");

                ApprovedContract sampleContract = contractsWithCommonMaster.Single(c => c.ContractNumber == "MAIN-3");

                Assert.IsNotNull(sampleContract.ApprovedContractAllocations, "Approved Contract Allocations not populated");
                Assert.AreEqual(2, sampleContract.ContractVersionNumber, "ContractVersionNumber is not correct");
                Assert.AreEqual(1, sampleContract.ApprovedContractAllocations.Count, "Approved Contract Allocations count is not correct");

                ApprovedContractAllocation sampleAllocation = sampleContract.ApprovedContractAllocations.Single();
                Assert.AreEqual("AEB-3", sampleAllocation.ContractAllocationNumber, "Unexpected ContractAllocationNumber returned");
                Assert.AreEqual(200m, sampleAllocation.TotalPlannedValue, "Unexpected TotalPlannedValue returned");
                Assert.AreEqual(1, sampleAllocation.ApprovedContractDeliverables.Count, "Unexpected number of deliverables returned");

                ApprovedContractDeliverable sampleDeliverable = sampleAllocation.ApprovedContractDeliverables.Single();
                Assert.AreEqual(1, sampleDeliverable.DeliverableCode, "Unexpected DeliverableCode returned");
                Assert.AreEqual(100m, sampleDeliverable.TotalPlannedValue, "Unexpected TotalPlannedValue returned");
                Assert.AreEqual(25m, sampleDeliverable.PlannedValueEnvelope1, "Unexpected PlannedValueEnvelope1 returned");
                Assert.IsNull(sampleDeliverable.PlannedValueEnvelope2, "Unexpected PlannedValueEnvelope2 returned");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ApprovedContractRepository_FindAllocationNumberByUkprnAndFspCode_ShouldReturnReturnAllocationNumber()
        {
            // arrange
            DateTime contractStartDate = DateTime.Now.AddDays(7).Date;
            DateTime? contractEndDate = DateTime.Now.AddYears(1).Date;
            const int ukprn = 12345;
            const string allocationNumber = "AEB-1";
            const string fspCode = "fsp code";

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                context.ApprovedContracts.RemoveAll();

                context.ApprovedContracts.Add(new ApprovedContract(
                    "MAIN-1",
                    1,
                    0,
                    "AEB",
                    "AY1819",
                    ukprn,
                    "ORG12345",
                    "ESFA-1",
                    contractStartDate,
                    contractEndDate)
                {
                    ApprovedContractAllocations = new List<ApprovedContractAllocation>
                        { new ApprovedContractAllocation {ContractAllocationNumber = allocationNumber, FundingStreamPeriodCode = fspCode } }
                });
                context.SaveChanges();
            }

            ApprovedContractRepository approvedContractRepository = new ApprovedContractRepository();

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                // act
                var assertAllocationNumberOption = approvedContractRepository.FindAllocationNumberByUkprnAndFspCodeForLatestApproval(ukprn, fspCode, 
                        new ConnectionInfo(null, context.Database.Connection)).Result;

                // assert
                assertAllocationNumberOption.MatchSome(retrievedAllocationNumber =>
                {
                    Assert.AreEqual(allocationNumber, retrievedAllocationNumber, "Incorrect allocation number returned");
                });

                assertAllocationNumberOption.MatchNone(() => Assert.Fail("We should have returned a number"));
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ApprovedContractRepository_FindAllocationNumberByUkprnAndFspCode_ShouldReturnNullWhenNoContractAndNoAllocation()
        {
            // arrange
            const int ukprn = 12345;
            const string fspCode = "fsp code";

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                context.ApprovedContracts.RemoveAll();
                context.SaveChanges();
            }

            ApprovedContractRepository approvedContractRepository = new ApprovedContractRepository();

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                // act
                var assertAllocationNumberOption = approvedContractRepository.FindAllocationNumberByUkprnAndFspCodeForLatestApproval(ukprn, fspCode,
                        new ConnectionInfo(null, context.Database.Connection)).Result;

                // assert
                Assert.IsFalse(assertAllocationNumberOption.HasValue, "Null allocationNumber was not returned");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ApprovedContractRepository_FindAllocationNumberByUkprnAndFspCode_ShouldReturnNullWhenContractExistButThereIsNoAllocation()
        {
            // arrange
            DateTime contractStartDate = DateTime.Now.AddDays(7).Date;
            DateTime? contractEndDate = DateTime.Now.AddYears(1).Date;
            const int ukprn = 12345;
            const string fspCode = "fsp code";

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                context.ApprovedContracts.RemoveAll();

                context.ApprovedContracts.Add(new ApprovedContract(
                    "MAIN-1",
                    1,
                    0,
                    "AEB",
                    "AY1819",
                    ukprn,
                    "ORG12345",
                    "ESFA-1",
                    contractStartDate,
                    contractEndDate));

                context.SaveChanges();
            }

            ApprovedContractRepository approvedContractRepository = new ApprovedContractRepository();

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                // act
                var assertAllocationNumberOption = approvedContractRepository.FindAllocationNumberByUkprnAndFspCodeForLatestApproval(ukprn, fspCode,
                        new ConnectionInfo(null, context.Database.Connection)).Result;

                // assert
                Assert.IsFalse(assertAllocationNumberOption.HasValue, "Null allocationNumber was not returned");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ApprovedContractRepository_FindAllocationNumberByUkprnAndFspCode_ShouldReturnAllocationNumberWhenThereAreMultipleContracts()
        {
            // arrange
            DateTime contractStartDate = DateTime.Now.AddDays(7).Date;
            DateTime? contractEndDate = DateTime.Now.AddYears(1).Date;
            const int ukprn = 12345;
            const string fspCode = "fsp code";
            const string allocationNumber = "an2";
            const string latestAllocationNumber = "an3";

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                context.ApprovedContracts.RemoveAll();

                context.ApprovedContracts.Add(new ApprovedContract(
                    "MAIN-1",
                    1,
                    0,
                    "AEB",
                    "AY1819",
                    ukprn,
                    "ORG12345",
                    "ESFA-1",
                    contractStartDate,
                    contractEndDate)
                {
                    ApprovedContractAllocations = new List<ApprovedContractAllocation>
                        { new ApprovedContractAllocation {ContractAllocationNumber = allocationNumber, FundingStreamPeriodCode = fspCode } }
                });

                context.ApprovedContracts.Add(new ApprovedContract(
                    "MAIN-1",
                    2,
                    0,
                    "AEB",
                    "AY1819",
                    ukprn,
                    "ORG12345",
                    "ESFA-1",
                    contractStartDate,
                    contractEndDate)
                {
                    ApprovedContractAllocations = new List<ApprovedContractAllocation>
                        { new ApprovedContractAllocation {ContractAllocationNumber = latestAllocationNumber, FundingStreamPeriodCode = fspCode } }
                });

                context.SaveChanges();
            }

            ApprovedContractRepository approvedContractRepository = new ApprovedContractRepository();

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                // act
                var assertAllocationNumberOption = approvedContractRepository.FindAllocationNumberByUkprnAndFspCodeForLatestApproval(ukprn, fspCode,
                    new ConnectionInfo(null, context.Database.Connection)).Result;

                // assert
                assertAllocationNumberOption.MatchSome(retrievedAllocationNumber =>
                {
                    Assert.AreEqual(latestAllocationNumber, retrievedAllocationNumber, "Incorrect allocation number returned");
                });
            }
        }
    }
}
