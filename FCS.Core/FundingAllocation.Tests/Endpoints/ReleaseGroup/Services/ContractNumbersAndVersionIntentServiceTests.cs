namespace FundingAllocation.Tests.Endpoints.ReleaseGroup.Services
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using FluentAssertions;
    using Moq;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using FundingAllocation.Dto;
    using FundingAllocation.Endpoints.ReleaseGroup.Services;
    using LanguageExt;
    using FundingAllocation.Endpoints.ReleaseGroup.Repositories;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;

    [TestClass]
    public class ContractNumbersAndVersionIntentServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractNumbersAndVersionIntentService_GetContractNumberReferencesAndVersion_ShouldReturnContractReferencesAndVersionFromCrmContractInfoWhenIntentIsRevisedNew()
        {
            // arrange 
            const string contractNumber = "contractNumber";
            const string masterContractNumber = "masterContractNumber";
            const int contractVersionNumber = 600;

            Option<CrmContractInfo> contractInfoOption = new CrmContractInfo(contractNumber,
                contractVersionNumber,
                -999,
                -888,
                string.Empty,
                masterContractNumber, 
                "Variation",
                null,
                1);

            var contractNumbersAndVersionIntentService = new ContractNumbersAndVersionIntentService(
                Mock.Of<IContractNumberQueryRepository>(),
                Mock.Of<IFundingTypeRepository>());

            // act
            var (contractNumberReference, masterContractNumberReference, version) =
                contractNumbersAndVersionIntentService.GetContractNumberReferencesAndVersion(
                    ContractIntent.RevisedNew, contractInfoOption, string.Empty).Result;

            // assert
            Assert.AreEqual(contractNumber, contractNumberReference, "ContractNumber was not set correctly");
            Assert.AreEqual(masterContractNumber, masterContractNumberReference, "MasterContractNumber was not set correctly");
            Assert.AreEqual(contractVersionNumber + 1, version, "VersionNumber was not set correctly");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractNumbersAndVersionIntentService_GetContractNumberReferencesAndVersion_ShouldReturnMasterContractNumberFromCrmContractInfoWhenIntentIsNewAmendment()
        {
            // arrange 
            const string contractNumber = "contractNumber";
            const string masterContractNumber = "masterContractNumber";
            const int contractVersionNumber = 600;
            const int contractNumberNumberPart = 19;

            Option<CrmContractInfo> contractInfoOption = new CrmContractInfo(contractNumber,
                contractVersionNumber,
                -999,
                -888,
                string.Empty,
                masterContractNumber,
                "Variation",
                null,
                1);

            Mock<IContractNumberQueryRepository> contractNumberQueryRepositoryMock = new Mock<IContractNumberQueryRepository>();
            contractNumberQueryRepositoryMock.Setup(r => r.GetNextContractNumberForFundingType(It.IsAny<string>()))
                .ReturnsAsync(contractNumberNumberPart);

            var contractNumbersAndVersionIntentService = new ContractNumbersAndVersionIntentService(
                contractNumberQueryRepositoryMock.Object,
                Mock.Of<IFundingTypeRepository>());

            // act
            var (contractNumberReference, masterContractNumberReference, version) =
                contractNumbersAndVersionIntentService.GetContractNumberReferencesAndVersion(
                    ContractIntent.NewAmendment, contractInfoOption, string.Empty).Result;

            // assert
            contractNumberReference.Contains(contractNumberNumberPart.ToString()).Should().BeTrue();
            masterContractNumberReference.Should().Be(masterContractNumber);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractNumbersAndVersionIntentService_GetContractNumberReferencesAndVersion_ShouldReturnContractReferencesFromRepositoriesWhenIntentIsNotRevisedNew()
        {
            const int contractNumber = 1000;
            const int masterContractNumber = 2000;
            const string contractNumberPrefix = "contractNumberPrefix";
            const int contractVersionNumber = 1;

            Mock<IContractNumberQueryRepository> contractNumberQueryRepositoryMock = new Mock<IContractNumberQueryRepository>();
            contractNumberQueryRepositoryMock.Setup(r => r.GetNextContractNumberForFundingType(It.IsAny<string>()))
                .ReturnsAsync(contractNumber);
            contractNumberQueryRepositoryMock.Setup(r => r.GetNextMasterContractNumber())
                .ReturnsAsync(masterContractNumber);

            Mock<IFundingTypeRepository> fundingTypeRepositoryMock = new Mock<IFundingTypeRepository>();
            fundingTypeRepositoryMock.Setup(r => r.GetContractNumberPrefix(It.IsAny<string>()))
                .ReturnsAsync(contractNumberPrefix);

            var contractNumbersAndVersionIntentService = new ContractNumbersAndVersionIntentService(
                contractNumberQueryRepositoryMock.Object, fundingTypeRepositoryMock.Object);

            // act
            var (contractNumberReference, masterContractNumberReference, version) =
                contractNumbersAndVersionIntentService.GetContractNumberReferencesAndVersion(
                    ContractIntent.New, null, string.Empty).Result;

            // assert
            Assert.AreEqual($"{contractNumberPrefix}-{contractNumber}", contractNumberReference, "ContractNumber was not set correctly");
            Assert.AreEqual($"DFE-{masterContractNumber}", masterContractNumberReference, "MasterContractNumber was not set correctly");
            Assert.AreEqual(contractVersionNumber, version, "VersionNumber was not set correctly");
        }
    }
}