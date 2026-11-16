using System.Collections.Generic;
using System.Linq;
using ContractManagement.DataStore.Repositories;
using ContractManagement.DataStore.Services;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
using SFA.FCT.CrossDomain.Integration.Entities.Data;
using ContractRequest = SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

namespace ContractManagementService.Tests.UnitTests.Services
{
    [TestClass, TestCategory("UnitTest")]
    public class LegalDeliverableServiceTests
    {
        private readonly Mock<IFundingStreamPeriodLegalDeliverableRepository> _repository = new();

        [TestMethod]
        public void RemoveNonLegalDeliverablesFromContract_UsesFundingStreamPeriodLegalCodes()
        {
            var firstAllocation = CorporateAllocation("FSP1", 1, 2);
            var secondAllocation = CorporateAllocation("FSP2", 3, 4);
            var masterContract = CorporateContract(firstAllocation, secondAllocation);
            _repository.Setup(repository => repository.GetLegalDeliverablesForFsp("FSP1"))
                .Returns([1]);
            _repository.Setup(repository => repository.GetLegalDeliverablesForFsp("FSP2"))
                .Returns([4]);
            var service = new LegalDeliverableService(_repository.Object);

            service.RemoveNonLegalDeliverablesFromContract(masterContract);

            AssertAllocationContains(firstAllocation, 1);
            AssertAllocationContains(secondAllocation, 4);
            _repository.Verify(repository => repository.GetLegalDeliverablesForFsp("FSP1"), Times.Once);
            _repository.Verify(repository => repository.GetLegalDeliverablesForFsp("FSP2"), Times.Once);
            _repository.Verify(
                repository => repository.GetLegalDeliverablesForFsp(It.IsAny<ConnectionInfo>(), It.IsAny<string>()),
                Times.Never);
        }

        [TestMethod]
        public void RemoveNonLegalDeliverablesFromContract_WithConnectionInfo_UsesConnectionAwareRepository()
        {
            var allocation = CorporateAllocation("FSP1", 1, 2);
            var masterContract = CorporateContract(allocation);
            var connectionInfo = ConnectionInfo.CreateDefault();
            _repository.Setup(repository => repository.GetLegalDeliverablesForFsp(connectionInfo, "FSP1"))
                .Returns([2]);
            var service = new LegalDeliverableService(_repository.Object);

            service.RemoveNonLegalDeliverablesFromContract(connectionInfo, masterContract);

            AssertAllocationContains(allocation, 2);
            _repository.Verify(repository => repository.GetLegalDeliverablesForFsp(connectionInfo, "FSP1"), Times.Once);
            _repository.Verify(repository => repository.GetLegalDeliverablesForFsp("FSP1"), Times.Never);
        }

        [TestMethod]
        public void RemoveNonLegalDeliverablesFromContractType_UsesConnectionAwareRepositoryAndFiltersRequestDeliverables()
        {
            var allocation = RequestAllocation("FSP1", 1, 2);
            var masterContract = new ContractRequest.contractType
            {
                contracts =
                [

                    new ContractRequest.contractType
                    {
                        contractAllocations = [allocation]
                    }
                ]
            };
            var connectionInfo = ConnectionInfo.CreateDefault();
            _repository.Setup(repository => repository.GetLegalDeliverablesForFsp(connectionInfo, "FSP1"))
                .Returns([1]);
            var service = new LegalDeliverableService(_repository.Object);

            service.RemoveNonLegalDeliverablesFromContractType(connectionInfo, masterContract);

            CollectionAssert.AreEqual(
                new[] { 1 },
                allocation.contractDeliverables.Select(d => d.deliverable.deliverableCode).ToArray());
            _repository.Verify(repository => repository.GetLegalDeliverablesForFsp(connectionInfo, "FSP1"), Times.Once);
            _repository.Verify(repository => repository.GetLegalDeliverablesForFsp("FSP1"), Times.Never);
        }

        private static Contract CorporateContract(params contractAllocationsContractAllocation[] allocations)
        {
            return new Contract
            {
                contracts =
                [

                    new contractType
                    {
                        contractAllocations = [.. allocations]
                    }
                ]
            };
        }

        private static contractAllocationsContractAllocation CorporateAllocation(string fspCode, params int[] codes)
        {
            return new contractAllocationsContractAllocation
            {
                fundingStreamPeriodCode = fspCode,
                contractDeliverables =
                [
                    .. codes.Select(code => new contractDeliverablesTypeContractDeliverable
                    {
                        deliverable = new deliverableType { deliverableCode = code }
                    })
                ]
            };
        }

        private static ContractRequest.contractAllocation RequestAllocation(string fspCode, params int[] codes)
        {
            return new ContractRequest.contractAllocation
            {
                fundingStreamPeriodCode = fspCode,
                contractDeliverables =
                [
                    .. codes.Select(code => new ContractRequest.contractDeliverable
                    {
                        deliverable = new ContractRequest.deliverableType { deliverableCode = code }
                    })
                ]
            };
        }

        private static void AssertAllocationContains(contractAllocationsContractAllocation allocation, int code)
        {
            CollectionAssert.AreEqual(
                new[] { code },
                allocation.contractDeliverables.Select(d => d.deliverable.deliverableCode).ToArray());
        }
    }
}
