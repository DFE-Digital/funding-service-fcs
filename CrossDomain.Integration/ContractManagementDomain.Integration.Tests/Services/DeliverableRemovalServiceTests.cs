namespace SFA.FCT.ContractManagementDomain.Integration.Tests.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using ContractManagement.DataStore.Services;
    using CrossDomain.Integration.Entities.CorporateContract;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using UnitTests.Common;
    using ContractRequest = SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    [TestClass]
    public class DeliverableRemovalServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void DeliverableRemovalService_ShouldRemoveDeliverablesThatAreNotRequired()
        {
            // arrange
            List<int> deliverablesToKeep = new List<int> {1, 6};
                      
            contract masterContract = TestResource.FromJson<contract>("SFA.FCT.ContractManagementDomain.Integration.Tests",
                "Resources.NCS_Contract.json");
            
            var childContract = masterContract.contracts.First();

            var allDeliverables = childContract.contractAllocations.SelectMany(ca => ca.GetAllDeliverables()).ToList();

            bool areDeliverablesToRemovePresent = allDeliverables
                    .Any(d => !deliverablesToKeep.Contains(d.deliverable.deliverableCode));

            Assert.IsTrue(areDeliverablesToRemovePresent, "we do not have any deliverables that we wanted to remove");
            childContract.contractAllocations.ForEach(allocation =>
            {
                // act
                DeliverableRemovalService.RemoveNonMatchingDeliverablesFromAllocation(allocation, deliverablesToKeep);
            });
            
            // assert
            allDeliverables = childContract.contractAllocations.SelectMany(ca => ca.GetAllDeliverables()).ToList();
            bool areDeliverablesToRemoveStillPresent =
                allDeliverables
                    .Any(d => !deliverablesToKeep.Contains(d.deliverable.deliverableCode));
            Assert.IsFalse(areDeliverablesToRemoveStillPresent, "The deliverables we tried to remove are still present");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliverableRemovalService_ShouldRemoveDeliverablesThatAreNotRequiredOnContractType()
        {
            // arrange
            List<int> deliverablesToKeep = new List<int> { 1, 6 };
            List<int> deliverablesToRemove = new List<int> { 7 };

            ContractRequest.contractType masterContract = new ContractRequest.contractType
            {
                contracts = new List<ContractRequest.contractType>
                {
                    new ContractRequest.contractType
                    {
                        contractAllocations = new List<ContractRequest.contractAllocation>
                        {
                            new ContractRequest.contractAllocation
                            {
                                contractDeliverables = GetDeliverables(deliverablesToKeep.Concat(deliverablesToRemove))
                            },

                        }
                    }
                }
            };

            var childContract = masterContract.contracts.First();
            int numNonLegalDeliverables = childContract.contractAllocations.Sum(a =>
                a.contractDeliverables.Count(d => deliverablesToRemove.Contains(d.deliverable.deliverableCode)));
            Assert.IsTrue(numNonLegalDeliverables > 0, "The are no legal deliverables to start with");
            childContract.contractAllocations.ForEach(allocation =>
            {
                // act
                DeliverableRemovalService.RemoveNonMatchingDeliverablesFromAllocation(allocation, deliverablesToKeep);
            });

            // assert
            numNonLegalDeliverables =  childContract.contractAllocations.Sum(a =>
                a.contractDeliverables.Count(d => deliverablesToRemove.Contains(d.deliverable.deliverableCode)));
            Assert.AreEqual(0, numNonLegalDeliverables, "The are some non legal deliverables");
        }

        private static List<ContractRequest.contractDeliverable> GetDeliverables(IEnumerable<int> deliverableCodes)
        {
            return deliverableCodes.Select(code => new ContractRequest.contractDeliverable
            {
                deliverable = new ContractRequest.deliverableType
                {
                    deliverableCode = code
                }
            }).ToList();
        }
    }
}
