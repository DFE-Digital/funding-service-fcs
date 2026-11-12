namespace PaymentGenerationDomain.BusinessLogic.Tests
{
    extern alias Entities;
    using Integration.DataStore.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class OutstandingPaymentsCheckerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void OutstandingPaymentsChecker_HasOutstandingPaymentsForAllocation_WhenPaymentTimetableHasOutstandingPaymentsAndSubnominalAggregationsHasOutstandingPayments_ShouldReturnTrue()
        {
            // Arrange
            var mockTimeTableRepository = new Mock<IPaymentTimetableRepository>();
            mockTimeTableRepository
                .Setup(m => m.HasOutstandingPaymentTimetablesForFundingStreamPeriod(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(true);

            var mockSubnominalRepository = new Mock<ISubnominalAggregationRepository>();
            mockSubnominalRepository.Setup(m => m.HasOutstandingPaymentsForAllocation(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(true);

            // Act
            OutstandingPaymentsChecker outstandingPaymentChecker =
                new OutstandingPaymentsChecker(mockTimeTableRepository.Object, mockSubnominalRepository.Object);
            bool returnValue = outstandingPaymentChecker.HasOutstandingPaymentsForAllocation("test", "test", ConnectionInfo.CreateDefault());
            
            // Assert
            Assert.IsTrue(returnValue);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void OutstandingPaymentsChecker_HasOutstandingPaymentsForAllocation_WhenPaymentTimetableHasNoOutstandingPaymentsAndSubnominalAggregationsHasOutstandingPayments_ShouldReturnFalse()
        {
            // Arrange
            var mockTimeTableRepository = new Mock<IPaymentTimetableRepository>();
            mockTimeTableRepository
                .Setup(m => m.HasOutstandingPaymentTimetablesForFundingStreamPeriod(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(false);

            var mockSubnominalRepository = new Mock<ISubnominalAggregationRepository>();
            mockSubnominalRepository
                .Setup(m => m.HasOutstandingPaymentsForAllocation(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(true);

            // Act
            OutstandingPaymentsChecker outstandingPaymentChecker =
                new OutstandingPaymentsChecker(mockTimeTableRepository.Object, mockSubnominalRepository.Object);
            bool returnValue = outstandingPaymentChecker.HasOutstandingPaymentsForAllocation("test", "test", ConnectionInfo.CreateDefault());

            // Assert
            Assert.IsFalse(returnValue);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void OutstandingPaymentsChecker_HasOutstandingPaymentsForAllocation_WhenPaymentTimetableHasOutstandingPaymentsAndSubnominalAggregationsHasNoOutstandingPayments_ShouldReturnFalse()
        {
            // Arrange
            var mockTimeTableRepository = new Mock<IPaymentTimetableRepository>();
            mockTimeTableRepository
                .Setup(m => m.HasOutstandingPaymentTimetablesForFundingStreamPeriod(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(true);

            var mockSubnominalRepository = new Mock<ISubnominalAggregationRepository>();
            mockSubnominalRepository
                .Setup(m => m.HasOutstandingPaymentsForAllocation(It.IsAny<string>(), ConnectionInfo.CreateDefault()))
                .Returns(false);

            // Act
            OutstandingPaymentsChecker outstandingPaymentChecker =
                new OutstandingPaymentsChecker(mockTimeTableRepository.Object, mockSubnominalRepository.Object);
            bool returnValue = outstandingPaymentChecker.HasOutstandingPaymentsForAllocation("test", "test", ConnectionInfo.CreateDefault());

            // Assert
            Assert.IsFalse(returnValue);
        }
    }
}
