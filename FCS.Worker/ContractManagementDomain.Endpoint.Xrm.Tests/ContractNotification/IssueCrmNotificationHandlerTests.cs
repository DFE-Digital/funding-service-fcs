namespace ContractManagementDomain.Endpoint.Xrm.Tests.ContractNotification
{
    using System;
    using System.Linq.Expressions;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.Framework.Logging;
    using Xrm.ContractNotification;
    using Xrm.ContractNotification.Dtos;
    using Xrm.ContractNotification.Services;
    using NServiceBus.Testing;

    [TestClass]
    public class IssueCrmNotificationHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void IssueCrmNotificationHandler_WhenGivenACommandWithInitiateClosureFailedType_ShouldIssueInitiateClosureFailedNotification()
        {
            // arrange
            MockNotificationService mockNotificationService = SetupCrmNotificationService(s => s.CreateInitiateClosureFailedNotificationForContract(It.IsAny<NotificationInfo>()));

            IssueCrmNotificationHandler handler =
                new IssueCrmNotificationHandler(mockNotificationService.MockService.Object, Mock.Of<ILogger>());

            IssueCrmNotificationCommand command = new IssueCrmNotificationCommand
            {
                ContractNumber = "TESTCN",
                VersionNumber = 5,
                SubVersionNumber = 2,
                NotificationText = "Something went wrong",
                NotificationType = NotificationType.InitiateContractClosureFailed
            };

            NotificationInfo expectedNotificationInfo = GetNotificationInfoFromCommand(command);
            TestableMessageHandlerContext messageHandlerContext = new TestableMessageHandlerContext();

            // act
            handler.Handle(command, messageHandlerContext);

            // assert
            mockNotificationService.MockService.Verify(
                m => m.CreateApproveClosureFailedNotificationForContract(It.IsAny<NotificationInfo>()),
                Times.Never, "Crm Notification Service CreateApproveClosureFailedNotificationForContract was called unexpectedly");

            mockNotificationService.MockService.Verify(
                m => m.CreateInitiateClosureFailedNotificationForContract(It.IsAny<NotificationInfo>()),
                Times.Once, "Crm Notification Service CreateInitiateClosureFailedNotificationForContract was not called");

            Assert.AreEqual(expectedNotificationInfo.ContractNumber, mockNotificationService.ActualNotificationInfo.ContractNumber, "ContractNumber was incorrect");
            Assert.AreEqual(expectedNotificationInfo.VersionNumber, mockNotificationService.ActualNotificationInfo.VersionNumber, "VersionNumber was incorrect");
            Assert.AreEqual(expectedNotificationInfo.SubVersionNumber, mockNotificationService.ActualNotificationInfo.SubVersionNumber, "SubVersionNumber was incorrect");
            Assert.AreEqual(expectedNotificationInfo.NotificationText, mockNotificationService.ActualNotificationInfo.NotificationText, "NotificationText was incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void IssueCrmNotificationHandler_WhenGivenACommandWithApproveClosureFailedType_ShouldIssueApproveClosureFailedNotification()
        {
            // arrange
            MockNotificationService mockNotificationService = SetupCrmNotificationService(s => s.CreateApproveClosureFailedNotificationForContract(It.IsAny<NotificationInfo>()));

            IssueCrmNotificationHandler handler =
                new IssueCrmNotificationHandler(mockNotificationService.MockService.Object, Mock.Of<ILogger>());

            IssueCrmNotificationCommand command = new IssueCrmNotificationCommand
            {
                ContractNumber = "TESTCN",
                VersionNumber = 5,
                SubVersionNumber = 2,
                NotificationText = "Something went wrong",
                NotificationType = NotificationType.ApproveContractClosureFailed
            };

            NotificationInfo expectedNotificationInfo = GetNotificationInfoFromCommand(command);
            TestableMessageHandlerContext messageHandlerContext = new TestableMessageHandlerContext();

            // act
            handler.Handle(command, messageHandlerContext);

            // assert
            mockNotificationService.MockService.Verify(
                m => m.CreateInitiateClosureFailedNotificationForContract(It.IsAny<NotificationInfo>()),
                Times.Never, "Crm Notification Service CreateInitiateClosureFailedNotificationForContract was called unexpectedly");

            mockNotificationService.MockService.Verify(
                m => m.CreateApproveClosureFailedNotificationForContract(It.IsAny<NotificationInfo>()),
                Times.Once, "Crm Notification Service CreateApproveClosureFailedNotificationForContract was not called");

            Assert.AreEqual(expectedNotificationInfo.ContractNumber, mockNotificationService.ActualNotificationInfo.ContractNumber, "ContractNumber was incorrect");
            Assert.AreEqual(expectedNotificationInfo.VersionNumber, mockNotificationService.ActualNotificationInfo.VersionNumber, "VersionNumber was incorrect");
            Assert.AreEqual(expectedNotificationInfo.SubVersionNumber, mockNotificationService.ActualNotificationInfo.SubVersionNumber, "SubVersionNumber was incorrect");
            Assert.AreEqual(expectedNotificationInfo.NotificationText, mockNotificationService.ActualNotificationInfo.NotificationText, "NotificationText was incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void IssueCrmNotificationHandler_WhenGivenACommandWithContractAmendmentFailedType_ShouldIssueContractAmendmentFailureNotification()
        {
            // arrange
            MockNotificationService mockNotificationService = SetupCrmNotificationService(s => s.CreateContractAmendmentFailedNotificationForContract(It.IsAny<NotificationInfo>()));

            IssueCrmNotificationHandler handler =
                new IssueCrmNotificationHandler(mockNotificationService.MockService.Object, Mock.Of<ILogger>());

            IssueCrmNotificationCommand command = new IssueCrmNotificationCommand
            {
                ContractNumber = "TESTCN",
                VersionNumber = 5,
                SubVersionNumber = 2,
                NotificationText = "Something went wrong",
                NotificationType = NotificationType.ContractAmendmentFailedForContractClosureReason
            };

            NotificationInfo expectedNotificationInfo = GetNotificationInfoFromCommand(command);
            TestableMessageHandlerContext messageHandlerContext = new TestableMessageHandlerContext();

            // act
            handler.Handle(command, messageHandlerContext);

            // assert
            mockNotificationService.MockService.Verify(
                m => m.CreateContractAmendmentFailedNotificationForContract(It.IsAny<NotificationInfo>()),
                Times.Once, "Crm Notification Service CreateContractAmendmentFailedNotificationForContract was not called");

            Assert.AreEqual(expectedNotificationInfo.ContractNumber, mockNotificationService.ActualNotificationInfo.ContractNumber, "ContractNumber was incorrect");
            Assert.AreEqual(expectedNotificationInfo.VersionNumber, mockNotificationService.ActualNotificationInfo.VersionNumber, "VersionNumber was incorrect");
            Assert.AreEqual(expectedNotificationInfo.SubVersionNumber, mockNotificationService.ActualNotificationInfo.SubVersionNumber, "SubVersionNumber was incorrect");
            Assert.AreEqual(expectedNotificationInfo.NotificationText, mockNotificationService.ActualNotificationInfo.NotificationText, "NotificationText was incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void IssueCrmNotificationHandler_WhenGivenACommandWithContractNonFinancialVariationFailedType_ShouldIssueContractAmendmentFailureNotification()
        {
            // arrange
            MockNotificationService mockNotificationService = SetupCrmNotificationService(s => s.CreateContractVariationNonFinancialAmendmentFailedNotificationForContract(It.IsAny<NotificationInfo>()));

            IssueCrmNotificationHandler handler =
                new IssueCrmNotificationHandler(mockNotificationService.MockService.Object, Mock.Of<ILogger>());

            IssueCrmNotificationCommand command = new IssueCrmNotificationCommand
            {
                ContractNumber = "TESTCN",
                VersionNumber = 5,
                SubVersionNumber = 2,
                NotificationText = "Something went wrong",
                NotificationType = NotificationType.ContractAmendmentVariationNonFinancialAmendmentFailed
            };

            NotificationInfo expectedNotificationInfo = GetNotificationInfoFromCommand(command);
            TestableMessageHandlerContext messageHandlerContext = new TestableMessageHandlerContext();

            // act
            handler.Handle(command, messageHandlerContext);

            // assert
            mockNotificationService.MockService.Verify(
                m => m.CreateContractVariationNonFinancialAmendmentFailedNotificationForContract(It.IsAny<NotificationInfo>()),
                Times.Once, "Crm Notification Service CreateContractVariationNonFinancialAmendmentFailedNotificationForContract was not called");

            Assert.AreEqual(expectedNotificationInfo.ContractNumber, mockNotificationService.ActualNotificationInfo.ContractNumber, "ContractNumber was incorrect");
            Assert.AreEqual(expectedNotificationInfo.VersionNumber, mockNotificationService.ActualNotificationInfo.VersionNumber, "VersionNumber was incorrect");
            Assert.AreEqual(expectedNotificationInfo.SubVersionNumber, mockNotificationService.ActualNotificationInfo.SubVersionNumber, "SubVersionNumber was incorrect");
            Assert.AreEqual(expectedNotificationInfo.NotificationText, mockNotificationService.ActualNotificationInfo.NotificationText, "NotificationText was incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void IssueCrmNotificationHandler_WhenGivenACommandWithContractNonFinancialNotificationFailedType_ShouldIssueContractAmendmentFailureNotification()
        {
            // arrange
            MockNotificationService mockNotificationService = SetupCrmNotificationService(s => s.CreateContractNotificationNonFinancialAmendmentFailedNotificationForContract(It.IsAny<NotificationInfo>()));

            IssueCrmNotificationHandler handler =
                new IssueCrmNotificationHandler(mockNotificationService.MockService.Object, Mock.Of<ILogger>());

            IssueCrmNotificationCommand command = new IssueCrmNotificationCommand
            {
                ContractNumber = "TESTCN",
                VersionNumber = 5,
                SubVersionNumber = 2,
                NotificationText = "Something went wrong",
                NotificationType = NotificationType.ContractAmendmentNotificationNonFinancialAmendmentFailed
            };

            NotificationInfo expectedNotificationInfo = GetNotificationInfoFromCommand(command);
            TestableMessageHandlerContext messageHandlerContext = new TestableMessageHandlerContext();

            // act
            handler.Handle(command, messageHandlerContext);

            // assert
            mockNotificationService.MockService.Verify(
                m => m.CreateContractNotificationNonFinancialAmendmentFailedNotificationForContract(It.IsAny<NotificationInfo>()),
                Times.Once, "Crm Notification Service CreateContractNotificationNonFinancialAmendmentFailedNotificationForContract was not called");

            Assert.AreEqual(expectedNotificationInfo.ContractNumber, mockNotificationService.ActualNotificationInfo.ContractNumber, "ContractNumber was incorrect");
            Assert.AreEqual(expectedNotificationInfo.VersionNumber, mockNotificationService.ActualNotificationInfo.VersionNumber, "VersionNumber was incorrect");
            Assert.AreEqual(expectedNotificationInfo.SubVersionNumber, mockNotificationService.ActualNotificationInfo.SubVersionNumber, "SubVersionNumber was incorrect");
            Assert.AreEqual(expectedNotificationInfo.NotificationText, mockNotificationService.ActualNotificationInfo.NotificationText, "NotificationText was incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void IssueCrmNotificationHandler_WhenGivenACommandWithDeleteDraftContractFailedType_ShouldIssueDeleteDraftContractFailedNotification()
        {
            MockNotificationService mockNotificationService = SetupCrmNotificationService(s => s.CreateDeleteDraftContractFailedNotificationForContract(It.IsAny<NotificationInfo>()));

            IssueCrmNotificationHandler handler =
                new IssueCrmNotificationHandler(mockNotificationService.MockService.Object, Mock.Of<ILogger>());

            IssueCrmNotificationCommand command = new IssueCrmNotificationCommand
            {
                ContractNumber = "TESTCN",
                VersionNumber = 1,
                SubVersionNumber = 0,
                NotificationText = "DELETE DRAFT Something went wrong",
                NotificationType = NotificationType.DeleteDraftContractFailed
            };

            NotificationInfo expectedNotificationInfo = GetNotificationInfoFromCommand(command);
            TestableMessageHandlerContext messageHandlerContext = new TestableMessageHandlerContext();

            // act
            handler.Handle(command, messageHandlerContext);

            // assert
            mockNotificationService.MockService.Verify(
                m => m.CreateDeleteDraftContractFailedNotificationForContract(It.IsAny<NotificationInfo>()),
                Times.Once, "Crm Notification Service CreateContractNotificationNonFinancialAmendmentFailedNotificationForContract was not called");

            Assert.AreEqual(expectedNotificationInfo.ContractNumber, mockNotificationService.ActualNotificationInfo.ContractNumber, "ContractNumber was incorrect");
            Assert.AreEqual(expectedNotificationInfo.VersionNumber, mockNotificationService.ActualNotificationInfo.VersionNumber, "VersionNumber was incorrect");
            Assert.AreEqual(expectedNotificationInfo.SubVersionNumber, mockNotificationService.ActualNotificationInfo.SubVersionNumber, "SubVersionNumber was incorrect");
            Assert.AreEqual(expectedNotificationInfo.NotificationText, mockNotificationService.ActualNotificationInfo.NotificationText, "NotificationText was incorrect");

        }

        [TestMethod, TestCategory("UnitTest")]
        public void IssueCrmNotificationHandler_WhenGivenACommandWithContractTerminationFailedType_ShouldIssueContractTerminationFailedNotification()
        {
            MockNotificationService mockNotificationService = SetupCrmNotificationService(s => s.CreateNotificationForContract(It.IsAny<NotificationInfo>()));

            IssueCrmNotificationHandler handler =
                new IssueCrmNotificationHandler(mockNotificationService.MockService.Object, Mock.Of<ILogger>());

            IssueCrmNotificationCommand command = new IssueCrmNotificationCommand
            {
                ContractNumber = "TESTCN",
                VersionNumber = 1,
                SubVersionNumber = 0,
                NotificationText = "TERMINATE CONTRACT Something went wrong",
                NotificationType = NotificationType.ContractTerminationFailed
            };

            NotificationInfo expectedNotificationInfo = new NotificationInfo(
                command.ContractNumber,
                command.VersionNumber,
                command.SubVersionNumber,
                command.NotificationText,
                NotificationInfo.NotificationReason.ContractTerminationValidationFailed,
                "Terminate Contract", "Contract Termination Failed");
            TestableMessageHandlerContext messageHandlerContext = new TestableMessageHandlerContext();

            // act
            handler.Handle(command, messageHandlerContext);

            // assert
            mockNotificationService.MockService.Verify(
                m => m.CreateNotificationForContract(It.IsAny<NotificationInfo>()),
                Times.Once, "Crm Notification Service CreateNotificationForContract was not called");

            Assert.AreEqual(expectedNotificationInfo.ContractNumber, mockNotificationService.ActualNotificationInfo.ContractNumber, "ContractNumber was incorrect");
            Assert.AreEqual(expectedNotificationInfo.VersionNumber, mockNotificationService.ActualNotificationInfo.VersionNumber, "VersionNumber was incorrect");
            Assert.AreEqual(expectedNotificationInfo.SubVersionNumber, mockNotificationService.ActualNotificationInfo.SubVersionNumber, "SubVersionNumber was incorrect");
            Assert.AreEqual(expectedNotificationInfo.NotificationText, mockNotificationService.ActualNotificationInfo.NotificationText, "NotificationText was incorrect");

            Assert.AreEqual(expectedNotificationInfo.ReasonForNotification, mockNotificationService.ActualNotificationInfo.ReasonForNotification, "ReasonForNotification was incorrect");
            Assert.AreEqual(expectedNotificationInfo.TransitionName, mockNotificationService.ActualNotificationInfo.TransitionName, "TransitionName was incorrect");
            Assert.AreEqual(expectedNotificationInfo.NotificationName, mockNotificationService.ActualNotificationInfo.NotificationName, "NotificationName was incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void IssueCrmNotificationCommandHandler_ShouldResolve()
        {
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<IssueCrmNotificationHandler>());
            container.Register(Component.For<Microsoft.Xrm.Sdk.IOrganizationService>().Instance(Mock.Of<Microsoft.Xrm.Sdk.IOrganizationService>()).IsDefault());

            container.BeginScope();

            Assert.IsNotNull(container.Resolve<IssueCrmNotificationHandler>());
        }

        private NotificationInfo GetNotificationInfoFromCommand(IssueCrmNotificationCommand command)
        {
            return new NotificationInfo(
                command.ContractNumber,
                command.VersionNumber,
                command.SubVersionNumber,
                command.NotificationText,
                NotificationInfo.NotificationReason.ContractClosureFound,
                string.Empty,
                string.Empty);
        }

        private class MockNotificationService
        {
            public MockNotificationService(Mock<ICrmNotificationService> mockService)
            {
                MockService = mockService;
            }

            public Mock<ICrmNotificationService> MockService { get; }

            public NotificationInfo ActualNotificationInfo { get; set; }

            public NotificationInfo GetNotificationInfo()
            {
                return ActualNotificationInfo;
            }
        }

        private MockNotificationService SetupCrmNotificationService(Expression<Action<ICrmNotificationService>> consumeNotificationService)
        {
            MockNotificationService mockNotificationService = new MockNotificationService(new Mock<ICrmNotificationService>());

            mockNotificationService.MockService.Setup(consumeNotificationService)
                .Callback((NotificationInfo ni) =>
                {
                    mockNotificationService.ActualNotificationInfo = ni;
                });

            return mockNotificationService;
        }
    }
}