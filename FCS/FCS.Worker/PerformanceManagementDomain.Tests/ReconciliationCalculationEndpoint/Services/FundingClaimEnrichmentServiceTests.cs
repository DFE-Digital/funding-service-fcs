namespace PerformanceManagementDomain.Tests.ReconciliationCalculationEndpoint.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.Services;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;
    using IContractAllocationDeliverableRepository = PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories.IContractAllocationDeliverableRepository;
    using IFspDeliverableClaimRepository = PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories.IFspDeliverableClaimRepository;

    [TestClass]
    public class FundingClaimEnrichmentServiceTests
    {
        private readonly Mock<IContractAllocationDeliverableRepository> _repositoryMock = new Mock<IContractAllocationDeliverableRepository>();
        private readonly Mock<IPolicyDeliverableRepository> _policyDeliverableMock = new Mock<IPolicyDeliverableRepository>();

        [TestMethod, TestCategory("UnitTest")]
        public async Task FundingClaimEnrichmentService_ShouldEnrichPlannedValuesWithValueOnAllocation()
        {
            // arrange
            const string allocationNumber = "Test Alloc";
            const string fundingStreamPeriodCode = "Test FSP";
            const decimal plannedValue = 10M;

            IReadOnlyCollection<ContractAllocationDeliverable> contractAllocationDeliverables = new List<ContractAllocationDeliverable>
            {
                new ContractAllocationDeliverable(allocationNumber, 1, plannedValue),
                new ContractAllocationDeliverable(allocationNumber, 2, 40M),
                new ContractAllocationDeliverable(allocationNumber, 3, 60M),
            };
            
            _repositoryMock.Setup(r => r.FindByAllocationNumber(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(contractAllocationDeliverables);

            Mock<IParentDeliverableResolver> parentDeliverableResolverMock = new Mock<IParentDeliverableResolver>();
            parentDeliverableResolverMock
                .Setup(m => m.GetParentDeliverableWithinClaimGroup(2, It.IsAny<IReadOnlyCollection<PolicyDeliverable>>(), It.IsAny<IReadOnlyCollection<FspDeliverableClaim>>()))
                .Returns(1);
            parentDeliverableResolverMock
                .Setup(m => m.GetParentDeliverableWithinClaimGroup(3, It.IsAny<IReadOnlyCollection<PolicyDeliverable>>(), It.IsAny<IReadOnlyCollection<FspDeliverableClaim>>()))
                .Returns(1);

            Mock<IFspDeliverableClaimRepository> fspDeliverableClaimRepoMock = new Mock<IFspDeliverableClaimRepository>();
            fspDeliverableClaimRepoMock
                .Setup(r => r.GetProfileDeliverableCodes(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(new List<int> {1});

            FundingClaimEnrichmentService fundingClaimEnrichmentService = new FundingClaimEnrichmentService(
                _repositoryMock.Object,
                _policyDeliverableMock.Object,
                fspDeliverableClaimRepoMock.Object,
                parentDeliverableResolverMock.Object);

            DebatchedFundingClaim fundingClaim = new DebatchedFundingClaim
            {
                AllocationGroupCode = "1",
            };

            fundingClaim.ContractAllocations.Add(new ContractAllocation
            {
                ContractAllocationNumber = allocationNumber,
                FundingStreamPeriodCode = fundingStreamPeriodCode,
                DeliverableLines = new List<DeliverableLine>
                {
                    new DeliverableLine
                    {
                        DeliverableCode = 1
                    },
                    new DeliverableLine
                    {
                        DeliverableCode = 2
                    },
                     new DeliverableLine
                    {
                        DeliverableCode = 3
                    }
                },
                PlannedValueAggregation = plannedValue
            });

            // act
            await fundingClaimEnrichmentService.Enrich(fundingClaim, ConnectionInfo.CreateDefault());

            // assert
            Assert.AreEqual(plannedValue, fundingClaim.ContractAllocations
                .Single(ca => ca.ContractAllocationNumber == allocationNumber)
                .DeliverableLines.Single(d => d.DeliverableCode == 1).PlannedValue, "Deliverable code 1 planned value is not correctly set");

            Assert.AreEqual(null, fundingClaim.ContractAllocations
              .Single(ca => ca.ContractAllocationNumber == allocationNumber)
              .DeliverableLines.Single(d => d.DeliverableCode == 1).ParentPlannedValue, "Deliverable code 1 - the parent planned value is not correctly set");

            Assert.AreEqual(40M, fundingClaim.ContractAllocations
                .Single(ca => ca.ContractAllocationNumber == allocationNumber)
                .DeliverableLines.Single(d => d.DeliverableCode == 2).PlannedValue, "Deliverable code 2 planned value is not correctly set");

            Assert.AreEqual(plannedValue, fundingClaim.ContractAllocations
                .Single(ca => ca.ContractAllocationNumber == allocationNumber)
                .DeliverableLines.Single(d => d.DeliverableCode == 2).ParentPlannedValue, "Deliverable code 2  - the parent planned value is not correctly set");

            Assert.AreEqual(60M, fundingClaim.ContractAllocations
                .Single(ca => ca.ContractAllocationNumber == allocationNumber)
                .DeliverableLines.Single(d => d.DeliverableCode == 3).PlannedValue, "Deliverable code 3 planned value is not correctly set");

            Assert.AreEqual(plannedValue, fundingClaim.ContractAllocations
               .Single(ca => ca.ContractAllocationNumber == allocationNumber)
               .DeliverableLines.Single(d => d.DeliverableCode == 3).ParentPlannedValue, "Deliverable code 3 - the parent planned value is not correctly set");

            Assert.AreEqual(plannedValue, fundingClaim.ContractAllocations
                .Single(ca => ca.ContractAllocationNumber == allocationNumber).PlannedValueAggregation, "The PlannedValueAggregation value is not set correctly");
        }
    }
}