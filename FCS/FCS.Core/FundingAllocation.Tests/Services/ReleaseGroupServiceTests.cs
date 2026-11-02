namespace FundingAllocation.Tests.Services
{
    using System;
    using System.Threading.Tasks;
    using FundingAllocation.Dto;
    using FundingAllocation.Endpoints.CreateFundingAllocationInCrm;
    using FundingAllocation.Repositories;
    using FundingAllocation.Services;
    using LanguageExt;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;

    [TestClass]
    public class ReleaseGroupServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ReleaseGroupService_ShouldNotCreateIfAlreadyHaveReleaseGroup()
        {
            // arrange
            Mock<FundingAllocation.Repositories.IReleaseGroupRepository> releaseGrpRepMock = new Mock<FundingAllocation.Repositories.IReleaseGroupRepository>();
            releaseGrpRepMock.Setup(r => r.GetAwaitingReleaseGroup(
                    It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()))
                .ReturnsAsync(new ReleaseGroupId(0, Guid.Empty));
            Mock<ICrmReleaseGroupRepository> crmReleaseGrpRepMock = new Mock<ICrmReleaseGroupRepository>();

            ReleaseGroupService service = new ReleaseGroupService(releaseGrpRepMock.Object, crmReleaseGrpRepMock.Object);
            
            // act
            service.GetOrCreateReleaseGroup(string.Empty, string.Empty, string.Empty, string.Empty, null).Wait();

            // assert
            crmReleaseGrpRepMock.Verify(r => r.CreateReleaseGroup(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()),
                Times.Never, "Crm CreateReleaseGroup should not be called");
            releaseGrpRepMock.Verify(r => r.CreateReleaseGroup(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<Guid>(), It.IsAny<string>()),
                Times.Never, "PaaS CreateReleaseGroup should not be called");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ReleaseGroupService_ShouldCreateReleaseGroupIfNotAlreadyThere()
        {
            // arrange
            Mock<FundingAllocation.Repositories.IReleaseGroupRepository> releaseGrpRepMock = new Mock<FundingAllocation.Repositories.IReleaseGroupRepository>();
            releaseGrpRepMock.Setup(r => r.GetAwaitingReleaseGroup(
                    It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()))
                .ReturnsAsync(new Option<ReleaseGroupId>());
            Mock<ICrmReleaseGroupRepository> crmReleaseGrpRepMock = new Mock<ICrmReleaseGroupRepository>();

            ReleaseGroupService service = new ReleaseGroupService(releaseGrpRepMock.Object, crmReleaseGrpRepMock.Object);

            // act
            service.GetOrCreateReleaseGroup(string.Empty, string.Empty, string.Empty, string.Empty, () => Task.FromResult(new CrmFundingAllocationFks
                (string.Empty, string.Empty, string.Empty, string.Empty, string.Empty))).Wait();

            // assert
            crmReleaseGrpRepMock.Verify(r => r.CreateReleaseGroup(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()),
                Times.Once, "Crm CreateReleaseGroup should be called");
            releaseGrpRepMock.Verify(r => r.CreateReleaseGroup(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<Guid>(), It.IsAny<string>()),
                Times.Once, "PaaS CreateReleaseGroup should be called");
        }
    }
}
