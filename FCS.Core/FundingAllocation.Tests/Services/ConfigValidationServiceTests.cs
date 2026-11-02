namespace FundingAllocation.Tests.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using FluentAssertions;
    using FundingAllocation.Dto;
    using FundingAllocation.Repositories;
    using FundingAllocation.Services;
    using static LanguageExt.Prelude;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;

    [TestClass]
    public class ConfigValidationServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void GetAwaitingFundingAllocationConfigFilterResult_GetAwaitingConfigFilterResult_ShouldFailFundingTypePeriodFSPGroupWhen_When_AllocationFundingStreamConfigNotPresent()
        {
            // arrange
            Mock<IAllocationFundingStreamConfigRepository> allocationFundingStreamConfigRepMock = new Mock<IAllocationFundingStreamConfigRepository>();
            allocationFundingStreamConfigRepMock.Setup(r =>
                    r.TryGetAllocationFundingStreamConfig(It.IsAny<string>(), It.IsAny<string>()))
                .ReturnsAsync(None);
            ConfigValidationService validationService = new ConfigValidationService(Mock.Of<IProviderCategoryRepository>(),
                allocationFundingStreamConfigRepMock.Object,
                Mock.Of<IContractTypeRepository>(), Mock.Of<IAllocationLineConfigRepository>());
            List<FundingAllocationValidationInput> fundingIdsWithMappingInput =
                new List<FundingAllocationValidationInput>
                {
                    new FundingAllocationValidationInput("SomeId",
                        new ContractItemsMappingInput(string.Empty, string.Empty, string.Empty, string.Empty,
                            string.Empty), new List<string>())
                };

            // act
            var validationResult = validationService.GetAwaitingConfigFilterResult(fundingIdsWithMappingInput).Result;

            // assert
            validationResult.AwaitingFundingAllocationConfigFundingIds.Count.Should().Be(1);
            validationResult.AwaitingFundingAllocationConfigFundingIds.Single().Should().Be(fundingIdsWithMappingInput.First().FundingId);
            validationResult.AwaitingContractTypeConfigFundingIds.Count.Should().Be(0);
            validationResult.PassedValidationFundingIds.Count.Should().Be(0);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetAwaitingFundingAllocationConfigFilterResult_GetAwaitingConfigFilterResult_ShouldFailContractTypeWhen_When_ProviderCategoryNotPresent()
        {
            // arrange
            Mock<IProviderCategoryRepository> providerCategoryRepositoryMock = new Mock<IProviderCategoryRepository>();
            providerCategoryRepositoryMock.Setup(r =>
                    r.TryGetProviderCategoryExceptionOrDefault(string.Empty, string.Empty, string.Empty, string.Empty,
                        string.Empty))
                .ReturnsAsync(None);

            Mock<IAllocationFundingStreamConfigRepository> allocationFundingStreamConfigRepMock = new Mock<IAllocationFundingStreamConfigRepository>();
            allocationFundingStreamConfigRepMock.Setup(r =>
                    r.TryGetAllocationFundingStreamConfig(It.IsAny<string>(), It.IsAny<string>()))
                .ReturnsAsync(Some((string.Empty, string.Empty, string.Empty)));

            ConfigValidationService validationService = new ConfigValidationService(
                providerCategoryRepositoryMock.Object,
                allocationFundingStreamConfigRepMock.Object,
                Mock.Of<IContractTypeRepository>(), Mock.Of<IAllocationLineConfigRepository>());

            List<FundingAllocationValidationInput> fundingIdsWithMappingInput =
                new List<FundingAllocationValidationInput>
                {
                    new FundingAllocationValidationInput("SomeId",
                        new ContractItemsMappingInput(string.Empty, string.Empty, string.Empty, string.Empty,
                            string.Empty), new List<string>())
                };

            // act
            var validationResult = validationService.GetAwaitingConfigFilterResult(fundingIdsWithMappingInput).Result;

            // assert
            validationResult.AwaitingFundingAllocationConfigFundingIds.Count.Should().Be(0);
            validationResult.AwaitingContractTypeConfigFundingIds.Count.Should().Be(1);
            validationResult.AwaitingContractTypeConfigFundingIds.Single().Should()
                .Be(fundingIdsWithMappingInput.First().FundingId);
            validationResult.PassedValidationFundingIds.Count.Should().Be(0);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetAwaitingFundingAllocationConfigFilterResult_GetAwaitingConfigFilterResult_ShouldFailContractType_When_ContractTypeNotPresent()
        {
            // arrange
            Mock<IProviderCategoryRepository> providerCategoryRepositoryMock = new Mock<IProviderCategoryRepository>();
            providerCategoryRepositoryMock.Setup(r =>
                    r.TryGetProviderCategoryExceptionOrDefault(string.Empty, string.Empty, string.Empty, string.Empty,
                        string.Empty))
                .ReturnsAsync(Some("Provider Category"));

            Mock<IAllocationFundingStreamConfigRepository> allocationFundingStreamConfigRepMock = new Mock<IAllocationFundingStreamConfigRepository>();
            allocationFundingStreamConfigRepMock.Setup(r =>
                    r.TryGetAllocationFundingStreamConfig(It.IsAny<string>(), It.IsAny<string>()))
                .ReturnsAsync(Some((string.Empty, string.Empty, string.Empty)));

            Mock<IContractTypeRepository> contractTypeRepMock = new Mock<IContractTypeRepository>();
            contractTypeRepMock.Setup(r =>
                    r.TryGetContractType(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()))
                .ReturnsAsync(None);

            ConfigValidationService validationService = new ConfigValidationService(
                providerCategoryRepositoryMock.Object,
                allocationFundingStreamConfigRepMock.Object,
                contractTypeRepMock.Object,
                Mock.Of<IAllocationLineConfigRepository>());

            List<FundingAllocationValidationInput> fundingIdsWithMappingInput =
                new List<FundingAllocationValidationInput>
                {
                    new FundingAllocationValidationInput("SomeId",
                        new ContractItemsMappingInput(string.Empty, string.Empty, string.Empty, string.Empty,
                            string.Empty), new List<string>())
                };

            // act
            var validationResult = validationService.GetAwaitingConfigFilterResult(fundingIdsWithMappingInput).Result;

            // assert
            validationResult.AwaitingFundingAllocationConfigFundingIds.Count.Should().Be(0);
            validationResult.AwaitingContractTypeConfigFundingIds.Count.Should().Be(1);
            validationResult.AwaitingContractTypeConfigFundingIds.Single().Should()
                .Be(fundingIdsWithMappingInput.First().FundingId);
            validationResult.PassedValidationFundingIds.Count.Should().Be(0);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetAwaitingFundingAllocationConfigFilterResult_GetAwaitingConfigFilterResult_ShouldPass_When_ConfigPresent()
        {
            // arrange
            const string providerCategory = "Provider Category";
            Mock<IProviderCategoryRepository> providerCategoryRepositoryMock = new Mock<IProviderCategoryRepository>();
            providerCategoryRepositoryMock.Setup(r =>
                    r.TryGetProviderCategoryExceptionOrDefault(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(),
                        It.IsAny<string>()))
                .ReturnsAsync(providerCategory);

            Mock<IAllocationFundingStreamConfigRepository> allocationFundingStreamConfigRepMock = new Mock<IAllocationFundingStreamConfigRepository>();
            allocationFundingStreamConfigRepMock.Setup(r =>
                    r.TryGetAllocationFundingStreamConfig(It.IsAny<string>(), It.IsAny<string>()))
                .ReturnsAsync((string.Empty, string.Empty, string.Empty));

            Mock<IContractTypeRepository> contractTypeRepMock = new Mock<IContractTypeRepository>();
            contractTypeRepMock.Setup(r =>
                    r.TryGetContractType(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()))
                .ReturnsAsync("ContractType");
            
            Mock<IAllocationLineConfigRepository> allocationLineConfigRepMock = new Mock<IAllocationLineConfigRepository>();
            allocationLineConfigRepMock.Setup(r =>
                    r.GetAllocationLineConfigs(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()))
                .ReturnsAsync(new List<AllocationLineDeliverableInfo>
                {
                    new AllocationLineDeliverableInfo(It.IsAny<string>(), 1, providerCategory, It.IsAny<string>(), 0,
                        It.IsAny<string>(), It.IsAny<string>())
                });

            ConfigValidationService validationService = new ConfigValidationService(
                providerCategoryRepositoryMock.Object,
                allocationFundingStreamConfigRepMock.Object,
                contractTypeRepMock.Object,
                allocationLineConfigRepMock.Object);

            List<FundingAllocationValidationInput> fundingIdsWithMappingInput =
                new List<FundingAllocationValidationInput>
                {
                    new FundingAllocationValidationInput("SomeId",
                        new ContractItemsMappingInput(string.Empty, string.Empty, string.Empty, string.Empty,
                            string.Empty), new List<string>{"1619-001"})
                };

            // act
            var validationResult = validationService.GetAwaitingConfigFilterResult(fundingIdsWithMappingInput).Result;

            // assert
            validationResult.AwaitingFundingAllocationConfigFundingIds.Count.Should().Be(0);
            validationResult.AwaitingContractTypeConfigFundingIds.Count.Should().Be(0);
            validationResult.PassedValidationFundingIds.Count.Should().Be(1);
            validationResult.PassedValidationFundingIds.Single().Should().Be(fundingIdsWithMappingInput.Single().FundingId);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetAwaitingFundingAllocationConfigFilterResult_GetAwaitingConfigFilterResult_ShouldPassProcessMoreThanOne()
        {
            // arrange
            const string providerCategory = "Provider Category";
            const string allocationFundingStreamCode = "1619";
            const string allocationPeriodId = "AS-2021";
            const string allocationFundingStreamCodeNotPresent = "1619-Test";
            const string allocationPeriodIdNotPresent = "AS-2021- Test";
            const string fundingIdWithAllocationConfig = "FundingId1";
            const string fundingIdWithoutAllocationConfig = "FundingId2";
            Mock<IProviderCategoryRepository> providerCategoryRepositoryMock = new Mock<IProviderCategoryRepository>();
            providerCategoryRepositoryMock.Setup(r =>
                    r.TryGetProviderCategoryExceptionOrDefault(string.Empty, string.Empty, string.Empty, string.Empty,
                        string.Empty))
                .ReturnsAsync(providerCategory);

            Mock<IAllocationFundingStreamConfigRepository> allocationFundingStreamConfigRepMock = new Mock<IAllocationFundingStreamConfigRepository>();
            allocationFundingStreamConfigRepMock.Setup(r =>
                    r.TryGetAllocationFundingStreamConfig(allocationFundingStreamCode, allocationPeriodId))
                .ReturnsAsync((string.Empty, string.Empty, string.Empty));
            allocationFundingStreamConfigRepMock.Setup(r =>
                    r.TryGetAllocationFundingStreamConfig(allocationFundingStreamCodeNotPresent, allocationPeriodIdNotPresent))
                .ReturnsAsync(None);

            Mock<IContractTypeRepository> contractTypeRepMock = new Mock<IContractTypeRepository>();
            contractTypeRepMock.Setup(r =>
                    r.TryGetContractType(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()))
                .ReturnsAsync("ContractType");

            Mock<IAllocationLineConfigRepository> allocationLineConfigRepMock = new Mock<IAllocationLineConfigRepository>();
            allocationLineConfigRepMock.Setup(r =>
                    r.GetAllocationLineConfigs(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()))
                .ReturnsAsync(new List<AllocationLineDeliverableInfo>
                {
                    new AllocationLineDeliverableInfo(It.IsAny<string>(), 1, providerCategory, It.IsAny<string>(), 0,
                        It.IsAny<string>(), It.IsAny<string>())
                });

            ConfigValidationService validationService = new ConfigValidationService(
                providerCategoryRepositoryMock.Object,
                allocationFundingStreamConfigRepMock.Object,
                contractTypeRepMock.Object,
                allocationLineConfigRepMock.Object);

            List<FundingAllocationValidationInput> fundingIdsWithMappingInput =
                new List<FundingAllocationValidationInput>
                {
                    new FundingAllocationValidationInput(fundingIdWithAllocationConfig,
                        new ContractItemsMappingInput(allocationFundingStreamCode, allocationPeriodId, string.Empty, string.Empty,
                            string.Empty), new List<string>{"1619-001"}),

                    new FundingAllocationValidationInput(fundingIdWithoutAllocationConfig,
                        new ContractItemsMappingInput(allocationFundingStreamCodeNotPresent, allocationPeriodIdNotPresent, string.Empty, string.Empty,
                            string.Empty), new List<string>{"1619-002"}),
                };

            // act
            var validationResult = validationService.GetAwaitingConfigFilterResult(fundingIdsWithMappingInput).Result;

            // assert
            validationResult.AwaitingFundingAllocationConfigFundingIds.Count.Should().Be(1);
            validationResult.AwaitingFundingAllocationConfigFundingIds.Single().Should().Be(fundingIdWithoutAllocationConfig);
            validationResult.AwaitingContractTypeConfigFundingIds.Count.Should().Be(0);
            validationResult.PassedValidationFundingIds.Count.Should().Be(1);
            validationResult.PassedValidationFundingIds.Single().Should().Be(fundingIdWithAllocationConfig);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetAwaitingFundingAllocationConfigFilterResult_GetAwaitingConfigFilterResult_ShouldFailWhenLineConfigNotPresent()
        {
            // arrange
            const string allocationFundingStreamCode = "1619";
            const string allocationPeriodId = "AS-2021";
            const string allocationFundingStreamCodeNotPresent = "1619-Test";
            const string allocationPeriodIdNotPresent = "AS-2021- Test";
            const string fundingIdWithAllocationConfig = "FundingId1";
            const string fundingIdWithoutAllocationConfig = "FundingId2";
            Mock<IProviderCategoryRepository> providerCategoryRepositoryMock = new Mock<IProviderCategoryRepository>();
            providerCategoryRepositoryMock.Setup(r =>
                    r.TryGetProviderCategoryExceptionOrDefault(string.Empty, string.Empty, string.Empty, string.Empty,
                        string.Empty))
                .ReturnsAsync("Provider Category");

            Mock<IAllocationFundingStreamConfigRepository> allocationFundingStreamConfigRepMock = new Mock<IAllocationFundingStreamConfigRepository>();
            allocationFundingStreamConfigRepMock.Setup(r =>
                    r.TryGetAllocationFundingStreamConfig(allocationFundingStreamCode, allocationPeriodId))
                .ReturnsAsync((string.Empty, string.Empty, string.Empty));
            allocationFundingStreamConfigRepMock.Setup(r =>
                    r.TryGetAllocationFundingStreamConfig(allocationFundingStreamCodeNotPresent, allocationPeriodIdNotPresent))
                .ReturnsAsync((string.Empty, string.Empty, string.Empty));

            Mock<IContractTypeRepository> contractTypeRepMock = new Mock<IContractTypeRepository>();
            contractTypeRepMock.Setup(r =>
                    r.TryGetContractType(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()))
                .ReturnsAsync("ContractType");

            Mock<IAllocationLineConfigRepository> allocationLineConfigRepMock = new Mock<IAllocationLineConfigRepository>();
            allocationLineConfigRepMock.Setup(r =>
                    r.GetAllocationLineConfigs(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()))
                .ReturnsAsync(new List<AllocationLineDeliverableInfo>());
            
            ConfigValidationService validationService = new ConfigValidationService(
                providerCategoryRepositoryMock.Object,
                allocationFundingStreamConfigRepMock.Object,
                contractTypeRepMock.Object,
                allocationLineConfigRepMock.Object);

            List<FundingAllocationValidationInput> fundingIdsWithMappingInput =
                new List<FundingAllocationValidationInput>
                {
                    new FundingAllocationValidationInput(fundingIdWithAllocationConfig,
                        new ContractItemsMappingInput(allocationFundingStreamCode, allocationPeriodId, string.Empty, string.Empty,
                            string.Empty), new List<string>{"1619-001"}),

                    new FundingAllocationValidationInput(fundingIdWithoutAllocationConfig,
                        new ContractItemsMappingInput(allocationFundingStreamCodeNotPresent, allocationPeriodIdNotPresent, string.Empty, string.Empty,
                            string.Empty), new List<string>{"1619-002"}),
                };

            // act
            var validationResult = validationService.GetAwaitingConfigFilterResult(fundingIdsWithMappingInput).Result;

            // assert
            validationResult.AwaitingFundingAllocationConfigFundingIds.Count.Should().Be(0);
            validationResult.AwaitingContractTypeConfigFundingIds.Count.Should().Be(0);
            validationResult.AwaitingFundingLineCodeFundingIds.Count.Should().Be(2);
            validationResult.PassedValidationFundingIds.Count.Should().Be(0);
        }
    }
}
