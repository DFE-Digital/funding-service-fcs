namespace Operations.Web.Tests.CheckersTests
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Dtos;
    using System;
    using Moq;
    using Checkers;
    using Services;

    [TestClass]
    public class UkrlpCheckAvailabilityTests
    {
        private const string ExpectedServiceName = "Ukrlp Service";

        [TestMethod, TestCategory("UnitTest")]
        public void UkrlpCheckAvailability_WhenUkrlpServiceReturnsFalse_ShouldReturnAFalseResultWithCorrectErrorMessage()
        {
            // Arrange
            string expectedFalseMessage = "Could not retrieve expected provider, even though an exception was not thrown";
            var mockQuerier = new Mock<IUkrlpServiceQuerier>();
            mockQuerier.Setup(m => m.DoesUkprnExistInUkrlp(It.IsAny<string[]>())).ReturnsAsync(false);

            // Act
            UkrlpCheckAvailability ukrlpCheckAvailability = new UkrlpCheckAvailability(mockQuerier.Object);
            AvailabilityCheckResult checkResult = ukrlpCheckAvailability.GetCheckResult().Result;

            // Assert
            Assert.IsFalse(checkResult.IsAvailable);
            Assert.AreEqual(ExpectedServiceName, checkResult.ServiceName);
            Assert.AreEqual(expectedFalseMessage, checkResult.Details);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void UkrlpCheckAvailability_WhenUkrlpServiceReturnsAnException_ShouldReturnAFalseResultAndExceptionMessage()
        {
            // Arrange
            string expectedExceptionMessage = "dummy-exception-message";
            var mockQuerier = new Mock<IUkrlpServiceQuerier>();
            mockQuerier.Setup(m => m.DoesUkprnExistInUkrlp(It.IsAny<string[]>()))
                .Throws(new NotSupportedException(expectedExceptionMessage));

            // Act
            UkrlpCheckAvailability ukrlpCheckAvailability = new UkrlpCheckAvailability(mockQuerier.Object);
            AvailabilityCheckResult checkResult = ukrlpCheckAvailability.GetCheckResult().Result;

            // Assert
            Assert.IsFalse(checkResult.IsAvailable);
            Assert.AreEqual(ExpectedServiceName, checkResult.ServiceName);
            Assert.AreEqual(expectedExceptionMessage, checkResult.Details);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void UkrlpCheckAvailability_WhenMatchingProvidersFound_ShouldReturnATrueResultWithCorrectMessage()
        {
            // Arrange
            var mockQuerier = new Mock<IUkrlpServiceQuerier>();
            mockQuerier.Setup(m => m.DoesUkprnExistInUkrlp(It.IsAny<string[]>())).ReturnsAsync(true);

            UkrlpCheckAvailability availabilityChecker = new UkrlpCheckAvailability(mockQuerier.Object);

            // Act
            AvailabilityCheckResult availabilityCheckResult = availabilityChecker.GetCheckResult().Result;

            // Assert
            Assert.IsTrue(availabilityCheckResult.IsAvailable);
            Assert.AreEqual("Successful", availabilityCheckResult.Details);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void UkrlpCheckAvailability_ShouldSuccessfullyCallProductionUkrlpService()
        {
            // Arrange
            UkrlpServiceQuerier ukrlpServiceQuerier = new UkrlpServiceQuerier();

            UkrlpCheckAvailability availabilityChecker = new UkrlpCheckAvailability(ukrlpServiceQuerier);

            // Act
            AvailabilityCheckResult availabilityCheckResult = availabilityChecker.GetCheckResult().Result;

            // Assert
            Assert.IsTrue(availabilityCheckResult.IsAvailable, "Ukrlp service is not available");
        }
    }
}
