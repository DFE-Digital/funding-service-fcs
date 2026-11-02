namespace ContractCreateDomain.Endpoint.Tests.Services
{
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using Endpoint.Services;
    using Endpoint.Services.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using Newtonsoft.Json;
    using Optional;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class RelatedAllocationEnricherTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void RelatedAllocationEnricher_ShouldUpdateAllocationNumber_WhenFoundInApprovedContractAllocations()
        {
            // arrange
            const string allocationNumber = "Test";
            IReadOnlyCollection<string> fspsToHaveAllocationNumberReplaced = new List<string> { "ANLAP-AS2019", "16-18NLAP-AS2019" };
            Mock<IApprovedContractRepository> approvedContractRepositoryMock = new Mock<IApprovedContractRepository>();
            approvedContractRepositoryMock.Setup(r =>
                    r.FindAllocationNumberByUkprnAndFspCodeForLatestApproval(It.IsAny<int>(), It.IsAny<string>(),
                        It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(allocationNumber.SomeWhen(n => n != null));

            RelatedAllocationEnricher relatedAllocationEnricher = new RelatedAllocationEnricher(approvedContractRepositoryMock.Object);
            contract contract = GetContractFromFile("Resources.NlapContract.json");

            // act
            relatedAllocationEnricher
                .EnrichWithRelatedAllocationsWhenAppropriate(contract, new ConnectionInfo(null, null))
                .Wait();

            // assert
            var allocationsToBeAffected = contract.contractAllocations
                .Where(a => fspsToHaveAllocationNumberReplaced.Contains(a.fundingStreamPeriodCode)).ToList();

            Assert.IsTrue(allocationsToBeAffected.All(a => a.contractAllocationNumber == allocationNumber));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void RelatedAllocationEnricher_ShouldUpdateAllocationNumberToNull_WhenNotFoundInApprovedContractAllocations()
        {
            // arrange
            const string allocationNumber = null;
            IReadOnlyCollection<string> fspsToHaveAllocationNumberReplaced = new List<string> { "ANLAP-AS2019", "16-18NLAP-AS2019" };
            Mock<IApprovedContractRepository> approvedContractRepositoryMock = new Mock<IApprovedContractRepository>();
            approvedContractRepositoryMock.Setup(r =>
                    r.FindAllocationNumberByUkprnAndFspCodeForLatestApproval(It.IsAny<int>(), It.IsAny<string>(),
                        It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(allocationNumber.SomeWhen(n => n != null));

            RelatedAllocationEnricher relatedAllocationEnricher = new RelatedAllocationEnricher(approvedContractRepositoryMock.Object);
            contract contract = GetContractFromFile("Resources.NlapContract.json");

            // act
            relatedAllocationEnricher
                .EnrichWithRelatedAllocationsWhenAppropriate(contract, new ConnectionInfo(null, null))
                .Wait();

            // assert
            var allocationsToBeAffected = contract.contractAllocations
                .Where(a => fspsToHaveAllocationNumberReplaced.Contains(a.fundingStreamPeriodCode)).ToList();

            Assert.IsTrue(allocationsToBeAffected.All(a => a.contractAllocationNumber == allocationNumber));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void RelatedAllocationEnricher_ShouldSetRelatedAllocationNumbersForProviderReliefSchemeFundingStreamPeriods()
        {
            // arrange
            RelatedAllocationEnricher relatedAllocationEnricher = new RelatedAllocationEnricher(Mock.Of<IApprovedContractRepository>());
            contract contract = GetContractFromFile("Resources.AEB-PRS-CorpContract.json");

            // act
            relatedAllocationEnricher.EnrichWithRelatedAllocationsWhenAppropriate(contract, ConnectionInfo.CreateDefault()).Wait();

            // assert
            var relatedFsps = new Dictionary<string, string>
            {
                { "AEB-PRS1920", "AEB-AS1920" },
                //{ "AEB-PRS2021", "AEB-AS2021" },
                //{ "16-18NLAP-PRS2020", "16-18NLAP2018" },
                //{ "ANLAP-PRS2020", "ANLAP2018" } 
            };

            foreach (KeyValuePair<string, string> relatedFspPair in relatedFsps)
            {
                var providerReliefSchemaAllocation = contract.contractAllocations.Single(a => a.fundingStreamPeriodCode == relatedFspPair.Key);
                var relatedAllocation = contract.contractAllocations.Single(a => a.fundingStreamPeriodCode == relatedFspPair.Value);

                Assert.AreEqual(relatedAllocation.contractAllocationNumber, providerReliefSchemaAllocation.contractAllocationNumber,
                    $"Allocation Number not enriched correctly for FSP {relatedFspPair.Key}");
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void RelatedAllocationEnricher_ShouldSetRelatedAllocationNumbersForProviderReliefSchemeFundingStreamPeriodsForSharedMasterContractDtos()
        {
            // arrange
            RelatedAllocationEnricher relatedAllocationEnricher = new RelatedAllocationEnricher(Mock.Of<IApprovedContractRepository>());

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
            relatedAllocationEnricher.EnrichWithRelatedAllocationsWhenAppropriate(approvedContractInfo);

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
            Assert.AreEqual("CONTROL_ALLOC_NUMBER_SHOULD_NOT_CHANGE", controlAllocation.ContractAllocationNumber);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void RelatedAllocationEnricher_ShouldSetAllocationNumberToEmptyWhenNoRelatedAllocationFoundForProviderReliefSchemeAllocationForSharedMasterContractDtos()
        {
            // arrange
            RelatedAllocationEnricher relatedAllocationEnricher = new RelatedAllocationEnricher(Mock.Of<IApprovedContractRepository>());

            var approvedContractInfo = new ApprovedContractInfo
            {
                FundingType = "AEB",
                Allocations = new List<ApprovedContractAllocationInfo>
                {
                    new ApprovedContractAllocationInfo { ContractAllocationNumber = "PRS_ALLOC", FundingStreamPeriodCode = "AEB-PRS1920"}
                }
            };

            // act
            relatedAllocationEnricher.EnrichWithRelatedAllocationsWhenAppropriate(approvedContractInfo);

            // assert
            var prsAllocation = approvedContractInfo.Allocations.Single();
            Assert.IsNull(prsAllocation.ContractAllocationNumber);
        }

        private static contract GetContractFromFile(string filename)
        {
            return FromJson<contract>("ContractCreateDomain.Endpoint.Tests", filename);
        }

        public static T FromJson<T>(string nameSpace, string resourceName)
        {
            using (Stream stream = Assembly.GetCallingAssembly().GetManifestResourceStream($"{nameSpace}.{resourceName}"))
            using (StreamReader streamReader = new StreamReader(stream))
            {
                return JsonConvert.DeserializeObject<T>(streamReader.ReadToEnd());
            }
        }
    }
}
