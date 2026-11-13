namespace ContractCreateDomain.IncrementContractVersionEndpoint.Tests.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using IncrementContractVersionEndpoint.Repositories;
    using IncrementContractVersionEndpoint.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging.Interfaces;
    using contract = SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.Contract;

    [TestClass]
    public class RelatedAllocationEnricherTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void RelatedAllocationEnricher_ShouldSetRelatedAllocationNumbersForProviderReliefSchemeFundingStreamPeriods()
        {
            // arrange
            var corpContract = new contract
            {
                fundingType = new fundingType { fundingTypeCode = "AEB" },
                contractAllocations = new List<contractAllocationsContractAllocation>
                {
                    new contractAllocationsContractAllocation { contractAllocationNumber = "ALLOC_1", fundingStreamPeriodCode = "AEB-AS1920"},
                    new contractAllocationsContractAllocation { contractAllocationNumber = "ALLOC_2", fundingStreamPeriodCode = "AEB-PRS1920"},
                    new contractAllocationsContractAllocation { contractAllocationNumber = "ALLOC_3", fundingStreamPeriodCode = "AEB-AS2021"},
                    new contractAllocationsContractAllocation { contractAllocationNumber = "ALLOC_4", fundingStreamPeriodCode = "AEB-PRS2021"},
                    new contractAllocationsContractAllocation { contractAllocationNumber = "ALLOC_5", fundingStreamPeriodCode = "16-18NLAP2018"},
                    new contractAllocationsContractAllocation { contractAllocationNumber = "ALLOC_6", fundingStreamPeriodCode = "16-18NLAP-PRS2020"},
                    new contractAllocationsContractAllocation { contractAllocationNumber = "ALLOC_7", fundingStreamPeriodCode = "ANLAP2018"},
                    new contractAllocationsContractAllocation { contractAllocationNumber = "ALLOC_8", fundingStreamPeriodCode = "ANLAP-PRS2020"},
                    new contractAllocationsContractAllocation { contractAllocationNumber = "CONTROL_ALLOC_NUMBER_SHOULD_NOT_CHANGE", fundingStreamPeriodCode = "UNRELATED_FSP"}
                }
            };

            // act
            RelatedAllocationEnricher.EnrichWithRelatedAllocationsWhenAppropriate(corpContract, Mock.Of<ILogger>(), Mock.Of<IApprovedContractRepository>(), ConnectionInfo.CreateDefault()).Wait();

            // assert
            var relatedFsps = new Dictionary<string, string>
            {
                { "AEB-PRS1920", "AEB-AS1920" },
                { "AEB-PRS2021", "AEB-AS2021" },
                { "16-18NLAP-PRS2020", "16-18NLAP2018" },
                { "ANLAP-PRS2020", "ANLAP2018" }
            };

            foreach (KeyValuePair<string, string> relatedFspPair in relatedFsps)
            {
                var providerReliefSchemaAllocation = corpContract.contractAllocations.Single(a => a.fundingStreamPeriodCode == relatedFspPair.Key);
                var relatedAllocation = corpContract.contractAllocations.Single(a => a.fundingStreamPeriodCode == relatedFspPair.Value);

                Assert.AreEqual(relatedAllocation.contractAllocationNumber, providerReliefSchemaAllocation.contractAllocationNumber,
                    $"Allocation Number not enriched correctly for FSP {relatedFspPair.Key}");
            }

            var controlAllocation = corpContract.contractAllocations.Single(a => a.fundingStreamPeriodCode == "UNRELATED_FSP");
            Assert.AreEqual("CONTROL_ALLOC_NUMBER_SHOULD_NOT_CHANGE", controlAllocation.contractAllocationNumber,
                "Allocation number should not have been changed for FSP with no related FSP");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void RelatedAllocationEnricher_ShouldSetAllocationNumberToEmptyWhenNoRelatedAllocationFoundForProviderReliefSchemeAllocation()
        {
            // arrange
            var corpContract = new contract
            {
                fundingType = new fundingType { fundingTypeCode = "AEB" },
                contractAllocations = new List<contractAllocationsContractAllocation>
                {
                    new contractAllocationsContractAllocation { contractAllocationNumber = "PRS_ALLOC", fundingStreamPeriodCode = "AEB-PRS1920"}
                }
            };

            // act
            RelatedAllocationEnricher.EnrichWithRelatedAllocationsWhenAppropriate(corpContract, Mock.Of<ILogger>(), Mock.Of<IApprovedContractRepository>(), ConnectionInfo.CreateDefault()).Wait();

            // assert
            var prsAllocation = corpContract.contractAllocations.Single();
            Assert.IsNull(prsAllocation.contractAllocationNumber);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void RelatedAllocationEnricher_ShouldGetAllocationNumberFromDbWhenRequired()
        {
            // arrange
            const string fspTheRequiresDbLookup = "ANLAP-AS2019";
            var corpContract = new contract
            {
                fundingType = new fundingType { fundingTypeCode = "AEB" },
                contractAllocations = new List<contractAllocationsContractAllocation>
                {
                    new contractAllocationsContractAllocation { contractAllocationNumber = "PRS_ALLOC", fundingStreamPeriodCode = fspTheRequiresDbLookup}
                }
            };

            var approvedContractRepositoryMock = new Mock<IApprovedContractRepository>();

            // act
            RelatedAllocationEnricher.EnrichWithRelatedAllocationsWhenAppropriate(corpContract, Mock.Of<ILogger>(), approvedContractRepositoryMock.Object, ConnectionInfo.CreateDefault()).Wait();

            // assert
           approvedContractRepositoryMock.Verify(r => r.FindAllocationNumberByUkprnAndFspCodeForLatestApproval(It.IsAny<int>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void RelatedAllocationEnricher_ShouldSetRelatedAllocationNumbersForProviderReliefSchemeFundingStreamPeriodsForSharedMasterContractDtos()
        {
            // arrange
            var approvedContractInfo = new ApprovedContractInfo
            {
                FundingType = "AEB",
                Allocations = new List<ApprovedContractAllocationInfo>
                {
                    new ApprovedContractAllocationInfo { ContractAllocationNumber = "ALLOC_1", FundingStreamPeriodCode = "AEB-AS1920"},
                    new ApprovedContractAllocationInfo { ContractAllocationNumber = "ALLOC_2", FundingStreamPeriodCode = "AEB-PRS1920"},
                    new ApprovedContractAllocationInfo { ContractAllocationNumber = "ALLOC_3", FundingStreamPeriodCode = "AEB-AS2021"},
                    new ApprovedContractAllocationInfo { ContractAllocationNumber = "ALLOC_4", FundingStreamPeriodCode = "AEB-PRS2021"},
                    new ApprovedContractAllocationInfo { ContractAllocationNumber = "ALLOC_5", FundingStreamPeriodCode = "16-18NLAP2018"},
                    new ApprovedContractAllocationInfo { ContractAllocationNumber = "ALLOC_6", FundingStreamPeriodCode = "16-18NLAP-PRS2020"},
                    new ApprovedContractAllocationInfo { ContractAllocationNumber = "ALLOC_7", FundingStreamPeriodCode = "ANLAP2018"},
                    new ApprovedContractAllocationInfo { ContractAllocationNumber = "ALLOC_8", FundingStreamPeriodCode = "ANLAP-PRS2020"},
                    new ApprovedContractAllocationInfo { ContractAllocationNumber = "CONTROL_ALLOC_NUMBER_SHOULD_NOT_CHANGE", FundingStreamPeriodCode = "UNRELATED_FSP"}
                }
            };

            // act
            RelatedAllocationEnricher.EnrichWithRelatedAllocationsWhenAppropriate(approvedContractInfo);

            // assert
            var relatedFsps = new Dictionary<string, string>
            {
                { "AEB-PRS1920", "AEB-AS1920" },
                { "AEB-PRS2021", "AEB-AS2021" },
                { "16-18NLAP-PRS2020", "16-18NLAP2018" },
                { "ANLAP-PRS2020", "ANLAP2018" }
            };

            foreach (KeyValuePair<string, string> relatedFspPair in relatedFsps)
            {
                var providerReliefSchemaAllocation = approvedContractInfo.Allocations.Single(a => a.FundingStreamPeriodCode == relatedFspPair.Key);
                var relatedAllocation = approvedContractInfo.Allocations.Single(a => a.FundingStreamPeriodCode == relatedFspPair.Value);

                Assert.AreEqual(relatedAllocation.ContractAllocationNumber, providerReliefSchemaAllocation.ContractAllocationNumber,
                    $"Allocation Number not enriched correctly for FSP {relatedFspPair.Key}");
            }

            var controlAllocation = approvedContractInfo.Allocations.Single(a => a.FundingStreamPeriodCode == "UNRELATED_FSP");
            Assert.AreEqual("CONTROL_ALLOC_NUMBER_SHOULD_NOT_CHANGE", controlAllocation.ContractAllocationNumber,
                "Allocation number should not have been changed for FSP with no related FSP");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void RelatedAllocationEnricher_ShouldSetAllocationNumberToEmptyWhenNoRelatedAllocationFoundForProviderReliefSchemeAllocationForSharedMasterContractDtos()
        {
            // arrange
            var approvedContractInfo = new ApprovedContractInfo
            {
                FundingType = "AEB",
                Allocations = new List<ApprovedContractAllocationInfo>
                {
                    new ApprovedContractAllocationInfo { ContractAllocationNumber = "PRS_ALLOC", FundingStreamPeriodCode = "AEB-PRS1920"}
                }
            };

            // act
            RelatedAllocationEnricher.EnrichWithRelatedAllocationsWhenAppropriate(approvedContractInfo);

            // assert
            var prsAllocation = approvedContractInfo.Allocations.Single();
            Assert.IsNull(prsAllocation.ContractAllocationNumber);
        }
    }
}
