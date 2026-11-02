namespace ContractCreateDomain.Endpoint.Tests.Services
{
    using ContractCreateDomain.Endpoint.Infrastructure;
    using ContractManagement.DataStore.Model;
    using Endpoint.Services;
    using Endpoint.Services.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class SiblingContractCheckServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void SiblingContractCheckService_HasSiblingContractWithDraftStatus_ShouldReturnTrue_WhenFundingTypeFundingPeriodIsIncludeAllContractsOnSummaryOfFundingAndThereAreSiblingDraftContracts()
        {
            // arrange
            Mock<IFundingTypeFundingPeriodQueryRepository> fundingTypeFundingPeriodQueryRepositoryMock = new Mock<IFundingTypeFundingPeriodQueryRepository>();
            fundingTypeFundingPeriodQueryRepositoryMock
                .Setup(m => m.Get(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(new FundingTypeFundingPeriod { IncludeAllContractsOnSummaryOfFunding = true });

            Mock<ICrmContractQueryRepository> crmContractQueryRepositoryMock = new Mock<ICrmContractQueryRepository>();
            crmContractQueryRepositoryMock
                .Setup(m => m.HasSiblingContractWithDraftStatus(It.IsAny<string>(), It.IsAny<string>()))
                .Returns(true);

            SiblingContractCheckService siblingContractCheckService = new SiblingContractCheckService(
                fundingTypeFundingPeriodQueryRepositoryMock.Object,
                crmContractQueryRepositoryMock.Object);

            // act
            var hasSiblingContractWithDraftStatusAssert = siblingContractCheckService.HasSiblingContractWithDraftStatus(
                "masterContractNumber",
                "contractNumber",
                "fundingType",
                "fundingPeriod",
                ConnectionInfo.CreateDefault());

            // assert
            Assert.IsTrue(hasSiblingContractWithDraftStatusAssert, "Incorrectly returned false");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void SiblingContractCheckService_HasSiblingContractWithDraftStatus_ShouldReturnFalse_WhenFundingTypeFundingPeriodIsIncludeAllContractsOnSummaryOfFundingAndThereAreNoSiblingDraftContracts()
        {
            // arrange
            Mock<IFundingTypeFundingPeriodQueryRepository> fundingTypeFundingPeriodQueryRepositoryMock = new Mock<IFundingTypeFundingPeriodQueryRepository>();
            fundingTypeFundingPeriodQueryRepositoryMock
                .Setup(m => m.Get(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(new FundingTypeFundingPeriod { IncludeAllContractsOnSummaryOfFunding = true });

            Mock<ICrmContractQueryRepository> crmContractQueryRepositoryMock = new Mock<ICrmContractQueryRepository>();
            crmContractQueryRepositoryMock
                .Setup(m => m.HasSiblingContractWithDraftStatus(It.IsAny<string>(), It.IsAny<string>()))
                .Returns(false);

            SiblingContractCheckService siblingContractCheckService = new SiblingContractCheckService(
                fundingTypeFundingPeriodQueryRepositoryMock.Object,
                crmContractQueryRepositoryMock.Object);

            // act
            var hasSiblingContractWithDraftStatusAssert = siblingContractCheckService.HasSiblingContractWithDraftStatus(
                "masterContractNumber",
                "contractNumber",
                "fundingType",
                "fundingPeriod",
                ConnectionInfo.CreateDefault());

            // assert
            Assert.IsFalse(hasSiblingContractWithDraftStatusAssert, "Incorrectly returned true");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void SiblingContractCheckService_HasSiblingContractWithDraftStatus_ShouldReturnFalse_WhenNotFundingTypeFundingPeriodIsIncludeAllContractsOnSummaryOfFunding()
        {
            // arrange
            Mock<IFundingTypeFundingPeriodQueryRepository> fundingTypeFundingPeriodQueryRepositoryMock = new Mock<IFundingTypeFundingPeriodQueryRepository>();
            fundingTypeFundingPeriodQueryRepositoryMock
                .Setup(m => m.Get(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(new FundingTypeFundingPeriod { IncludeAllContractsOnSummaryOfFunding = false });


            SiblingContractCheckService siblingContractCheckService = new SiblingContractCheckService(
                fundingTypeFundingPeriodQueryRepositoryMock.Object,
                Mock.Of<ICrmContractQueryRepository>());

            // act
            var hasSiblingContractWithDraftStatusAssert = siblingContractCheckService.HasSiblingContractWithDraftStatus(
                "masterContractNumber",
                "contractNumber",
                "fundingType",
                "fundingPeriod",
                ConnectionInfo.CreateDefault());

            // assert
            Assert.IsFalse(hasSiblingContractWithDraftStatusAssert, "Incorrectly returned true");
        }
    }
}