namespace ContractCreateDomain.Endpoint.Tests.Services
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using ContractManagement.DataStore.Model;
    using Endpoint.Services;
    using Endpoint.Services.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class SiblingApprovedContractServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void SiblingApprovedContractService_GetSiblingApprovedContractsForDocumentGeneration_WithGivenContractNumber_ShouldReturnSiblingsWithSameMasterContractExcludingGivenContract_WhenFundingTypeFundingPeriodShouldIncludeAllContractsOnSummaryOfFunding()
        {
            ApprovedContract[] existingApprovedContracts =
            {
                new ApprovedContract("MAIN-1", 1, 0, "FT", "FP", 123, "ORG123", "ESFA-1", DateTime.Today, null) { ApprovedContractAllocations = new List<ApprovedContractAllocation>()},
                new ApprovedContract("MAIN-2", 1, 0, "FT", "FP", 123, "ORG123", "ESFA-1", DateTime.Today, null) { ApprovedContractAllocations = new List<ApprovedContractAllocation>()},
                new ApprovedContract("MAIN-3", 1, 0, "FT", "FP", 123, "ORG123", "ESFA-1", DateTime.Today, null)
                {
                    ApprovedContractAllocations = new List<ApprovedContractAllocation>
                    {
                        new ApprovedContractAllocation
                        {
                            ContractAllocationNumber = "ALLOC-1",
                            TotalPlannedValue = 100m,
                            PlannedValueEnvelope1 = 25m,
                            PlannedValueEnvelope2 = 75m,
                            ApprovedContractDeliverables = new List<ApprovedContractDeliverable>
                            {
                                new ApprovedContractDeliverable("ALLOC-1", 1, 100m, 25m, 75m),
                                new ApprovedContractDeliverable("ALLOC-1", 2, 0m, null, null),
                            }
                        }
                    }
                }
            };

            // arrange
            Mock<IApprovedContractRepository> approvedContractRepositoryMock = new Mock<IApprovedContractRepository>();
            approvedContractRepositoryMock
                .Setup(m => m.FindLatestByMasterContractNumber(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(existingApprovedContracts.ToList());

            Mock<IFundingTypeFundingPeriodRepository> fundingTypeFundingPeriodRepositoryMock = new Mock<IFundingTypeFundingPeriodRepository>();
            fundingTypeFundingPeriodRepositoryMock
                .Setup(m => m.ShouldIncludeAllContractsOnSummaryOfFunding(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(true);

            SiblingApprovedContractService siblingApprovedContractService = new SiblingApprovedContractService(
                approvedContractRepositoryMock.Object,
                fundingTypeFundingPeriodRepositoryMock.Object);

            // act
            IReadOnlyCollection<ApprovedContractInfo> siblingApprovedContracts =
                siblingApprovedContractService.GetSiblingApprovedContractsForDocumentGeneration("ESFA-1", "MAIN-2", "AEB", "AY1920", ConnectionInfo.CreateDefault()).Result;

            // assert
            Assert.IsNotNull(siblingApprovedContracts, "Unexpected null value returned");
            Assert.AreEqual(2, siblingApprovedContracts.Count, "Unexpected number of contracts returned");
            Assert.IsNotNull(siblingApprovedContracts.SingleOrDefault(ac => ac.ContractNumber == "MAIN-1"), "Expected contract not returned");
            Assert.IsNull(siblingApprovedContracts.SingleOrDefault(ac => ac.ContractNumber == "MAIN-2"), "Unexpected contract returned");
            Assert.IsNotNull(siblingApprovedContracts.SingleOrDefault(ac => ac.ContractNumber == "MAIN-3"), "Expected contract not returned");

            var contractWithAllocationsAndDeliverables = siblingApprovedContracts.Single(ac => ac.ContractNumber == "MAIN-3");
            Assert.AreEqual(1, contractWithAllocationsAndDeliverables.Allocations.Count, "Unexpected number of allocations returned");
            Assert.AreEqual(2, contractWithAllocationsAndDeliverables.Allocations.Single().Deliverables.Count, "Unexpected number of deliverables returned");

            var deliverable1 = contractWithAllocationsAndDeliverables.Allocations.Single().Deliverables.Single(d => d.DeliverableCode == 1);
            Assert.AreEqual(100m, deliverable1.TotalPlannedValue, "Unexpected Deliverable TotalPlannedValue");
            Assert.AreEqual(25m, deliverable1.PlannedValueEnvelope1, "Unexpected Deliverable PlannedValueEnvelope1");
            Assert.AreEqual(75m, deliverable1.PlannedValueEnvelope2, "Unexpected Deliverable PlannedValueEnvelope2");

            var deliverable2 = contractWithAllocationsAndDeliverables.Allocations.Single().Deliverables.Single(d => d.DeliverableCode == 2);
            Assert.AreEqual(0m, deliverable2.TotalPlannedValue, "Unexpected Deliverable TotalPlannedValue");
            Assert.IsNull(deliverable2.PlannedValueEnvelope1, "Unexpected Deliverable PlannedValueEnvelope1");
            Assert.IsNull(deliverable2.PlannedValueEnvelope2, "Unexpected Deliverable PlannedValueEnvelope2");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void SiblingApprovedContractService_GetSiblingApprovedContractsForDocumentGeneration_WithoutGivenContractNumber_ShouldReturnAllSiblingsWithSameMasterContract_WhenFundingTypeFundingPeriodShouldIncludeAllContractsOnSummaryOfFunding()
        {
            ApprovedContract[] existingApprovedContracts =
            {
                new ApprovedContract("MAIN-1", 1, 0, "FT", "FP", 123, "ORG123", "ESFA-1", DateTime.Today, null) { ApprovedContractAllocations = new List<ApprovedContractAllocation>()},
                new ApprovedContract("MAIN-2", 1, 0, "FT", "FP", 123, "ORG123", "ESFA-1", DateTime.Today, null) { ApprovedContractAllocations = new List<ApprovedContractAllocation>()},
                new ApprovedContract("MAIN-3", 1, 0, "FT", "FP", 123, "ORG123", "ESFA-1", DateTime.Today, null) { ApprovedContractAllocations = new List<ApprovedContractAllocation>()}
            };

            // arrange
            Mock<IApprovedContractRepository> approvedContractRepositoryMock = new Mock<IApprovedContractRepository>();
            approvedContractRepositoryMock
                .Setup(m => m.FindLatestByMasterContractNumber(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(existingApprovedContracts.ToList());

            Mock<IFundingTypeFundingPeriodRepository> fundingTypeFundingPeriodRepositoryMock = new Mock<IFundingTypeFundingPeriodRepository>();
            fundingTypeFundingPeriodRepositoryMock
                .Setup(m => m.ShouldIncludeAllContractsOnSummaryOfFunding(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(true);

            SiblingApprovedContractService siblingApprovedContractService = new SiblingApprovedContractService(
                approvedContractRepositoryMock.Object,
                fundingTypeFundingPeriodRepositoryMock.Object);

            // act
            IReadOnlyCollection<ApprovedContractInfo> siblingApprovedContracts =
                siblingApprovedContractService.GetSiblingApprovedContractsForDocumentGeneration("ESFA-1", "AEB", "AY1920", ConnectionInfo.CreateDefault()).Result;

            // assert
            Assert.IsNotNull(siblingApprovedContracts, "Unexpected null value returned");
            Assert.AreEqual(3, siblingApprovedContracts.Count, "Unexpected number of contracts returned");
            Assert.IsNotNull(siblingApprovedContracts.SingleOrDefault(ac => ac.ContractNumber == "MAIN-1"), "Expected contract not returned");
            Assert.IsNotNull(siblingApprovedContracts.SingleOrDefault(ac => ac.ContractNumber == "MAIN-2"), "Expected contract not returned");
            Assert.IsNotNull(siblingApprovedContracts.SingleOrDefault(ac => ac.ContractNumber == "MAIN-3"), "Expected contract not returned");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void SiblingApprovedContractService_GetSiblingApprovedContractsForDocumentGeneration_ShouldReturnEmptyCollection_WhenFundingTypeFundingPeriodShouldNotIncludeAllContractsOnSummaryOfFunding()
        {
            ApprovedContract[] existingApprovedContracts =
            {
                new ApprovedContract("MAIN-1", 1, 0, "FT", "FP", 123, "ORG123", "ESFA-1", DateTime.Today, null),
                new ApprovedContract("MAIN-2", 1, 0, "FT", "FP", 123, "ORG123", "ESFA-1", DateTime.Today, null),
                new ApprovedContract("MAIN-3", 1, 0, "FT", "FP", 123, "ORG123", "ESFA-1", DateTime.Today, null)
            };

            // arrange
            Mock<IApprovedContractRepository> approvedContractRepositoryMock = new Mock<IApprovedContractRepository>();
            approvedContractRepositoryMock
                .Setup(m => m.FindLatestByMasterContractNumber(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(existingApprovedContracts.ToList());

            Mock<IFundingTypeFundingPeriodRepository> fundingTypeFundingPeriodRepositoryMock = new Mock<IFundingTypeFundingPeriodRepository>();
            fundingTypeFundingPeriodRepositoryMock
                .Setup(m => m.ShouldIncludeAllContractsOnSummaryOfFunding(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(false);

            SiblingApprovedContractService siblingApprovedContractService = new SiblingApprovedContractService(
                approvedContractRepositoryMock.Object,
                fundingTypeFundingPeriodRepositoryMock.Object);

            // act
            IReadOnlyCollection<ApprovedContractInfo> siblingApprovedContracts =
                siblingApprovedContractService.GetSiblingApprovedContractsForDocumentGeneration("ESFA-1", "MAIN-2", "MAIN", "AY1920", ConnectionInfo.CreateDefault()).Result;

            // assert
            Assert.IsNotNull(siblingApprovedContracts, "Unexpected null value returned");
            Assert.AreEqual(0, siblingApprovedContracts.Count, "Unexpected number of contracts returned");
        }
    }
}
