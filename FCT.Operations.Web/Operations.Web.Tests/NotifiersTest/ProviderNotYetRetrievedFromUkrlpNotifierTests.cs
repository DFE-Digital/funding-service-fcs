namespace Operations.Web.Tests.NotifiersTest
{
    using Castle.MicroKernel.Lifestyle;
    using OrganisationDomain.Integration.DataStore.Repositories;
    using Castle.Windsor;
    using IoC;
    using Microsoft.Extensions.Logging;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using Dtos;
    using Notifiers;
    using Operations.Web.Notifiers;

    [TestClass]
    public class ProviderNotYetRetrievedFromUkrlpNotifierTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ProviderNotYetRetrievedFromUkrlpNotifier_GetNotification_WhenANonZeroCountZeroIsReportedFromRepostory_ShouldReturnCorrectNotificationResult()
        {
            // Arrange
            var mockOrganisationRepository = new Mock<IOrganisationRepository>();
            mockOrganisationRepository.Setup(m => m.GetNumberOfProvidersNotYetBeenRetrievedFromUkrlp()).ReturnsAsync(5);

            ProviderNotYetRetrievedFromUkrlpNotifier notifier = new ProviderNotYetRetrievedFromUkrlpNotifier(mockOrganisationRepository.Object);

            // Act
            Notification result = notifier.GetNotification().Result;

            // Assert
            Assert.AreEqual("5", result.Description);
            Assert.AreEqual(NotificationType.Warning, result.NotificationType);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ProviderNotYetRetrievedFromUkrlpNotifier_GetNotification_WhenAZeroCountIsReportedFromRepository_ShouldReturnCorrectNotificationResult()
        {
            // Arrange
            var mockOrganisationRepository = new Mock<IOrganisationRepository>();
            mockOrganisationRepository.Setup(m => m.GetNumberOfProvidersNotYetBeenRetrievedFromUkrlp()).ReturnsAsync(0);

            ProviderNotYetRetrievedFromUkrlpNotifier notifier = new ProviderNotYetRetrievedFromUkrlpNotifier(mockOrganisationRepository.Object);

            // Act
            Notification result = notifier.GetNotification().Result;

            // Assert
            Assert.AreEqual("0", result.Description);
            Assert.AreEqual(NotificationType.Info, result.NotificationType);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ProviderNotYetRetrievedFromUkrlpNotifier_GetNotification_WhenAZeroCountIsReturnedFromRepository_ShouldReturnCorrectNotificationResult()
        {
            // Arrange
            string descriptionMessageError = "Generic Sql Error";
            var mockOrganisationRepository = new Mock<IOrganisationRepository>();
            mockOrganisationRepository.Setup(m => m.GetNumberOfProvidersNotYetBeenRetrievedFromUkrlp()).ThrowsAsync(new Exception(descriptionMessageError));

            ProviderNotYetRetrievedFromUkrlpNotifier notifier = new ProviderNotYetRetrievedFromUkrlpNotifier(mockOrganisationRepository.Object);

            // Act
            Notification result = notifier.GetNotification().Result;

            // Assert
            Assert.AreEqual(descriptionMessageError, result.Description);
            Assert.AreEqual(NotificationType.Fatal, result.NotificationType);
        }
    }
}
