namespace PerformanceManagementDomain.Tests.ReconciliationCalculationEndpoint.Services
{
    using System.Data;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.Services;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class DeliverableGroupAmountSummaryCreationServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void DeliverableGroupAmountSummaryCreationService_ShouldCreateWithZeroPlannedValue_WhenGroupCodeAndUkprnInProfileTable()
        {
            // arrange
            decimal? profileValue = 10;
            Mock<IClaimReferenceProfileRepository> claimReferenceProfileRepositoryMock = new Mock<IClaimReferenceProfileRepository>();
            claimReferenceProfileRepositoryMock.Setup(r => r.IsProfileFromReferenceData(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(true);
            claimReferenceProfileRepositoryMock.Setup(r => r.GetPlannedValue(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(profileValue);

            DeliverableGroupAmountSummaryCreator creator = new DeliverableGroupAmountSummaryCreator(claimReferenceProfileRepositoryMock.Object);
            var connectionInfoMock = new Mock<ConnectionInfo>(null, Mock.Of<IDbConnection>());

            // act            
            AmountSummary accountSummary = creator.CalculateAndCreateAmountSummary(parentDeliverablePlannedValue: 10,
              totalPlannedValueForGroup: 0,
              totalClaimValueForGroup: 14,
              shouldCapToProfile: true,
              delGroupCode: "X",
              ukprn: 1,
              connectionInfo: connectionInfoMock.Object).Result;

            // assert
            Assert.AreEqual(0, accountSummary.PlannedValue, "The planned value is not correct");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliverableGroupAmountSummaryCreationService_ShouldCapValue_WhenClaimGreaterThanProfileAndCappingRequired()
        {
            // arrange
            decimal? profileValue = 10;
            Mock<IClaimReferenceProfileRepository> claimReferenceProfileRepositoryMock = new Mock<IClaimReferenceProfileRepository>();
            claimReferenceProfileRepositoryMock.Setup(r => r.GetPlannedValue(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(profileValue);

            DeliverableGroupAmountSummaryCreator creator = new DeliverableGroupAmountSummaryCreator(claimReferenceProfileRepositoryMock.Object);
            var connectionInfoMock = new Mock<ConnectionInfo>(null, Mock.Of<IDbConnection>());

            // act            
            AmountSummary accountSummary = creator.CalculateAndCreateAmountSummary(parentDeliverablePlannedValue: 10,
              totalPlannedValueForGroup: 12,
              totalClaimValueForGroup: profileValue + 1,
              shouldCapToProfile: true,
              delGroupCode: "X",
              ukprn: 1,
              connectionInfo: connectionInfoMock.Object).Result;

            // assert
            Assert.AreEqual(profileValue, accountSummary.CappedClaimedValue, "The CappedClaimedValue is not correct");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliverableGroupAmountSummaryCreationService_ShouldCreateCappedClaimedValueTheSameAsClaim_WhenCappingNotRequired()
        {
            // arrange
            decimal? profileValue = 10;
            Mock<IClaimReferenceProfileRepository> claimReferenceProfileRepositoryMock = new Mock<IClaimReferenceProfileRepository>();
            claimReferenceProfileRepositoryMock.Setup(r => r.GetPlannedValue(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(profileValue);

            DeliverableGroupAmountSummaryCreator creator = new DeliverableGroupAmountSummaryCreator(claimReferenceProfileRepositoryMock.Object);
            var connectionInfoMock = new Mock<ConnectionInfo>(null, Mock.Of<IDbConnection>());
            const int totalClaimValueForGroup = 100;

            // act
            AmountSummary accountSummary = creator.CalculateAndCreateAmountSummary(parentDeliverablePlannedValue: 10,
                totalPlannedValueForGroup: 12,
                totalClaimValueForGroup: totalClaimValueForGroup,
                shouldCapToProfile: false,
                delGroupCode: "X",
                ukprn: 1,
                connectionInfo: connectionInfoMock.Object).Result;

            // assert
            Assert.AreEqual(totalClaimValueForGroup, accountSummary.CappedClaimedValue, "The CappedClaimedValue value is not correct");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliverableGroupAmountSummaryCreationService_ShouldCreatePlannedValueTheSameAsParent_WhenGroupCodeAndUkprnNotInProfileTable()
        {
            // arrange
            Mock<IClaimReferenceProfileRepository> claimReferenceProfileRepositoryMock = new Mock<IClaimReferenceProfileRepository>();

            DeliverableGroupAmountSummaryCreator creator = new DeliverableGroupAmountSummaryCreator(claimReferenceProfileRepositoryMock.Object);
            var connectionInfoMock = new Mock<ConnectionInfo>(null, Mock.Of<IDbConnection>());
            const int totalClaimValueForGroup = 100;
            const int parentDeliverablePlannedValue = 101;

            // act
            AmountSummary accountSummary = creator.CalculateAndCreateAmountSummary(parentDeliverablePlannedValue: parentDeliverablePlannedValue,
                totalPlannedValueForGroup: 12,
                totalClaimValueForGroup: totalClaimValueForGroup,
                shouldCapToProfile: false,
                delGroupCode: "X",
                ukprn: 1,
                connectionInfo: connectionInfoMock.Object).Result;

            // assert
            Assert.AreEqual(parentDeliverablePlannedValue, accountSummary.PlannedValue, "The PlannedValue value is not correct");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliverableGroupAmountSummaryCreationService_ShouldCreatePlannedValueTheSameAsTotalForGroup_WhenParentPlannedValueNotSetAndCappingNotRequired()
        {
            // arrange
            Mock<IClaimReferenceProfileRepository> claimReferenceProfileRepositoryMock = new Mock<IClaimReferenceProfileRepository>();

            DeliverableGroupAmountSummaryCreator creator = new DeliverableGroupAmountSummaryCreator(claimReferenceProfileRepositoryMock.Object);
            var connectionInfoMock = new Mock<ConnectionInfo>(null, Mock.Of<IDbConnection>());
            const int totalClaimValueForGroup = 100;
            const int parentDeliverablePlannedValue = 0;
            const int totalPlannedValueForGroup = 102;

            // act
            AmountSummary accountSummary = creator.CalculateAndCreateAmountSummary(parentDeliverablePlannedValue: parentDeliverablePlannedValue,
                totalPlannedValueForGroup: totalPlannedValueForGroup,
                totalClaimValueForGroup: totalClaimValueForGroup,
                shouldCapToProfile: false,
                delGroupCode: "X",
                ukprn: 1,
                connectionInfo: connectionInfoMock.Object).Result;

            // assert
            Assert.AreEqual(totalPlannedValueForGroup, accountSummary.PlannedValue, "The PlannedValue value is not correct");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliverableGroupAmountSummaryCreationService_ShouldSetCappedClaimToTotalPlannedValue_WhenCappingRequiredAndProfileValueNotPresentAndTotalClaimGreaterThanPlanned()
        {
            // arrange
            Mock<IClaimReferenceProfileRepository> claimReferenceProfileRepositoryMock = new Mock<IClaimReferenceProfileRepository>();

            DeliverableGroupAmountSummaryCreator creator = new DeliverableGroupAmountSummaryCreator(claimReferenceProfileRepositoryMock.Object);
            var connectionInfoMock = new Mock<ConnectionInfo>(null, Mock.Of<IDbConnection>());
            const int totalClaimValueForGroup = 110;
            const int parentDeliverablePlannedValue = 0;
            const int totalPlannedValueForGroup = 102;

            // act
            AmountSummary accountSummary = creator.CalculateAndCreateAmountSummary(parentDeliverablePlannedValue: parentDeliverablePlannedValue,
                totalPlannedValueForGroup: totalPlannedValueForGroup,
                totalClaimValueForGroup: totalClaimValueForGroup,
                shouldCapToProfile: true,
                delGroupCode: "X",
                ukprn: 1,
                connectionInfo: connectionInfoMock.Object).Result;

            // assert
            Assert.AreEqual(totalPlannedValueForGroup, accountSummary.CappedClaimedValue, "The CappedClaimedValue value is not correct");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliverableGroupAmountSummaryCreationService_ShouldSetCappedClaimToParentPlannedValue_WhenCappingRequiredAndProfileValueNotPresentParentValuePresentAndTotalClaimGreaterThanPlanned()
        {
            // arrange
            Mock<IClaimReferenceProfileRepository> claimReferenceProfileRepositoryMock = new Mock<IClaimReferenceProfileRepository>();

            DeliverableGroupAmountSummaryCreator creator = new DeliverableGroupAmountSummaryCreator(claimReferenceProfileRepositoryMock.Object);
            var connectionInfoMock = new Mock<ConnectionInfo>(null, Mock.Of<IDbConnection>());
            const int totalClaimValueForGroup = 110;
            const int parentDeliverablePlannedValue = 1;
            const int totalPlannedValueForGroup = 102;

            // act
            AmountSummary accountSummary = creator.CalculateAndCreateAmountSummary(parentDeliverablePlannedValue: parentDeliverablePlannedValue,
                totalPlannedValueForGroup: totalPlannedValueForGroup,
                totalClaimValueForGroup: totalClaimValueForGroup,
                shouldCapToProfile: true,
                delGroupCode: "X",
                ukprn: 1,
                connectionInfo: connectionInfoMock.Object).Result;

            // assert
            Assert.AreEqual(parentDeliverablePlannedValue, accountSummary.CappedClaimedValue, "The CappedClaimedValue value is not correct");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliverableGroupAmountSummaryCreationService_ShouldSetPlannedValueToTotalPlannedValueForGroup_WhenIsProfileFromReferenceDataReturnsTrueButThereIsNoProfileValue()
        {
            // arrange
            Mock<IClaimReferenceProfileRepository> claimReferenceProfileRepositoryMock = new Mock<IClaimReferenceProfileRepository>();
            claimReferenceProfileRepositoryMock.Setup(r => r.IsProfileFromReferenceData(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(true);

            DeliverableGroupAmountSummaryCreator creator = new DeliverableGroupAmountSummaryCreator(claimReferenceProfileRepositoryMock.Object);
            var connectionInfoMock = new Mock<ConnectionInfo>(null, Mock.Of<IDbConnection>());
            const int totalClaimValueForGroup = 110;
            const int parentDeliverablePlannedValue = 1;
            const int totalPlannedValueForGroup = 102;

            // act
            AmountSummary accountSummary = creator.CalculateAndCreateAmountSummary(parentDeliverablePlannedValue: parentDeliverablePlannedValue,
                totalPlannedValueForGroup: totalPlannedValueForGroup,
                totalClaimValueForGroup: totalClaimValueForGroup,
                shouldCapToProfile: true,
                delGroupCode: "X",
                ukprn: 1,
                connectionInfo: connectionInfoMock.Object).Result;

            // assert
            Assert.AreEqual(totalPlannedValueForGroup, accountSummary.PlannedValue, "The CappedClaimedValue value is not correct");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliverableGroupAmountSummaryCreationService_ShouldCappedClaimValueToZero_WhenIsProfileFromReferenceDataReturnsTrueButThereIsNoProfileValue()
        {
            // arrange
            Mock<IClaimReferenceProfileRepository> claimReferenceProfileRepositoryMock = new Mock<IClaimReferenceProfileRepository>();
            claimReferenceProfileRepositoryMock.Setup(r => r.IsProfileFromReferenceData(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(true);

            DeliverableGroupAmountSummaryCreator creator = new DeliverableGroupAmountSummaryCreator(claimReferenceProfileRepositoryMock.Object);
            var connectionInfoMock = new Mock<ConnectionInfo>(null, Mock.Of<IDbConnection>());
            const int totalClaimValueForGroup = 110;
            const int parentDeliverablePlannedValue = 1;
            const int totalPlannedValueForGroup = 102;

            // act
            AmountSummary accountSummary = creator.CalculateAndCreateAmountSummary(parentDeliverablePlannedValue: parentDeliverablePlannedValue,
                totalPlannedValueForGroup: totalPlannedValueForGroup,
                totalClaimValueForGroup: totalClaimValueForGroup,
                shouldCapToProfile: true,
                delGroupCode: "X",
                ukprn: 1,
                connectionInfo: connectionInfoMock.Object).Result;

            // assert
            Assert.AreEqual(0, accountSummary.CappedClaimedValue, "The CappedClaimedValue value is not correct");
        }
    }
}