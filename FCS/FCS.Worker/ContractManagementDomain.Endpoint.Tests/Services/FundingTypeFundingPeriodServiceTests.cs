namespace ContractManagementDomain.Endpoint.Tests.Services
{
    using System;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using Endpoint.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractApproval;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Services;

    [TestClass]
    public class FundingTypeFundingPeriodServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void FundingTypeFundingPeriodService_ShouldReturnTrueWhenCurrentDateIsAfterActivityClose()
        {
            // arrange
            Mock<IFundingTypeFundingPeriodQueryRepository> repositoryMock = new Mock<IFundingTypeFundingPeriodQueryRepository>();
            repositoryMock.Setup(r => r.Get(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(new FundingTypeFundingPeriod
                {
                    ContractingActivityCloseDate = new DateTime(2017, 7, 17, 0, 0, 0, DateTimeKind.Utc)
                });

            Mock<IDateProvider> dateProvider = new Mock<IDateProvider>();
            dateProvider.Setup(dp => dp.GetDate(It.IsAny<ConnectionInfo>()))
                .Returns(new DateTime(2017, 7, 18, 0, 0, 0, DateTimeKind.Utc));

            FundingTypeFundingPeriodService service = new FundingTypeFundingPeriodService(repositoryMock.Object, dateProvider.Object);

            // act
            bool isActivityClosed = service.IsProcessDateAfterFundingTypeContractingActivityCloseDate(
                It.IsAny<string>(), It.IsAny<string>(), null);

            // assert
            Assert.AreEqual(true, isActivityClosed);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingTypeFundingPeriodService_IsProcessDateAfterFundingTypeContractingActivityCloseDate_ShouldReturnFalseWhenCurrentDateIsEqualToActivityClose()
        {
            // arrange
            Mock<IFundingTypeFundingPeriodQueryRepository> repositoryMock = new Mock<IFundingTypeFundingPeriodQueryRepository>();
            repositoryMock.Setup(r => r.Get(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(new FundingTypeFundingPeriod
                {
                    ContractingActivityCloseDate = new DateTime(2017, 7, 17, 0, 0, 0, DateTimeKind.Utc)
                });

            Mock<IDateProvider> dateProvider = new Mock<IDateProvider>();
            dateProvider.Setup(dp => dp.GetDate(It.IsAny<ConnectionInfo>()))
                .Returns(new DateTime(2017, 7, 17, 12, 0, 0, DateTimeKind.Utc));

            FundingTypeFundingPeriodService service = new FundingTypeFundingPeriodService(repositoryMock.Object, dateProvider.Object);

            // act
            bool isActivityClosed = service.IsProcessDateAfterFundingTypeContractingActivityCloseDate(
                It.IsAny<string>(), It.IsAny<string>(), null);

            // assert
            Assert.AreEqual(false, isActivityClosed);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingTypeFundingPeriodService_IsProcessDateAfterFundingTypeContractingActivityCloseDate_ShouldReturnFalseWhenCurrentDateIsGreaterButStillTheSameDayToActivityClose()
        {
            // arrange
            Mock<IFundingTypeFundingPeriodQueryRepository> repositoryMock = new Mock<IFundingTypeFundingPeriodQueryRepository>();
            repositoryMock.Setup(r => r.Get(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(new FundingTypeFundingPeriod
                {
                    ContractingActivityCloseDate = new DateTime(2017, 7, 17, 0, 0, 0, DateTimeKind.Utc)
                });

            Mock<IDateProvider> dateProvider = new Mock<IDateProvider>();
            dateProvider.Setup(dp => dp.GetDate(It.IsAny<ConnectionInfo>()))
                .Returns(new DateTime(2017, 7, 17, 12, 0, 0, DateTimeKind.Utc));

            FundingTypeFundingPeriodService service = new FundingTypeFundingPeriodService(repositoryMock.Object, dateProvider.Object);

            // act
            bool isActivityClosed = service.IsProcessDateAfterFundingTypeContractingActivityCloseDate(
                It.IsAny<string>(), It.IsAny<string>(), null);

            // assert
            Assert.AreEqual(false, isActivityClosed);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingTypeFundingPeriodService_GetApprovalType_ShouldReturnElectronicApprovalTypeWhenColumnHoldsElectronic()
        {
            // arrange
            Mock<IFundingTypeFundingPeriodQueryRepository> repositoryMock = new Mock<IFundingTypeFundingPeriodQueryRepository>();
            repositoryMock.Setup(r => r.Get(It.IsAny<string>(), It.IsAny<string>()))
                .Returns(new FundingTypeFundingPeriod
                {
                    ApprovalType = "Electronic"
                });

            Mock<IDateProvider> dateProvider = new Mock<IDateProvider>();
            dateProvider.Setup(dp => dp.GetDate(It.IsAny<ConnectionInfo>()))
                .Returns(new DateTime(2017, 7, 17, 12, 0, 0, DateTimeKind.Utc));

            FundingTypeFundingPeriodService service = new FundingTypeFundingPeriodService(repositoryMock.Object, dateProvider.Object);

            // act
            ContractApprovalType approvalType = service.GetApprovalType(
                It.IsAny<string>(), It.IsAny<string>());

            // assert
            Assert.AreEqual(ContractApprovalType.Electronic, approvalType);
        }
    }
}
