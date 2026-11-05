namespace ContractCreateDomain.Endpoint.Tests.NonFinancialAmendment
{
    using Microsoft.Xrm.Sdk;
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using Endpoint.NonFinancialAmendment;
    using Endpoint.NonFinancialAmendment.Services;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using ContractCreateDomain.Endpoint.NonFinancialAmendment.Repositories;
    using Endpoint.Infrastructure;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging.Interfaces;
    using NServiceBus.Testing;
    using SFA.FCT.Framework.Logging;

    [TestClass]
    public class AmendContractNonFinancialAmendmentHandlerTests
    {
        private const string ExpectedNotificationTextForNonApprovedContracts = @"It must be in a status and substatus of ""Approved""";
        private const string MasterContractAlreadyHasChildContractWithDraftStatusErrorMessage = "This Master Contract cannot have more than one associated Contract in a draft status at the same time";

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer().Install(new WindsorInstaller(new LoggerFactory()));
            container.Register(Component.For<IOrganizationService>().Instance(Mock.Of<IOrganizationService>()).Named("OrganizationServiceMock").IsDefault());
            container.Register(Component.For<AmendContractNonFinancialAmendmentHandler>());
            container.BeginScope();

            // act, assert
            container.Resolve<AmendContractNonFinancialAmendmentHandler>();
        }


        [TestMethod, TestCategory("UnitTest")]
        public void AmendContractNonFinancialAmendmentHandler_WhenInvalidContractWithAmendmentTypeOfNotification_ShouldSendCorrectNotification()
        {
            // Arrange
            string testContractNumber = "test";
            int testVersionNumber = 1;
            int testSubVersionNumber = 0;
            AmendmentType testAmendmentType = AmendmentType.Notification;
            NotificationType expectedNotificationType = NotificationType.ContractAmendmentNotificationNonFinancialAmendmentFailed;

            var mockValidationService = new Mock<INonFinancialAmendmentValidationService>();
            mockValidationService
                .Setup(m => m.IsValid(It.IsAny<ContractIdentifier>(), It.IsAny<ConnectionInfo>()))
                .Returns(ExpectedNotificationTextForNonApprovedContracts);

            AmendContractNonFinancialAmendmentHandler handler = new AmendContractNonFinancialAmendmentHandler(
                mockValidationService.Object, Mock.Of<ICrmContractRepository>(), Mock.Of<ILogger>(), Mock.Of<ISessionConnectionFactory>());

            var message = new AmendContractNonFinancialAmendmentCommand
            {
                ContractNumber = testContractNumber,
                VersionNumber = testVersionNumber,
                SubVersionNumber = testSubVersionNumber,
                AmendmentType = testAmendmentType
            };

            TestableMessageHandlerContext testableContext = new TestableMessageHandlerContext();

            // Act
            handler.Handle(message, testableContext);

            // Assert
            Assert.AreEqual(0, testableContext.SentMessages.Count(m => m.Message is IncrementContractVersionCommand), 
                "IncrementContractVersionCommand was incorrectly sent");
            Assert.AreEqual(1, testableContext.SentMessages.Count(m => m.Message is IssueCrmNotificationCommand),
                    "IssueCrmNotificationCommand was not sent");

            var issueCrmNotificationCommand = testableContext.SentMessages[0].Message as IssueCrmNotificationCommand;

            Assert.IsTrue(issueCrmNotificationCommand.ContractNumber == testContractNumber &&
                          issueCrmNotificationCommand.VersionNumber == testVersionNumber &&
                          issueCrmNotificationCommand.SubVersionNumber == testSubVersionNumber &&
                          issueCrmNotificationCommand.NotificationType == expectedNotificationType &&
                          issueCrmNotificationCommand.NotificationText == ExpectedNotificationTextForNonApprovedContracts,
                   "Detail held in the sent IssueCrmNotificationCommand was incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendContractNonFinancialAmendmentHandler_WhenInvalidContractWithAmendmentTypeOfVariation_ShouldSendCorrectNotification()
        {
            // Arrange
            string testContractNumber = "test";
            int testVersionNumber = 1;
            int testSubVersionNumber = 0;
            AmendmentType testAmendmentType = AmendmentType.Variation;
            NotificationType expectedNotificationType = NotificationType.ContractAmendmentVariationNonFinancialAmendmentFailed;

            var mockValidationService = new Mock<INonFinancialAmendmentValidationService>();
            mockValidationService
                .Setup(m => m.IsValid(It.IsAny<ContractIdentifier>(), It.IsAny<ConnectionInfo>()))
                .Returns(ExpectedNotificationTextForNonApprovedContracts);

            AmendContractNonFinancialAmendmentHandler handler = new AmendContractNonFinancialAmendmentHandler(
                mockValidationService.Object, Mock.Of<ICrmContractRepository>(), Mock.Of<ILogger>(), Mock.Of<ISessionConnectionFactory>());

            var message = new AmendContractNonFinancialAmendmentCommand
            {
                ContractNumber = testContractNumber,
                VersionNumber = testVersionNumber,
                SubVersionNumber = testSubVersionNumber,
                AmendmentType = testAmendmentType
            };

            TestableMessageHandlerContext testableContext = new TestableMessageHandlerContext();

            // Act
            handler.Handle(message, testableContext);

            // Assert
            Assert.AreEqual(0, testableContext.SentMessages.Count(m => m.Message is IncrementContractVersionCommand),
                "IncrementContractVersionCommand was incorrectly sent");
            Assert.AreEqual(1, testableContext.SentMessages.Count(m => m.Message is IssueCrmNotificationCommand),
                "IssueCrmNotificationCommand was not sent");

            var issueCrmNotificationCommand = testableContext.SentMessages[0].Message as IssueCrmNotificationCommand;

            Assert.IsTrue(issueCrmNotificationCommand.ContractNumber == testContractNumber &&
                          issueCrmNotificationCommand.VersionNumber == testVersionNumber &&
                          issueCrmNotificationCommand.SubVersionNumber == testSubVersionNumber &&
                          issueCrmNotificationCommand.NotificationType == expectedNotificationType &&
                          issueCrmNotificationCommand.NotificationText == ExpectedNotificationTextForNonApprovedContracts,
                "Detail held in the sent IssueCrmNotificationCommand was incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendContractNonFinancialAmendmentHandler_WhenValidContract_ShouldSendIncrementContractVersionCommand()
        {
            // Arrange
            string testContractNumber = "test";
            int testVersionNumber = 1;
            int testSubVersionNumber = 0;
            AmendmentType testAmendmentType = AmendmentType.Variation;

            var mockValidationService = new Mock<INonFinancialAmendmentValidationService>();
            mockValidationService
                .Setup(m => m.IsValid(It.IsAny<ContractIdentifier>(), It.IsAny<ConnectionInfo>()))
                .Returns((string)null);

            AmendContractNonFinancialAmendmentHandler handler = new AmendContractNonFinancialAmendmentHandler(
                mockValidationService.Object, Mock.Of<ICrmContractRepository>(), Mock.Of<ILogger>(), Mock.Of<ISessionConnectionFactory>());

            var message = new AmendContractNonFinancialAmendmentCommand
            {
                ContractNumber = testContractNumber,
                VersionNumber = testVersionNumber,
                SubVersionNumber = testSubVersionNumber,
                AmendmentType = testAmendmentType
            };

            TestableMessageHandlerContext testableContext = new TestableMessageHandlerContext();

            // Act
            handler.Handle(message, testableContext);

            // Assert
            Assert.AreEqual(1, testableContext.SentMessages.Count(m => m.Message is IncrementContractVersionCommand),
                "IncrementContractVersionCommand was not sent");
            Assert.AreEqual(0, testableContext.SentMessages.Count(m => m.Message is IssueCrmNotificationCommand),
                "IssueCrmNotificationCommand was incorrectly sent");

            var issueCrmNotificationCommand = testableContext.SentMessages[0].Message as IncrementContractVersionCommand;

            Assert.IsTrue(issueCrmNotificationCommand.ContractNumber == testContractNumber &&
                          issueCrmNotificationCommand.VersionNumber == testVersionNumber &&
                          issueCrmNotificationCommand.SubVersionNumber == testSubVersionNumber &&
                          issueCrmNotificationCommand.AmendmentType == testAmendmentType,
                "Detail held in the sent IncrementContractVersionCommand was incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendContractNonFinancialAmendmentHandler_WhenInvalidContract_ShouldSetContractServiceResponse()
        {
            // Arrange
            string testContractNumber = "test";
            int testVersionNumber = 1;
            int testSubVersionNumber = 0;
            AmendmentType testAmendmentType = AmendmentType.Variation;

            var mockValidationService = new Mock<INonFinancialAmendmentValidationService>();
            mockValidationService
                .Setup(m => m.IsValid(It.IsAny<ContractIdentifier>(), It.IsAny<ConnectionInfo>()))
                .Returns("dummy text");

            var mockContractRepository = new Mock<ICrmContractRepository>();

            AmendContractNonFinancialAmendmentHandler handler = new AmendContractNonFinancialAmendmentHandler(
                mockValidationService.Object, mockContractRepository.Object, Mock.Of<ILogger>(), Mock.Of<ISessionConnectionFactory>());

            var message = new AmendContractNonFinancialAmendmentCommand
            {
                ContractNumber = testContractNumber,
                VersionNumber = testVersionNumber,
                SubVersionNumber = testSubVersionNumber,
                AmendmentType = testAmendmentType
            };

            TestableMessageHandlerContext testableContext = new TestableMessageHandlerContext();

            // Act
            handler.Handle(message, testableContext);

            // Assert
            mockContractRepository.Verify(m => m.SetNonFinancialAmendmentFailedServiceResponseOnContract(
                testContractNumber,
                testVersionNumber,
                testSubVersionNumber), Times.Once);
        }
        
        [TestMethod, TestCategory("UnitTest")]
        public void AmendContractNonFinancialAmendmentHandler_ContractHasSiblingContractWithDraftStatus_ShouldSendCorrectNotification()
        {
            // Arrange
            string testContractNumber = "test";
            int testVersionNumber = 1;
            int testSubVersionNumber = 0;
            AmendmentType testAmendmentType = AmendmentType.Variation;
            NotificationType expectedNotificationType = NotificationType.ContractAmendmentVariationNonFinancialAmendmentFailed;

            var mockValidationService = new Mock<INonFinancialAmendmentValidationService>();
            mockValidationService
                .Setup(m => m.IsValid(It.IsAny<ContractIdentifier>(), It.IsAny<ConnectionInfo>()))
                .Returns(MasterContractAlreadyHasChildContractWithDraftStatusErrorMessage);

            AmendContractNonFinancialAmendmentHandler handler = new AmendContractNonFinancialAmendmentHandler(
                mockValidationService.Object, Mock.Of<ICrmContractRepository>(), Mock.Of<ILogger>(), Mock.Of<ISessionConnectionFactory>());

            var message = new AmendContractNonFinancialAmendmentCommand
            {
                ContractNumber = testContractNumber,
                VersionNumber = testVersionNumber,
                SubVersionNumber = testSubVersionNumber,
                AmendmentType = testAmendmentType
            };

            TestableMessageHandlerContext testableContext = new TestableMessageHandlerContext();

            // Act
            handler.Handle(message, testableContext);

            // Assert
            Assert.AreEqual(0, testableContext.SentMessages.Count(m => m.Message is IncrementContractVersionCommand),
                "IncrementContractVersionCommand was incorrectly sent");
            Assert.AreEqual(1, testableContext.SentMessages.Count(m => m.Message is IssueCrmNotificationCommand),
                "IssueCrmNotificationCommand was not sent");

            var issueCrmNotificationCommand = testableContext.SentMessages[0].Message as IssueCrmNotificationCommand;

            Assert.IsTrue(issueCrmNotificationCommand.ContractNumber == testContractNumber &&
                          issueCrmNotificationCommand.VersionNumber == testVersionNumber &&
                          issueCrmNotificationCommand.SubVersionNumber == testSubVersionNumber &&
                          issueCrmNotificationCommand.NotificationType == expectedNotificationType &&
                          issueCrmNotificationCommand.NotificationText == MasterContractAlreadyHasChildContractWithDraftStatusErrorMessage,
                "Detail held in the sent IssueCrmNotificationCommand was incorrect");
        }
    }
}