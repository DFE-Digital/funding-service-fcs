namespace FCT.Operations.Integrity.Tests.Services
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.Operations.Integrity.Repositories;
    using SFA.FCT.Operations.Integrity.Services;

    [TestClass]
    public class ChangeTrackerServiceTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void ChangeTrackerService_ShouldGet()
        {
            // arrange
            Mock<IIntegrityCheckChangeTrackingRepository> mockRepository = new Mock<IIntegrityCheckChangeTrackingRepository>();
            mockRepository.Setup(r => r.GetCurrentVersion(It.IsAny<string>())).Returns(0);

            ChangeTrackerService service = new ChangeTrackerService(mockRepository.Object, Mock.Of<ILogger>(), new LocalConfig());

            // act
            service.GetDeliverablePaymentChanges(null);

            // assert
        }
    }
}
