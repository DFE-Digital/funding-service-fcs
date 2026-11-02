namespace ContractCreateDomain.IncrementContractVersionEndpoint.Tests.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using IncrementContractVersionEndpoint.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class ApprovedContractRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ApprovedContractRepository_FindByMasterContractNumber_ShouldTheLatestApprovedVersionsForEachContract()
        {
            // arrange
            const string contractNumber = "CN4";
            const string masterContractNumber = "MCN4";
            const string masterContractNumber2 = "MCN6";
            RemoveContractsByMasterContractNumber(masterContractNumber);
            RemoveContractsByMasterContractNumber(masterContractNumber2);

            ApprovedContract approvedContract = new ApprovedContract(
                contractNumber, 
                1, 
                0, 
                "AEB", "AY1920", 12345678, "orgId", masterContractNumber, DateTime.Now, DateTime.Now);
            CreateApprovedContarct(approvedContract);
            approvedContract = new ApprovedContract(
                contractNumber,
                2,
                0,
                "AEB", "AY1920", 12345678, "orgId", masterContractNumber, DateTime.Now, DateTime.Now);
            CreateApprovedContarct(approvedContract);
            approvedContract = new ApprovedContract(
                contractNumber,
                3,
                0,
                "AEB", "AY1920", 12345678, "orgId", masterContractNumber, DateTime.Now, DateTime.Now);
            CreateApprovedContarct(approvedContract);

            approvedContract = new ApprovedContract(
                contractNumber + "2",
                1,
                0,
                "AEB", "AY1920", 12345678, "orgId", masterContractNumber, DateTime.Now, DateTime.Now);
            CreateApprovedContarct(approvedContract);

            approvedContract = new ApprovedContract(
                contractNumber + "2",
                2,
                0,
                "AEB", "AY1920", 12345678, "orgId", masterContractNumber, DateTime.Now, DateTime.Now)
            {
                ApprovedContractAllocations = new List<ApprovedContractAllocation>
                {
                    new ApprovedContractAllocation
                    {
                        ContractAllocationNumber = "AEB-1",
                        TotalPlannedValue = 200m,
                        ApprovedContractDeliverables = new List<ApprovedContractDeliverable>
                        {
                            new ApprovedContractDeliverable("AEB-1", 1, 100m, 25, null)
                        }
                    }
                }
            };
            CreateApprovedContarct(approvedContract);

            approvedContract = new ApprovedContract(
                contractNumber + "3",
                1,
                0,
                "AEB", "AY1920", 12345678, "orgId", masterContractNumber2, DateTime.Now, DateTime.Now);
            CreateApprovedContarct(approvedContract);

            using (var context = new ContractManagementDbContext())
            {
                ApprovedContractRepository repository = new ApprovedContractRepository();

                // act
                var contracts = repository.FindByMasterContractNumber(masterContractNumber,
                    new ConnectionInfo(null, connection: context.Database.Connection)).Result;
                
                // assert
                Assert.AreEqual(2, contracts.Count, "The number of contracts is not correct");
                Assert.AreEqual(3, contracts.Single(c => c.ContractNumber == contractNumber).ContractVersionNumber, $"The ContractVersionNumber is not correct for {contractNumber}");
                Assert.AreEqual(2, contracts.Single(c => c.ContractNumber == contractNumber + "2").ContractVersionNumber, $"The ContractVersionNumber is not correct for {contractNumber + "2"}");

                ApprovedContract sampleContract = contracts.Single(c => c.ContractNumber == contractNumber + "2");

                Assert.AreEqual(1, sampleContract.ApprovedContractAllocations.Count, "Approved Contract Allocations count is not correct");

                ApprovedContractAllocation sampleAllocation = sampleContract.ApprovedContractAllocations.Single();
                Assert.AreEqual("AEB-1", sampleAllocation.ContractAllocationNumber, "Unexpected ContractAllocationNumber returned");
                Assert.AreEqual(200m, sampleAllocation.TotalPlannedValue, "Unexpected TotalPlannedValue returned");
                Assert.AreEqual(1, sampleAllocation.ApprovedContractDeliverables.Count, "Unexpected number of deliverables returned");

                ApprovedContractDeliverable sampleDeliverable = sampleAllocation.ApprovedContractDeliverables.Single();
                Assert.AreEqual(1, sampleDeliverable.DeliverableCode, "Unexpected DeliverableCode returned");
                Assert.AreEqual(100m, sampleDeliverable.TotalPlannedValue, "Unexpected TotalPlannedValue returned");
                Assert.AreEqual(25m, sampleDeliverable.PlannedValueEnvelope1, "Unexpected PlannedValueEnvelope1 returned");
                Assert.IsNull(sampleDeliverable.PlannedValueEnvelope2, "Unexpected PlannedValueEnvelope2 returned");
            }
        }

        private void CreateApprovedContarct(ApprovedContract approvedContract)
        {
            using (var context = new ContractManagementDbContext())
            {
                context.ApprovedContracts.Add(approvedContract);

                context.SaveChanges();
            }
        }

        private void RemoveContractsByMasterContractNumber(string masterContractNumber)
        {
            using (var context = new ContractManagementDbContext())
            {
                context.ApprovedContracts.Where(ac => ac.MasterContractNumber == masterContractNumber).ToList()
                    .ForEach(ac => context.ApprovedContracts.Remove(ac));

                context.SaveChanges();
            }
        }
    }
}
