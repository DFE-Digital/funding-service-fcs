namespace ContractManagementDomain.Endpoint.Tests.LevyAmendmentEndpoint
{
    using System.Collections.Generic;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using Endpoint.LevyAmendmentEndpoint;
    using Endpoint.LevyAmendmentEndpoint.Services;
    using NServiceBus.Testing;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using ContractManagementDomain.Endpoint.LevyAmendmentEndpoint.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using System.Threading.Tasks;
    using Infrastructure;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.ContractManagementDomain.Integration.Dtos;
    using System;
    using System.Linq;
    using Endpoint.LevyAmendmentEndpoint.DTOs;
    using SFA.FCT.ContractManagementService.Common;
    using ContractInformation = SFA.FCT.CrossDomain.Integration.Entities.ContractInformation;

    [TestClass]
    public class AmendLevyContractHandlerTests
    {
        private const string ClosureNotificationText = "contract closure has been initiated";
        private const string TerminationNotificationText = "contract is awaiting approval of termination initiation";

        // BULK
        [TestMethod, TestCategory("UnitTest")]
        public void AmendLevyContractHandler_ShouldSendIncrementContractVersionCommand_ForApprovedApprovedOnRoatpAndBulkType()
        {
            // arrange
            Mock<IRoatpProviderRepository> roatpRepositoryMock = new Mock<IRoatpProviderRepository>();
            roatpRepositoryMock.Setup(m => m.IsProviderOnRoatp(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(Task.FromResult(true));

            IAmendLevyContractService amendLevyContractService = new AmendLevyContractService(roatpRepositoryMock.Object, Mock.Of<ICrmContractRepository>(), Mock.Of<ILogger>());

            var handler = new AmendLevyContractHandler(
                Mock.Of<ILogger>(),
                amendLevyContractService,
                Mock.Of<ISessionConnectionFactory>(),
                Mock.Of<ICrmContractRepository>());

            TestableMessageHandlerContext testableMessageHandlerContext = new TestableMessageHandlerContext();

            // act
            handler.Handle(new AmendLevyContractCommand
            {
                ContractInformation = new ContractInformation(
                    contractNumber: "",
                    masterContractNumber: "",
                    contractVersionNumber: 1,
                    subVersionNumber: 0,
                    ukprn: "",
                    contractStatus: ContractStatus.Approved,
                    contractSubStatus: ContractSubStatus.Approved),
                AmendmentSource = AmendLevyContractCommand.LevyAmendmentSource.Bulk
            }, testableMessageHandlerContext).Wait();

            // assert
            Assert.AreEqual(1, testableMessageHandlerContext.SentMessages.Length, "The wrong number of messages were sent");
            Assert.IsTrue(testableMessageHandlerContext.SentMessages[0].Message is IncrementContractVersionCommand, "The sent message is the wrong type");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendLevyContractHandler_ShouldSendIncrementContractVersionCommand_ForApprovedUnderTerminationOnRoatpAndBulkType()
        {
            // arrange
            Mock<IRoatpProviderRepository> roatpRepositoryMock = new Mock<IRoatpProviderRepository>();
            roatpRepositoryMock.Setup(m => m.IsProviderOnRoatp(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(Task.FromResult(true));

            IAmendLevyContractService amendLevyContractService = new AmendLevyContractService(roatpRepositoryMock.Object, Mock.Of<ICrmContractRepository>(), Mock.Of<ILogger>());

            var handler = new AmendLevyContractHandler(Mock.Of<ILogger>(), amendLevyContractService, Mock.Of<ISessionConnectionFactory>(), Mock.Of<ICrmContractRepository>());
            TestableMessageHandlerContext testableMessageHandlerContext = new TestableMessageHandlerContext();

            // act
            handler.Handle(new AmendLevyContractCommand
            {
                ContractInformation = new ContractInformation(
                    contractNumber: "",
                    masterContractNumber: "",
                    contractVersionNumber: 1,
                    subVersionNumber: 0,
                    ukprn: "",
                    contractStatus: ContractStatus.Approved,
                    contractSubStatus: ContractSubStatus.UnderTermination),
                AmendmentSource = AmendLevyContractCommand.LevyAmendmentSource.Bulk
            }, testableMessageHandlerContext).Wait();

            // assert
            Assert.AreEqual(1, testableMessageHandlerContext.SentMessages.Length, "The wrong number of messages were sent");
            Assert.IsTrue(testableMessageHandlerContext.SentMessages[0].Message is IncrementContractVersionCommand, "The sent message is the wrong type");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendLevyContractHandler_ShouldSendPreIncrementWithdrawCommand_ForDraftPublishedtoProviderOnRoatpAndBulkType()
        {
            // arrange
            Mock<IRoatpProviderRepository> roatpRepositoryMock = new Mock<IRoatpProviderRepository>();
            roatpRepositoryMock.Setup(m => m.IsProviderOnRoatp(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(Task.FromResult(true));

            IAmendLevyContractService amendLevyContractService = new AmendLevyContractService(roatpRepositoryMock.Object, Mock.Of<ICrmContractRepository>(), Mock.Of<ILogger>());

            var handler = new AmendLevyContractHandler(
                Mock.Of<ILogger>(),
                amendLevyContractService,
                Mock.Of<ISessionConnectionFactory>(),
                Mock.Of<ICrmContractRepository>());

            TestableMessageHandlerContext testableMessageHandlerContext = new TestableMessageHandlerContext();

            // act
            handler.Handle(new AmendLevyContractCommand
            {
                ContractInformation = new ContractInformation(
                    contractNumber: "",
                    masterContractNumber: "",
                    contractVersionNumber: 1,
                    subVersionNumber: 0,
                    ukprn: "",
                    contractStatus: ContractStatus.Draft,
                    contractSubStatus: ContractSubStatus.PublishedtoProvider),
                AmendmentSource = AmendLevyContractCommand.LevyAmendmentSource.Bulk
            }, testableMessageHandlerContext).Wait();

            // assert
            Assert.AreEqual(1, testableMessageHandlerContext.SentMessages.Length, "The wrong number of messages were sent");
            Assert.IsTrue(testableMessageHandlerContext.SentMessages[0].Message is PreIncrementWithdrawalCommand, "The sent message is the wrong type");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendLevyContractHandler_ShouldSendNotificationCommand_WithClosureNotificationText_ForApprovedClosureInitiationInProgressContractOnRoatpAndBulkType()
        {
            // arrange
            Mock<IRoatpProviderRepository> roatpRepositoryMock = new Mock<IRoatpProviderRepository>();
            roatpRepositoryMock.Setup(m => m.IsProviderOnRoatp(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(Task.FromResult(true));

            IAmendLevyContractService amendLevyContractService = new AmendLevyContractService(roatpRepositoryMock.Object, Mock.Of<ICrmContractRepository>(), Mock.Of<ILogger>());

            var handler = new AmendLevyContractHandler(
                Mock.Of<ILogger>(),
                amendLevyContractService,
                Mock.Of<ISessionConnectionFactory>(),
                Mock.Of<ICrmContractRepository>());

            TestableMessageHandlerContext testableMessageHandlerContext = new TestableMessageHandlerContext();
            // act
            handler.Handle(new AmendLevyContractCommand
            {
                ContractInformation = new ContractInformation(
                    contractNumber: "",
                    masterContractNumber: "",
                    contractVersionNumber: 1,
                    subVersionNumber: 0,
                    ukprn: "",
                    contractStatus: ContractStatus.Approved,
                    contractSubStatus: ContractSubStatus.ClosureInitiationinProgress),
                AmendmentSource = AmendLevyContractCommand.LevyAmendmentSource.Bulk
            }, testableMessageHandlerContext).Wait();

            // assert
            roatpRepositoryMock.Verify(r => r.IsProviderOnRoatp(It.IsAny<string>(), It.IsAny<ConnectionInfo>()), Times.Never,
                "IsProviderOnRoatp method was incorrectly called");
            Assert.AreEqual(1, testableMessageHandlerContext.SentMessages.Length, "The wrong number of messages were sent");
            Assert.IsTrue(testableMessageHandlerContext.SentMessages[0].Message is IssueCrmNotificationCommand, "The sent message is the wrong type");

            var sentMessage = (IssueCrmNotificationCommand)testableMessageHandlerContext.SentMessages[0].Message;
            Assert.AreEqual(ClosureNotificationText, sentMessage.NotificationText, "Incorrect notification text");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendLevyContractHandler_ShouldSendNotificationCommand_WithClosureNotificationText_ForApprovedAwaitingClosureApprovalContractOnRoatpAndBulkType()
        {
            // arrange
            Mock<IRoatpProviderRepository> roatpRepositoryMock = new Mock<IRoatpProviderRepository>();
            roatpRepositoryMock.Setup(m => m.IsProviderOnRoatp(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(Task.FromResult(true));

            IAmendLevyContractService amendLevyContractService = new AmendLevyContractService(roatpRepositoryMock.Object, Mock.Of<ICrmContractRepository>(), Mock.Of<ILogger>());

            var handler = new AmendLevyContractHandler(
                Mock.Of<ILogger>(),
                amendLevyContractService,
                Mock.Of<ISessionConnectionFactory>(),
                Mock.Of<ICrmContractRepository>());

            TestableMessageHandlerContext testableMessageHandlerContext = new TestableMessageHandlerContext();

            // act
            handler.Handle(new AmendLevyContractCommand
            {
                ContractInformation = new ContractInformation(
                    contractNumber: "",
                    masterContractNumber: "",
                    contractVersionNumber: 1,
                    subVersionNumber: 0,
                    ukprn: "",
                    contractStatus: ContractStatus.Approved,
                    contractSubStatus: ContractSubStatus.AwaitingClosureApproval),
                AmendmentSource = AmendLevyContractCommand.LevyAmendmentSource.Bulk
            }, testableMessageHandlerContext).Wait();

            // assert
            roatpRepositoryMock.Verify(r => r.IsProviderOnRoatp(It.IsAny<string>(), It.IsAny<ConnectionInfo>()), Times.Never,
                "IsProviderOnRoatp method was incorrectly called");
            Assert.AreEqual(1, testableMessageHandlerContext.SentMessages.Length, "The wrong number of messages were sent");
            Assert.IsTrue(testableMessageHandlerContext.SentMessages[0].Message is IssueCrmNotificationCommand, "The sent message is the wrong type");

            var sentMessage = (IssueCrmNotificationCommand)testableMessageHandlerContext.SentMessages[0].Message;
            Assert.AreEqual(ClosureNotificationText, sentMessage.NotificationText, "Incorrect notification text");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendLevyContractHandler_ShouldSendNotificationCommand_WithTerminationNotificationText_ForApprovedAwaitingTerminationInitiationApprovalContractOnRoatpAndBulkType()
        {
            // arrange
            Mock<IRoatpProviderRepository> roatpRepositoryMock = new Mock<IRoatpProviderRepository>();
            roatpRepositoryMock.Setup(m => m.IsProviderOnRoatp(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(Task.FromResult(true));

            IAmendLevyContractService amendLevyContractService = new AmendLevyContractService(roatpRepositoryMock.Object, Mock.Of<ICrmContractRepository>(), Mock.Of<ILogger>());

            var handler = new AmendLevyContractHandler(
                Mock.Of<ILogger>(),
                amendLevyContractService,
                Mock.Of<ISessionConnectionFactory>(),
                Mock.Of<ICrmContractRepository>());

            TestableMessageHandlerContext testableMessageHandlerContext = new TestableMessageHandlerContext();

            // act
            handler.Handle(new AmendLevyContractCommand
            {
                ContractInformation = new ContractInformation(
                    contractNumber: "",
                    masterContractNumber: "",
                    contractVersionNumber: 1,
                    subVersionNumber: 0,
                    ukprn: "",
                    contractStatus: ContractStatus.Approved,
                    contractSubStatus: ContractSubStatus.AwaitingTerminationInitiationApproval),
                AmendmentSource = AmendLevyContractCommand.LevyAmendmentSource.Bulk
            }, testableMessageHandlerContext).Wait();

            // assert
            roatpRepositoryMock.Verify(r => r.IsProviderOnRoatp(It.IsAny<string>(), It.IsAny<ConnectionInfo>()), Times.Never,
                "IsProviderOnRoatp method was incorrectly called");
            Assert.AreEqual(1, testableMessageHandlerContext.SentMessages.Length, "The wrong number of messages were sent");
            Assert.IsTrue(testableMessageHandlerContext.SentMessages[0].Message is IssueCrmNotificationCommand, "The sent message is the wrong type");

            var sentMessage = (IssueCrmNotificationCommand)testableMessageHandlerContext.SentMessages[0].Message;
            Assert.AreEqual(TerminationNotificationText, sentMessage.NotificationText, "Incorrect notification text");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendLevyContractHandler_ShouldDoNothing_ForVariousOtherStatusSubStatusAndBulkType()
        {
            // arrange
            Mock<IRoatpProviderRepository> roatpRepositoryMock = new Mock<IRoatpProviderRepository>();
            roatpRepositoryMock.Setup(m => m.IsProviderOnRoatp(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(Task.FromResult(false));

            IAmendLevyContractService amendLevyContractService = new AmendLevyContractService(roatpRepositoryMock.Object, Mock.Of<ICrmContractRepository>(), Mock.Of<ILogger>());

            var handler = new AmendLevyContractHandler(
                Mock.Of<ILogger>(),
                amendLevyContractService,
                Mock.Of<ISessionConnectionFactory>(),
                Mock.Of<ICrmContractRepository>());

            TestableMessageHandlerContext testableMessageHandlerContext = new TestableMessageHandlerContext();

            // act
            handler.Handle(new AmendLevyContractCommand
            {
                ContractInformation = new ContractInformation(
                    contractNumber: "",
                    masterContractNumber: "",
                    contractVersionNumber: 1,
                    subVersionNumber: 0,
                    ukprn: "",
                    contractStatus: ContractStatus.Other,
                    contractSubStatus: ContractSubStatus.Other),
                AmendmentSource = AmendLevyContractCommand.LevyAmendmentSource.Bulk
            }, testableMessageHandlerContext).Wait();
            // assert
            Assert.AreEqual(0, testableMessageHandlerContext.SentMessages.Length, "The message was incorrectly sent");

            // act
            handler.Handle(new AmendLevyContractCommand
            {
                ContractInformation = new ContractInformation(
                    contractNumber: "",
                    masterContractNumber: "",
                    contractVersionNumber: 1,
                    subVersionNumber: 0,
                    ukprn: "",
                    contractStatus: ContractStatus.Approved,
                    contractSubStatus: ContractSubStatus.Other),
                AmendmentSource = AmendLevyContractCommand.LevyAmendmentSource.Bulk
            }, testableMessageHandlerContext).Wait();
            // assert
            Assert.AreEqual(0, testableMessageHandlerContext.SentMessages.Length, "The message was incorrectly sent");

            // act
            handler.Handle(new AmendLevyContractCommand
            {
                ContractInformation = new ContractInformation(
                    contractNumber: "",
                    masterContractNumber: "",
                    contractVersionNumber: 1,
                    subVersionNumber: 0,
                    ukprn: "",
                    contractStatus: ContractStatus.Other,
                    contractSubStatus: ContractSubStatus.Approved),
                AmendmentSource = AmendLevyContractCommand.LevyAmendmentSource.Bulk
            }, testableMessageHandlerContext).Wait();
            // assert
            Assert.AreEqual(0, testableMessageHandlerContext.SentMessages.Length, "The message was incorrectly sent");
        }

        // SINGLE
        [TestMethod, TestCategory("UnitTest")]
        public void AmendLevyContractHandler_ShouldSendIncrementContractVersionCommand_ForApprovedApprovedAndSingleType()
        {
            // arrange
            Mock<ICrmContractRepository> crmContractRepositoryMock = new Mock<ICrmContractRepository>();
            IAmendLevyContractService amendLevyContractService = new AmendLevyContractService(Mock.Of<IRoatpProviderRepository>(), crmContractRepositoryMock.Object, Mock.Of<ILogger>());

            var contractInformation = new ContractInformation(
                contractNumber: "",
                masterContractNumber: "",
                contractVersionNumber: 1,
                subVersionNumber: 0,
                ukprn: "",
                contractStatus: ContractStatus.Approved,
                contractSubStatus: ContractSubStatus.Approved);

            crmContractRepositoryMock.Setup(
                    c => c.GetContractStatusIfContractIsLatest(contractInformation.ContractNumber, contractInformation.ContractVersionNumber, contractInformation.SubVersionNumber))
                .Returns(new ContractStatusInfo(contractInformation.ContractStatus, contractInformation.ContractSubStatus));

            var handler = new AmendLevyContractHandler(
                Mock.Of<ILogger>(),
                amendLevyContractService,
                Mock.Of<ISessionConnectionFactory>(),
                Mock.Of<ICrmContractRepository>());
            TestableMessageHandlerContext testableMessageHandlerContext = new TestableMessageHandlerContext();

            // act
            handler.Handle(new AmendLevyContractCommand
            {
                ContractInformation = contractInformation,
                AmendmentSource = AmendLevyContractCommand.LevyAmendmentSource.Single
            }, testableMessageHandlerContext).Wait();

            // assert
            Assert.AreEqual(1, testableMessageHandlerContext.SentMessages.Length, "The wrong number of messages were sent");
            Assert.IsTrue(testableMessageHandlerContext.SentMessages[0].Message is IncrementContractVersionCommand, "The sent message is the wrong type");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendLevyContractHandler_ShouldSendIncrementContractVersionCommand_ForApprovedUnderTerminationAndSingleType()
        {
            // arrange
            Mock<ICrmContractRepository> crmContractRepositoryMock = new Mock<ICrmContractRepository>();
            IAmendLevyContractService amendLevyContractService = new AmendLevyContractService(Mock.Of<IRoatpProviderRepository>(), crmContractRepositoryMock.Object, Mock.Of<ILogger>());

            var contractInformation = new ContractInformation(
                contractNumber: "",
                masterContractNumber: "",
                contractVersionNumber: 1,
                subVersionNumber: 0,
                ukprn: "",
                contractStatus: ContractStatus.Approved,
                contractSubStatus: ContractSubStatus.UnderTermination);

            crmContractRepositoryMock.Setup(
                    c => c.GetContractStatusIfContractIsLatest(contractInformation.ContractNumber, contractInformation.ContractVersionNumber, contractInformation.SubVersionNumber))
                .Returns(new ContractStatusInfo(contractInformation.ContractStatus, contractInformation.ContractSubStatus));

            var handler = new AmendLevyContractHandler(
                Mock.Of<ILogger>(),
                amendLevyContractService,
                Mock.Of<ISessionConnectionFactory>(),
                Mock.Of<ICrmContractRepository>());
            TestableMessageHandlerContext testableMessageHandlerContext = new TestableMessageHandlerContext();

            // act
            handler.Handle(new AmendLevyContractCommand
            {
                ContractInformation = contractInformation,
                AmendmentSource = AmendLevyContractCommand.LevyAmendmentSource.Single
            }, testableMessageHandlerContext).Wait();

            // assert
            Assert.AreEqual(1, testableMessageHandlerContext.SentMessages.Length, "The wrong number of messages were sent");
            Assert.IsTrue(testableMessageHandlerContext.SentMessages[0].Message is IncrementContractVersionCommand, "The sent message is the wrong type");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendLevyContractHandler_ShouldSendPreIncrementWithdrawCommand_ForDraftPublishedtoProviderAndSingleType()
        {
            // arrange
            Mock<ICrmContractRepository> crmContractRepositoryMock = new Mock<ICrmContractRepository>();
            IAmendLevyContractService amendLevyContractService = new AmendLevyContractService(Mock.Of<IRoatpProviderRepository>(), crmContractRepositoryMock.Object, Mock.Of<ILogger>());

            var contractInformation = new ContractInformation(
                contractNumber: "",
                masterContractNumber: "",
                contractVersionNumber: 1,
                subVersionNumber: 0,
                ukprn: "",
                contractStatus: ContractStatus.Draft,
                contractSubStatus: ContractSubStatus.PublishedtoProvider);

            crmContractRepositoryMock.Setup(
                    c => c.GetContractStatusIfContractIsLatest(contractInformation.ContractNumber, contractInformation.ContractVersionNumber, contractInformation.SubVersionNumber))
                .Returns(new ContractStatusInfo(contractInformation.ContractStatus, contractInformation.ContractSubStatus));

            var handler = new AmendLevyContractHandler(
                Mock.Of<ILogger>(),
                amendLevyContractService,
                Mock.Of<ISessionConnectionFactory>(),
                Mock.Of<ICrmContractRepository>());

            TestableMessageHandlerContext testableMessageHandlerContext = new TestableMessageHandlerContext();

            // act
            handler.Handle(new AmendLevyContractCommand
            {
                ContractInformation = contractInformation,
                AmendmentSource = AmendLevyContractCommand.LevyAmendmentSource.Single
            }, testableMessageHandlerContext).Wait();

            // assert
            Assert.AreEqual(1, testableMessageHandlerContext.SentMessages.Length, "The wrong number of messages were sent");
            Assert.IsTrue(testableMessageHandlerContext.SentMessages[0].Message is PreIncrementWithdrawalCommand, "The sent message is the wrong type");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendLevyContractHandler_ShouldSendNotificationCommand_WithClosureNotificationText_ForApprovedClosureInitiationInProgressContractAndSingleType()
        {
            // arrange
            Mock<ICrmContractRepository> crmContractRepositoryMock = new Mock<ICrmContractRepository>();
            IAmendLevyContractService amendLevyContractService = new AmendLevyContractService(Mock.Of<IRoatpProviderRepository>(), crmContractRepositoryMock.Object, Mock.Of<ILogger>());

            var contractInformation = new ContractInformation(
                contractNumber: "",
                masterContractNumber: "",
                contractVersionNumber: 1,
                subVersionNumber: 0,
                ukprn: "",
                contractStatus: ContractStatus.Approved,
                contractSubStatus: ContractSubStatus.ClosureInitiationinProgress);

            crmContractRepositoryMock.Setup(
                    c => c.GetContractStatusIfContractIsLatest(contractInformation.ContractNumber, contractInformation.ContractVersionNumber, contractInformation.SubVersionNumber))
                .Returns(new ContractStatusInfo(contractInformation.ContractStatus, contractInformation.ContractSubStatus));

            var handler = new AmendLevyContractHandler(
                Mock.Of<ILogger>(),
                amendLevyContractService,
                Mock.Of<ISessionConnectionFactory>(),
                Mock.Of<ICrmContractRepository>());

            TestableMessageHandlerContext testableMessageHandlerContext = new TestableMessageHandlerContext();

            // act
            handler.Handle(new AmendLevyContractCommand
            {
                ContractInformation = contractInformation,
                AmendmentSource = AmendLevyContractCommand.LevyAmendmentSource.Single
            }, testableMessageHandlerContext).Wait();

            // assert
            Assert.AreEqual(1, testableMessageHandlerContext.SentMessages.Length, "The wrong number of messages were sent");
            Assert.IsTrue(testableMessageHandlerContext.SentMessages[0].Message is IssueCrmNotificationCommand, "The sent message is the wrong type");

            var sentMessage = (IssueCrmNotificationCommand)testableMessageHandlerContext.SentMessages[0].Message;
            Assert.AreEqual(ClosureNotificationText, sentMessage.NotificationText, "Incorrect notification text");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendLevyContractHandler_ShouldSendNotificationCommand_WithClosureNotificationText_ForApprovedAwaitingClosureApprovalContractAndSingleType()
        {
            // arrange
            Mock<ICrmContractRepository> crmContractRepositoryMock = new Mock<ICrmContractRepository>();
            IAmendLevyContractService amendLevyContractService = new AmendLevyContractService(Mock.Of<IRoatpProviderRepository>(), crmContractRepositoryMock.Object, Mock.Of<ILogger>());

            var contractInformation = new ContractInformation(
                contractNumber: "",
                masterContractNumber: "",
                contractVersionNumber: 1,
                subVersionNumber: 0,
                ukprn: "",
                contractStatus: ContractStatus.Approved,
                contractSubStatus: ContractSubStatus.AwaitingClosureApproval);

            crmContractRepositoryMock.Setup(
                    c => c.GetContractStatusIfContractIsLatest(contractInformation.ContractNumber, contractInformation.ContractVersionNumber, contractInformation.SubVersionNumber))
                .Returns(new ContractStatusInfo(contractInformation.ContractStatus, contractInformation.ContractSubStatus));

            var handler = new AmendLevyContractHandler(
                Mock.Of<ILogger>(),
                amendLevyContractService, 
                Mock.Of<ISessionConnectionFactory>(),
                Mock.Of<ICrmContractRepository>());

            TestableMessageHandlerContext testableMessageHandlerContext = new TestableMessageHandlerContext();

            // act
            handler.Handle(new AmendLevyContractCommand
            {
                ContractInformation = contractInformation,
                AmendmentSource = AmendLevyContractCommand.LevyAmendmentSource.Single
            }, testableMessageHandlerContext).Wait();

            // assert
            Assert.AreEqual(1, testableMessageHandlerContext.SentMessages.Length, "The wrong number of messages were sent");
            Assert.IsTrue(testableMessageHandlerContext.SentMessages[0].Message is IssueCrmNotificationCommand, "The sent message is the wrong type");

            var sentMessage = (IssueCrmNotificationCommand)testableMessageHandlerContext.SentMessages[0].Message;
            Assert.AreEqual(ClosureNotificationText, sentMessage.NotificationText, "Incorrect notification text");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendLevyContractHandler_ShouldSendNotificationCommand_WithTerminationNotificationText_ForApprovedAwaitingTerminationInitiationApprovalContractAndSingleType()
        {
            // arrange
            Mock<ICrmContractRepository> crmContractRepositoryMock = new Mock<ICrmContractRepository>();
            IAmendLevyContractService amendLevyContractService = new AmendLevyContractService(Mock.Of<IRoatpProviderRepository>(), crmContractRepositoryMock.Object, Mock.Of<ILogger>());

            var contractInformation = new ContractInformation(
                contractNumber: "",
                masterContractNumber: "",
                contractVersionNumber: 1,
                subVersionNumber: 0,
                ukprn: "",
                contractStatus: ContractStatus.Approved,
                contractSubStatus: ContractSubStatus.AwaitingTerminationInitiationApproval);

            crmContractRepositoryMock.Setup(
                    c => c.GetContractStatusIfContractIsLatest(contractInformation.ContractNumber, contractInformation.ContractVersionNumber, contractInformation.SubVersionNumber))
                .Returns(new ContractStatusInfo(contractInformation.ContractStatus, contractInformation.ContractSubStatus));

            var handler = new AmendLevyContractHandler(
                Mock.Of<ILogger>(),
                amendLevyContractService,
                Mock.Of<ISessionConnectionFactory>(),
                Mock.Of<ICrmContractRepository>());

            TestableMessageHandlerContext testableMessageHandlerContext = new TestableMessageHandlerContext();

            // act
            handler.Handle(new AmendLevyContractCommand
            {
                ContractInformation = contractInformation,
                AmendmentSource = AmendLevyContractCommand.LevyAmendmentSource.Single
            }, testableMessageHandlerContext).Wait();

            // assert
            Assert.AreEqual(1, testableMessageHandlerContext.SentMessages.Length, "The wrong number of messages were sent");
            Assert.IsTrue(testableMessageHandlerContext.SentMessages[0].Message is IssueCrmNotificationCommand, "The sent message is the wrong type");

            var sentMessage = (IssueCrmNotificationCommand)testableMessageHandlerContext.SentMessages[0].Message;
            Assert.AreEqual(TerminationNotificationText, sentMessage.NotificationText, "Incorrect notification text");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendLevyContractHandler_ShouldDoNothing_ForVariousOtherStatusSubStatusAndSingleType()
        {
            // arrange
            Mock<ICrmContractRepository> crmContractRepositoryMock = new Mock<ICrmContractRepository>();
            IAmendLevyContractService amendLevyContractService = new AmendLevyContractService(Mock.Of<IRoatpProviderRepository>(), crmContractRepositoryMock.Object, Mock.Of<ILogger>());

            var handler = new AmendLevyContractHandler(
                Mock.Of<ILogger>(),
                amendLevyContractService,
                Mock.Of<ISessionConnectionFactory>(),
                Mock.Of<ICrmContractRepository>());

            List<ContractStatusInfo> contractStatusInfos = new List<ContractStatusInfo>
            {
                new ContractStatusInfo(ContractStatus.Other, ContractSubStatus.Other),
                new ContractStatusInfo(ContractStatus.Approved, ContractSubStatus.Other),
                new ContractStatusInfo(ContractStatus.Other, ContractSubStatus.Approved),
                new ContractStatusInfo(ContractStatus.Other, ContractSubStatus.ClosureinProgress),
                new ContractStatusInfo(ContractStatus.Other, ContractSubStatus.Closed)
            };

            crmContractRepositoryMock.SetupSequence(c => c.GetContractStatusIfContractIsLatest(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>()))
                .Returns(contractStatusInfos[0])
                .Returns(contractStatusInfos[1])
                .Returns(contractStatusInfos[2])
                .Returns(contractStatusInfos[3])
                .Returns(contractStatusInfos[4]);

            TestableMessageHandlerContext testableMessageHandlerContext = new TestableMessageHandlerContext();

            // act
            contractStatusInfos.ForEach(c => handler.Handle(new AmendLevyContractCommand
            {
                ContractInformation = new ContractInformation(
                    contractNumber: "",
                    masterContractNumber: "",
                    contractVersionNumber: 1,
                    subVersionNumber: 0,
                    ukprn: "",
                    contractStatus: c.ContractStatus,
                    contractSubStatus: c.ContractSubStatus),
                AmendmentSource = AmendLevyContractCommand.LevyAmendmentSource.Single
            }, testableMessageHandlerContext).Wait());

            // assert
            Assert.AreEqual(0, testableMessageHandlerContext.SentMessages.Length, "At least one message was incorrectly sent");
        }

        // MISC
        [TestMethod, TestCategory("UnitTest")]
        public void AmendLevyContractHandler_ShouldResolve()
        {
            using (IWindsorContainer container = new WindsorContainer().Install(new WindsorInstaller(new LoggerFactory())))
            {
                container.Register(Component.For<Microsoft.Xrm.Sdk.IOrganizationService>().Instance(Mock.Of<Microsoft.Xrm.Sdk.IOrganizationService>()).IsDefault());
                container.Register(Component.For<AmendLevyContractHandler>());
                container.BeginScope();

                var handler = container.Resolve<AmendLevyContractHandler>();

                Assert.IsNotNull(handler, "Handler failed to resolve");
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task AmendLevyContractHandler_WhenOtherAmendmentSourceType_ShouldThrowExceptionWithCorrectMessage()
        {
            // arrange
            Mock<ICrmContractRepository> crmContractRepositoryMock = new Mock<ICrmContractRepository>();
            IAmendLevyContractService amendLevyContractService = new AmendLevyContractService(Mock.Of<IRoatpProviderRepository>(), crmContractRepositoryMock.Object, Mock.Of<ILogger>());

            var handler = new AmendLevyContractHandler(
                Mock.Of<ILogger>(),
                amendLevyContractService,
                Mock.Of<ISessionConnectionFactory>(),
                Mock.Of<ICrmContractRepository>());

            ArgumentException expectedException = null;
            TestableMessageHandlerContext testableMessageHandlerContext = new TestableMessageHandlerContext();

            // act
            try
            {
                await handler.Handle(new AmendLevyContractCommand
                {
                    ContractInformation = new ContractInformation(
                        contractNumber: "",
                        masterContractNumber: "",
                        contractVersionNumber: 1,
                        subVersionNumber: 0,
                        ukprn: "",
                        contractStatus: ContractStatus.Other,
                        contractSubStatus: ContractSubStatus.Other),
                    AmendmentSource = (AmendLevyContractCommand.LevyAmendmentSource)2
                }, testableMessageHandlerContext);
            }
            catch (ArgumentException argException)
            {
                expectedException = argException;
            }

            // assert
            Assert.AreEqual(0, testableMessageHandlerContext.SentMessages.Length, "The message was incorrectly sent");
            Assert.IsNotNull(expectedException, "ArgumentException was not thrown when expected");
            Assert.AreEqual($"Unexpected LevyAmendmentSource with a value of 2 was passed in", expectedException.Message, "The argument exception had an unexpected message");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendLevyContractHandler_ShouldPassTheAmendmentTypeToTheIncrementCommand_WhenAmendmentTypeIsNotification()
        {
            // arrange
            Mock<IAmendLevyContractService> amendLevyContractServiceMock = new Mock<IAmendLevyContractService>();
            amendLevyContractServiceMock.Setup(s => s.AmendSingleLevyContract(It.IsAny<ContractInformation>(),
                    It.IsAny<AmendmentType>(),It.IsAny<bool>(), It.IsAny<bool>()))
                .Returns(new AmendBulkComponentLevyContractResult(
                    incrementContractVersionInfo: new ContractInformation(), preIncrementContractVersionInfo: null,
                    notificationInformationInfo: null));
           
            var handler = new AmendLevyContractHandler(
                Mock.Of<ILogger>(),
                amendLevyContractServiceMock.Object,
                Mock.Of<ISessionConnectionFactory>(),
                Mock.Of<ICrmContractRepository>());

            TestableMessageHandlerContext testableMessageHandlerContext = new TestableMessageHandlerContext();

            // act
            handler.Handle(new AmendLevyContractCommand
            {
                ContractInformation = new ContractInformation(
                    contractNumber: "",
                    masterContractNumber: "",
                    contractVersionNumber: 1,
                    subVersionNumber: 0,
                    ukprn: "",
                    contractStatus: ContractStatus.Approved,
                    contractSubStatus: ContractSubStatus.Approved),
                AmendmentSource = AmendLevyContractCommand.LevyAmendmentSource.Single,
                AmendmentType = AmendmentType.Notification
            }, testableMessageHandlerContext).Wait();

            // assert
            Assert.AreEqual(1, testableMessageHandlerContext.SentMessages.Length, "At least one message was incorrectly sent");
            var command = testableMessageHandlerContext.SentMessages.Single().Message as IncrementContractVersionCommand;
            Assert.IsNotNull(command, "The message sent is not an IncrementContractVersionCommand");
            Assert.AreEqual(AmendmentType.Notification, command.AmendmentType, "The amendmentType is not correct");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendLevyContractHandler_ShouldPassTheAmendmentTypeToTheIncrementCommand_WhenAmendmentTypeIsVariation()
        {
            // arrange
            Mock<IAmendLevyContractService> amendLevyContractServiceMock = new Mock<IAmendLevyContractService>();
            amendLevyContractServiceMock.Setup(s => s.AmendSingleLevyContract(It.IsAny<ContractInformation>(),
                It.IsAny<AmendmentType>(), It.IsAny<bool>(), It.IsAny<bool>())).Returns(
                new AmendBulkComponentLevyContractResult(
                    incrementContractVersionInfo: new ContractInformation(), preIncrementContractVersionInfo: null,
                    notificationInformationInfo: null));

            var handler = new AmendLevyContractHandler(
                Mock.Of<ILogger>(),
                amendLevyContractServiceMock.Object,
                Mock.Of<ISessionConnectionFactory>(),
                Mock.Of<ICrmContractRepository>());

            TestableMessageHandlerContext testableMessageHandlerContext = new TestableMessageHandlerContext();

            // act
            handler.Handle(new AmendLevyContractCommand
            {
                ContractInformation = new ContractInformation(
                    contractNumber: "",
                    masterContractNumber: "",
                    contractVersionNumber: 1,
                    subVersionNumber: 0,
                    ukprn: "",
                    contractStatus: ContractStatus.Approved,
                    contractSubStatus: ContractSubStatus.Approved),
                AmendmentSource = AmendLevyContractCommand.LevyAmendmentSource.Single,
                AmendmentType = AmendmentType.Variation
            }, testableMessageHandlerContext).Wait();

            // assert
            Assert.AreEqual(1, testableMessageHandlerContext.SentMessages.Length, "At least one message was incorrectly sent");
            var command = testableMessageHandlerContext.SentMessages.Single().Message as IncrementContractVersionCommand;
            Assert.IsNotNull(command, "The message sent is not an IncrementContractVersionCommand");
            Assert.AreEqual(AmendmentType.Variation, command.AmendmentType, "The amendmentType is not correct");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendLevyContractHandler_ShouldPassTheShouldAddPayableNonLevyAllocationPropertyToTheIncrementCommand_WhenShouldAddPayableNonLevyAllocationIsTrue()
        {
            // arrange
            Mock<IAmendLevyContractService> amendLevyContractServiceMock = new Mock<IAmendLevyContractService>();
            amendLevyContractServiceMock
                .Setup(m => m.AmendSingleLevyContract(It.IsAny<ContractInformation>(),
                    It.IsAny<AmendmentType>(), It.IsAny<bool>(), It.IsAny<bool>()))
                .Returns(new AmendBulkComponentLevyContractResult(new ContractInformation(), null, null));

            AmendLevyContractHandler handler = new AmendLevyContractHandler(
                Mock.Of<ILogger>(),
                amendLevyContractServiceMock.Object,
                Mock.Of<ISessionConnectionFactory>(),
                Mock.Of<ICrmContractRepository>());

            AmendLevyContractCommand command = new AmendLevyContractCommand
            {
                AmendmentSource = AmendLevyContractCommand.LevyAmendmentSource.Single,
                ShouldAddPayableNonLevyAllocation = true,
                ContractInformation = new ContractInformation()
            };

            TestableMessageHandlerContext context = new TestableMessageHandlerContext();

            // act
            handler.Handle(command, context).Wait();

            // assert
            IncrementContractVersionCommand sentCommand = context.SentMessages.Select(sm => sm.Message).OfType<IncrementContractVersionCommand>().Single();

            Assert.IsTrue(sentCommand.ShouldAddPayableNonLevyAllocation);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendLevyContractHandler_ShouldPassTheShouldAddPayableNonLevyAllocationPropertyToTheIncrementCommand_WhenShouldAddPayableNonLevyAllocationIsFalse()
        {
            // arrange
            Mock<IAmendLevyContractService> amendLevyContractServiceMock = new Mock<IAmendLevyContractService>();
            amendLevyContractServiceMock
                .Setup(m => m.AmendSingleLevyContract(It.IsAny<ContractInformation>(),
                    It.IsAny<AmendmentType>(), It.IsAny<bool>(), It.IsAny<bool>()))
                .Returns(new AmendBulkComponentLevyContractResult(new ContractInformation(), null, null));

            AmendLevyContractHandler handler = new AmendLevyContractHandler(
                Mock.Of<ILogger>(),
                amendLevyContractServiceMock.Object,
                Mock.Of<ISessionConnectionFactory>(),
                Mock.Of<ICrmContractRepository>());

            AmendLevyContractCommand command = new AmendLevyContractCommand
            {
                AmendmentSource = AmendLevyContractCommand.LevyAmendmentSource.Single,
                ShouldAddPayableNonLevyAllocation = false,
                ContractInformation = new ContractInformation()
            };

            TestableMessageHandlerContext context = new TestableMessageHandlerContext();

            // act
            handler.Handle(command, context).Wait();

            // assert
            IncrementContractVersionCommand sentCommand = context.SentMessages.Select(sm => sm.Message).OfType<IncrementContractVersionCommand>().Single();

            Assert.IsFalse(sentCommand.ShouldAddPayableNonLevyAllocation);
        }


        [TestMethod, TestCategory("UnitTest")]
        public void AmendLevyContractHandler_ShouldPassTheShouldAddPayableNonLevyAllocationPropertyToThePreIncrementWithdrawalCommand()
        {
            // arrange
            Mock<IAmendLevyContractService> amendLevyContractServiceMock = new Mock<IAmendLevyContractService>();
            amendLevyContractServiceMock
                .Setup(m => m.AmendSingleLevyContract(It.IsAny<ContractInformation>(), It.IsAny<AmendmentType>(), It.IsAny<bool>(), It.IsAny<bool>()))
                .Returns(new AmendBulkComponentLevyContractResult(null, new ContractInformation(), null));

            AmendLevyContractHandler handler = new AmendLevyContractHandler(
                Mock.Of<ILogger>(),
                amendLevyContractServiceMock.Object,
                Mock.Of<ISessionConnectionFactory>(),
                Mock.Of<ICrmContractRepository>());

            AmendLevyContractCommand command = new AmendLevyContractCommand
            {
                ContractInformation = new ContractInformation(),
                AmendmentSource = AmendLevyContractCommand.LevyAmendmentSource.Single,
                ShouldAddPayableNonLevyAllocation = true
            };

            TestableMessageHandlerContext context = new TestableMessageHandlerContext();

            // act
            handler.Handle(command, context).Wait();

            // assert
            PreIncrementWithdrawalCommand sentCommand = context.SentMessages.Select(sm => sm.Message).OfType<PreIncrementWithdrawalCommand>().Single();

            Assert.IsTrue(sentCommand.ShouldAddPayableNonLevyAllocationToPostWithdrawalAmendment);
        }

    }
}