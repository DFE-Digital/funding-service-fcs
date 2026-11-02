using System.Collections.Generic;
using System.Linq;
using ContractManagement.DataStore.Services;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
using ContractRequest = SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

namespace ContractManagementService.Tests.UnitTests.Services
{
    [TestClass, TestCategory("UnitTest")]
    public class DeliverableRemovalServiceTests
    {
        [TestMethod]
        public void RemoveNonMatchingDeliverablesFromAllocation_CorporateContract_RemovesNonLegalDeliverablesAtEveryLevel()
        {
            var allocation = new contractAllocationsContractAllocation
            {
                contractDeliverables =
                [

                    CorporateDeliverable(1,
                        CorporateDeliverable(2),
                        CorporateDeliverable(3,
                            CorporateDeliverable(4),
                            CorporateDeliverable(5))),

                    CorporateDeliverable(6)
                ]
            };

            DeliverableRemovalService.RemoveNonMatchingDeliverablesFromAllocation(
                allocation,
                [1, 3, 4]);

            Assert.AreEqual(1, allocation.contractDeliverables.Count);
            Assert.AreEqual(1, allocation.contractDeliverables[0].deliverable.deliverableCode);
            Assert.AreEqual(1, allocation.contractDeliverables[0].contractDeliverables.Count);
            Assert.AreEqual(3, allocation.contractDeliverables[0].contractDeliverables[0].deliverable.deliverableCode);
            Assert.AreEqual(1, allocation.contractDeliverables[0].contractDeliverables[0].contractDeliverables.Count);
            Assert.AreEqual(4, allocation.contractDeliverables[0].contractDeliverables[0].contractDeliverables[0].deliverable.deliverableCode);
        }

        [TestMethod]
        public void RemoveNonMatchingDeliverablesFromAllocation_CorporateContract_NullChildrenDoNotPreventFiltering()
        {
            var allocation = new contractAllocationsContractAllocation
            {
                contractDeliverables =
                [
                    CorporateDeliverable(1),
                    CorporateDeliverable(2)
                ]
            };
            allocation.contractDeliverables[0].contractDeliverables = null;

            DeliverableRemovalService.RemoveNonMatchingDeliverablesFromAllocation(allocation, [1]);

            Assert.AreEqual(1, allocation.contractDeliverables.Count);
            Assert.AreEqual(1, allocation.contractDeliverables[0].deliverable.deliverableCode);
            Assert.IsNull(allocation.contractDeliverables[0].contractDeliverables);
        }

        [TestMethod]
        public void RemoveNonMatchingDeliverablesFromAllocation_ContractRequest_RemovesNonMatchingTopLevelDeliverables()
        {
            var allocation = new ContractRequest.contractAllocation
            {
                contractDeliverables =
                [
                    RequestDeliverable(1),
                    RequestDeliverable(2),
                    RequestDeliverable(3)
                ]
            };

            DeliverableRemovalService.RemoveNonMatchingDeliverablesFromAllocation(allocation, [1, 3]);

            CollectionAssert.AreEqual(
                new[] { 1, 3 },
                allocation.contractDeliverables.Select(d => d.deliverable.deliverableCode).ToArray());
        }

        private static contractDeliverablesTypeContractDeliverable CorporateDeliverable(
            int code,
            params contractDeliverablesTypeContractDeliverable[] children)
        {
            return new contractDeliverablesTypeContractDeliverable
            {
                deliverable = new deliverableType { deliverableCode = code },
                contractDeliverables = [.. children]
            };
        }

        private static ContractRequest.contractDeliverable RequestDeliverable(int code)
        {
            return new ContractRequest.contractDeliverable
            {
                deliverable = new ContractRequest.deliverableType { deliverableCode = code }
            };
        }
    }
}
