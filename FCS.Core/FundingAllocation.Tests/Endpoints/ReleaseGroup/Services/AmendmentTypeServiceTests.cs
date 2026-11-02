namespace FundingAllocation.Tests.Endpoints.ReleaseGroup.Services
{
    using FluentAssertions;
    using FundingAllocation.Endpoints.ReleaseGroup.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using System.Collections.Generic;
    using DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class AmendmentTypeServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void AmendmentTypeService_ShouldReturnVariationWhenAllAmendmentsRequireSigning()
        {
            // arrange
            var mockAmendmentTypeServiceChecks = new Mock<IAmendmentTypeServiceChecks>();
            mockAmendmentTypeServiceChecks.Setup(r => r.DoAllAmendmentsRequireSigning(
                It.IsAny<string>(), It.IsAny<string>())).ReturnsAsync(true);

            var amendmentTypeService = new AmendmentTypeService(mockAmendmentTypeServiceChecks.Object, Mock.Of<ILogger>());
            var getAmendmentTypeInput = new GetAmendmentTypeInput(-1, string.Empty, string.Empty, null, null, null, ContractIntent.UpdateDraftAmendment, string.Empty);

            // act
            var amendmentType = amendmentTypeService.GetAmendmentType(getAmendmentTypeInput).Result;
            
            // assert
            amendmentType.Should().Be("Variation");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendmentTypeService_ShouldReturnVariationWhenIntentIsUpdateDraftAmendmentAndLatestVersionIsVariation()
        {
            // arrange
            var mockAmendmentTypeServiceChecks = new Mock<IAmendmentTypeServiceChecks>();
            mockAmendmentTypeServiceChecks.Setup(r => r.DoAllAmendmentsRequireSigning(
                It.IsAny<string>(), It.IsAny<string>())).ReturnsAsync(false);
            mockAmendmentTypeServiceChecks.Setup(r => r.IsUpdateDraftAmendmentAndLatestVersionIsVariation(
                It.IsAny<string>(), It.IsAny<ContractIntent>())).ReturnsAsync(true);

            var amendmentTypeService = new AmendmentTypeService(mockAmendmentTypeServiceChecks.Object, Mock.Of<ILogger>());
            var getAmendmentTypeInput = new GetAmendmentTypeInput(-1, string.Empty, string.Empty, null, null, null, ContractIntent.Amendment, string.Empty);

            // act
            var amendmentType = amendmentTypeService.GetAmendmentType(getAmendmentTypeInput).Result;

            // assert
            amendmentType.Should().Be("Variation");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendmentTypeService_ShouldReturnVariationWhenThereAreAllocationsInUpdateContractThatAreNotInLastApprovedContract()
        {
            // arrange
            var mockAmendmentTypeServiceChecks = new Mock<IAmendmentTypeServiceChecks>();
            mockAmendmentTypeServiceChecks.Setup(r => r.DoAllAmendmentsRequireSigning(
                It.IsAny<string>(), It.IsAny<string>())).ReturnsAsync(false);
            mockAmendmentTypeServiceChecks.Setup(r => r.IsUpdateDraftAmendmentAndLatestVersionIsVariation(
                It.IsAny<string>(), It.IsAny<ContractIntent>())).ReturnsAsync(false);
            mockAmendmentTypeServiceChecks.Setup(r => r.IsUpdateDraftAmendmentAndAtLeastOneContractAllocationNotInLastApprovedContract(
                It.IsAny<ContractIntent>(),
                It.IsAny<IReadOnlyCollection<FundingAllocation>>(), 
                It.IsAny<IReadOnlyCollection<FundingAllocation>>())).ReturnsAsync(true);

            var amendmentTypeService = new AmendmentTypeService(mockAmendmentTypeServiceChecks.Object, Mock.Of<ILogger>());
            var getAmendmentTypeInput = new GetAmendmentTypeInput(-1, string.Empty, string.Empty, null, null, null, ContractIntent.UpdateDraftAmendment, string.Empty);

            // act
            var amendmentType = amendmentTypeService.GetAmendmentType(getAmendmentTypeInput).Result;

            // assert
            amendmentType.Should().Be("Variation");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendmentTypeService_ShouldReturnVariationWhenFundingAllocationLinesSumValuesAreDifferent()
        {
            // arrange
            var mockAmendmentTypeServiceChecks = new Mock<IAmendmentTypeServiceChecks>();
            mockAmendmentTypeServiceChecks.Setup(r => r.DoAllAmendmentsRequireSigning(
                It.IsAny<string>(), It.IsAny<string>())).ReturnsAsync(false);
            mockAmendmentTypeServiceChecks.Setup(r => r.IsUpdateDraftAmendmentAndLatestVersionIsVariation(
                It.IsAny<string>(), It.IsAny<ContractIntent>())).ReturnsAsync(false);
            mockAmendmentTypeServiceChecks.Setup(r => r.IsUpdateDraftAmendmentAndAtLeastOneContractAllocationNotInLastApprovedContract(
                It.IsAny<ContractIntent>(),
                It.IsAny<IReadOnlyCollection<FundingAllocation>>(),
                It.IsAny<IReadOnlyCollection<FundingAllocation>>())).ReturnsAsync(false);
            mockAmendmentTypeServiceChecks.Setup(r => r.IsAnyUpdateLineGreaterIfMatchingOrPositiveIfNot(
                It.IsAny<IReadOnlyCollection<FundingAllocation>>(),
                It.IsAny<IReadOnlyCollection<FundingAllocation>>())).ReturnsAsync(true);

            var amendmentTypeService = new AmendmentTypeService(mockAmendmentTypeServiceChecks.Object, Mock.Of<ILogger>());
            var getAmendmentTypeInput = new GetAmendmentTypeInput(-1, string.Empty, string.Empty, null, null, null, ContractIntent.UpdateDraftAmendment, string.Empty);

            // act
            var amendmentType = amendmentTypeService.GetAmendmentType(getAmendmentTypeInput).Result;

            // assert
            amendmentType.Should().Be("Variation");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendmentTypeService_ShouldReturnNotificationWhenAllVariationChecksFail()
        {
            // arrange
            var mockAmendmentTypeServiceChecks = new Mock<IAmendmentTypeServiceChecks>();
            mockAmendmentTypeServiceChecks.Setup(r => r.DoAllAmendmentsRequireSigning(
                It.IsAny<string>(), It.IsAny<string>())).ReturnsAsync(false);
            mockAmendmentTypeServiceChecks.Setup(r => r.IsUpdateDraftAmendmentAndLatestVersionIsVariation(
                It.IsAny<string>(), It.IsAny<ContractIntent>())).ReturnsAsync(false);
            mockAmendmentTypeServiceChecks.Setup(r => r.IsUpdateDraftAmendmentAndAtLeastOneContractAllocationNotInLastApprovedContract(
                It.IsAny<ContractIntent>(),
                It.IsAny<IReadOnlyCollection<FundingAllocation>>(),
                It.IsAny<IReadOnlyCollection<FundingAllocation>>())).ReturnsAsync(false);
            mockAmendmentTypeServiceChecks.Setup(r => r.IsAnyUpdateLineGreaterIfMatchingOrPositiveIfNot(
                It.IsAny<IReadOnlyCollection<FundingAllocation>>(),
                It.IsAny<IReadOnlyCollection<FundingAllocation>>())).ReturnsAsync(false);

            var amendmentTypeService = new AmendmentTypeService(mockAmendmentTypeServiceChecks.Object, Mock.Of<ILogger>());
            var getAmendmentTypeInput = new GetAmendmentTypeInput(-1, string.Empty, string.Empty, null, null, null, ContractIntent.UpdateDraftAmendment, string.Empty);

            // act
            var amendmentType = amendmentTypeService.GetAmendmentType(getAmendmentTypeInput).Result;

            // assert
            amendmentType.Should().Be("Notification");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendmentTypeService_GetAmendmentType_ShouldReturnNullWhenNotAnAmendment()
        {
            // arrange
            var mockAmendmentTypeServiceChecks = new Mock<IAmendmentTypeServiceChecks>();
            var amendmentTypeService = new AmendmentTypeService(mockAmendmentTypeServiceChecks.Object, Mock.Of<ILogger>());
            var getAmendmentTypeInput = new GetAmendmentTypeInput(-1, string.Empty, string.Empty, null, null, null, ContractIntent.UpdateDraft, string.Empty);

            // act
            var amendmentType = amendmentTypeService.GetAmendmentType(getAmendmentTypeInput).Result;

            // assert
            amendmentType.Should().Be(null);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendmentTypeService_GetAmendmentType_ForExpiredContracts()
        {
            // arrange
            var mockAmendmentTypeServiceChecks = new Mock<IAmendmentTypeServiceChecks>();
            mockAmendmentTypeServiceChecks.Setup(r => r.DoAmendmentTypeToNotificationOnExpiredContract(
               It.IsAny<string>(), It.IsAny<string>())).ReturnsAsync(true);
            var amendmentTypeService = new AmendmentTypeService(mockAmendmentTypeServiceChecks.Object, Mock.Of<ILogger>());
            var getAmendmentTypeInput = new GetAmendmentTypeInput(-1, "EDSK", "AY2223", null, null, null, ContractIntent.UpdateDraftAmendment, string.Empty);

            // act
            var amendmentType = amendmentTypeService.GetAmendmentType(getAmendmentTypeInput).Result;

            // assert
            amendmentType.Should().Be("Notification");
        }
    }
}
