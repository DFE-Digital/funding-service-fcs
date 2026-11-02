namespace PerformanceManagementDomain.Tests.ReconciliationCalculationEndpoint.Services
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.CrmRepositories;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.Services;

    [TestClass]
    public class FcrUpdateServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void FcrUpdateService_ShouldUpdateAFundingClaimInCrm()
        {
            const decimal adjustedCappedClaimValue = 101m;
            const decimal cappedClaimValue = 203m;
            // arrange
            List<AllocationTestInfo> testAllocs = new List<AllocationTestInfo>
            {
                new AllocationTestInfo("Alloc1", 100m, 0m, 2, 0){AdjustedCappedClaimValue = adjustedCappedClaimValue },
                new AllocationTestInfo("Alloc2", 200m, -100m, 2, 0)
                {
                    AdjustedCappedClaimValue = adjustedCappedClaimValue,
                    CappedClaimValue = cappedClaimValue
                },
                new AllocationTestInfo("Alloc3", 300m, 0m, 2, 0) {AdjustedCappedClaimValue = adjustedCappedClaimValue}
            };

            IEnumerable<ContractAllocation> allocations = CreateAllocations(testAllocs);

            AmountSummary amounts = new AmountSummary
            {
                PlannedValue = 601m,
                ClaimedValue = 701m,
                CappedClaimedValue = 601m,
                ProposedReconciliationValue = -100m,
                ReconciliationValue = -100m,
                AdjustedCappedClaimValue = 100m
            };

            Guid fcrAllocGuid = Guid.NewGuid();

            Mock<ICrmFundingClaimReconciliationRepository> repository = new Mock<ICrmFundingClaimReconciliationRepository>();
            repository.Setup(m => m.GetFcrAllocationInfos(It.IsAny<Guid>())).Returns(new List<AllocationPlannedValue>
            {
                new AllocationPlannedValue("Alloc1", 100m) { FcrAllocationId = Guid.NewGuid() },
                new AllocationPlannedValue("Alloc2", 201m) { FcrAllocationId = fcrAllocGuid },
                new AllocationPlannedValue("Alloc3", 300m) { FcrAllocationId = Guid.NewGuid() }
            });

            FcrUpdateService updateService = new FcrUpdateService(repository.Object);

            // act
            updateService.UpdateFundingClaimReconciliationInCrm(amounts, allocations, Guid.Empty);

            // assert
            repository.Verify(m => m.UpdateValues(It.IsAny<Guid>(), -100m, 601m, amounts.AdjustedCappedClaimValue.Value, amounts.CappedClaimedValue.Value), Times.Once, "UpdateValues not called with these params");
            repository.Verify(m => m.AssociateAllocationToFcrAndUpdateValues(It.IsAny<Guid>(), fcrAllocGuid, "Alloc2", 2, 0, 200m, -100m, adjustedCappedClaimValue, cappedClaimValue), Times.Once);
            repository.Verify(m => m.IssueCrmNotificationForAllocation("Alloc2", 2), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FcrUpdateService_ShouldNotUpdateAFundingClaimReconciliationAllocationInCrmWhichHasNotChanged()
        {
            // arrange
            List<AllocationTestInfo> testAllocs = new List<AllocationTestInfo>
            {
                new AllocationTestInfo("Alloc1", 100m, 0m, 2, 0),
                new AllocationTestInfo("Alloc2", 200m, -100m, 2, 0),
                new AllocationTestInfo("Alloc3", 300m, 0m, 2, 0)
            };

            IEnumerable<ContractAllocation> allocations = CreateAllocations(testAllocs);

            AmountSummary amounts = new AmountSummary
            {
                PlannedValue = 601m,
                ClaimedValue = 701m,
                CappedClaimedValue = 601m,
                ProposedReconciliationValue = -100m,
                ReconciliationValue = -100m,
                AdjustedCappedClaimValue = 100m
            };

            Mock<ICrmFundingClaimReconciliationRepository> repository = new Mock<ICrmFundingClaimReconciliationRepository>();
            repository.Setup(m => m.GetFcrAllocationInfos(It.IsAny<Guid>())).Returns(new List<AllocationPlannedValue>
            {
                new AllocationPlannedValue("Alloc1", 100m) { FcrAllocationId = Guid.NewGuid() },
                new AllocationPlannedValue("Alloc2", 200m) { FcrAllocationId = Guid.NewGuid() },
                new AllocationPlannedValue("Alloc3", 300m) { FcrAllocationId = Guid.NewGuid() }
            });

            FcrUpdateService updateService = new FcrUpdateService(repository.Object);

            // act
            updateService.UpdateFundingClaimReconciliationInCrm(amounts, allocations, Guid.Empty);

            // assert
            repository.Verify(m => m.UpdateValues(
                It.IsAny<Guid>(),
                -100m,
                601m, amounts.AdjustedCappedClaimValue.Value,
                amounts.CappedClaimedValue.Value), Times.Once);
            repository.Verify(m => m.AssociateAllocationToFcrAndUpdateValues(It.IsAny<Guid>(), It.IsAny<Guid>(), It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>(), It.IsAny<decimal>(), It.IsAny<decimal>(), It.IsAny<decimal>(), It.IsAny<decimal>()), Times.Never);
            repository.Verify(m => m.IssueCrmNotificationForAllocation(It.IsAny<string>(), It.IsAny<int>()), Times.Never);
        }

        private IEnumerable<ContractAllocation> CreateAllocations(List<AllocationTestInfo> allocationTestInfos)
        {
            return allocationTestInfos.Select(allocationTestInfo => new ContractAllocation
            {
                ContractAllocationNumber = allocationTestInfo.AllocationNumber,
                Contract = new Contract
                {
                    ContractVersionNumber = allocationTestInfo.ContractVersion,
                    ContractSubVersionNumber = allocationTestInfo.ContractSubVersion
                },
                Amounts = new AmountSummary
                {
                    PlannedValue = allocationTestInfo.PlannedValue,
                    ProposedReconciliationValue = allocationTestInfo.ProposedReconciliationValue,
                    AdjustedCappedClaimValue = allocationTestInfo.AdjustedCappedClaimValue,
                    CappedClaimedValue = allocationTestInfo.CappedClaimValue
                }
            }).ToList();
        }

        private class AllocationTestInfo
        {
            public AllocationTestInfo(string allocationNumber, decimal plannedValue, decimal proposedReconciliationValue, int contractVersion, int contractSubVersion)
            {
                AllocationNumber = allocationNumber;
                PlannedValue = plannedValue;
                ProposedReconciliationValue = proposedReconciliationValue;
                ContractVersion = contractVersion;
                ContractSubVersion = contractSubVersion;
            }

            public string AllocationNumber { get; }

            public decimal PlannedValue { get; }

            public decimal ProposedReconciliationValue { get; }

            public int ContractVersion { get; }

            public int ContractSubVersion { get; }

            public decimal AdjustedCappedClaimValue { get; set; }
            public decimal CappedClaimValue { get; set; }
        }
    }
}