namespace ContractManagementDomain.Termination.Tests.Unit
{
    using System;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using ContractManagement.DataStore.Services;
    using ContractManagementDomain.Termination.Handlers;
    using ContractManagementDomain.Termination.Repositories;
    using DTOs;
    using Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus;
    using Services;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.ContractManagementService.Common.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;
    using System.Threading.Tasks;
    using System.Collections.Generic;


    [TestClass]
    public class TerminateContractHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void TerminateContractHandler_ShouldResolve()
        {
            Assert.IsNotNull(GetTerminateContractHandlerFromContainer());
        }

        private static TerminateContractHandler GetTerminateContractHandlerFromContainer()
        {
            IWindsorContainer container = new WindsorContainer()
                .Install(new ContractManagementDomain.Termination.WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<ContractManagementDomain.Termination.Handlers.TerminateContractHandler>().ImplementedBy<TerminateContractHandler>());

            container.BeginScope();

            return container.Resolve<TerminateContractHandler>();
        }

        [TestMethod]
        [TestCategory("UnitTest")]
        public void TerminateContractHandler_WhenValidateFails_ShouldSendIssueCrmNotificationCommand()
        {
            // Arrange
            const string contractNumber = "Contract1";
            const int versionNumber = 1;
            const int subVersionNumber = 0;

            var terminateContractInfo = new TerminateContractInfo(
                isLatest: false,
                contractTerminationDate: DateTime.Now,
                contractIdentifier: new ContractIdentifier(
                    contractNumber,
                    versionNumber,
                    subVersionNumber),
                hasOutStandingPayments: null,
                isMonthEndRunning: null,
                currentDate: DateTime.Now);

            Mock<ITerminateContractInfoCreator> terminateContractInfoCreatorMock =
                new Mock<ITerminateContractInfoCreator>();

            terminateContractInfoCreatorMock
                .Setup(tcic => tcic.CreateTerminateContractInfo(
                    It.IsAny<ContractIdentifier>(),
                    It.IsAny<ConnectionInfo>()))
                .Returns(terminateContractInfo);

            Mock<ITerminateContractValidationService> terminateContractValidationServiceMock =
                new Mock<ITerminateContractValidationService>();

            terminateContractValidationServiceMock
                .Setup(tcvs => tcvs.Validate(terminateContractInfo))
                .Returns(
                    new Either<RejectionReason, TerminateContractInfo>(
                        new RejectionReason(
                            "Contract Termination Date must be in the past",
                            RejectionReason.Why.TerminationDateIsNotValid)));

            var publishedMessages = new System.Collections.Generic.List<object>();

            var messageHandlerContextMock =
                new Mock<IMessageHandlerContext>();

            messageHandlerContextMock
                .Setup(x => x.Publish(
                    It.IsAny<object>(),
                    It.IsAny<PublishOptions>()))
                .Callback<object, PublishOptions>((message, options) =>
                {
                    publishedMessages.Add(message);
                })
                .Returns(Task.CompletedTask);

            TerminateContractHandler handler =
                new TerminateContractHandler(
                    Mock.Of<ILogger>(),
                    terminateContractInfoCreatorMock.Object,
                    terminateContractValidationServiceMock.Object,
                    Mock.Of<ISessionConnectionFactory>(),
                    Mock.Of<ICrmContractRepository>(),
                    Mock.Of<IContractsManager>(),
                    Mock.Of<ILegalDeliverableService>(),
                    Mock.Of<IApprovalOnwardsContractAtomFeedService>(),
                    Mock.Of<ICorporateContractService>());

            TerminateContractCommand command =
                new TerminateContractCommand
                {
                    ContractNumber = contractNumber,
                    SubVersionNumber = versionNumber,
                    VersionNumber = subVersionNumber
                };

            // Act
            handler.Handle(command, messageHandlerContextMock.Object).Wait();

            // Assert
            Assert.AreEqual(
                1,
                publishedMessages.Count,
                "The wrong number of messages were sent");

            Assert.IsTrue(
                publishedMessages[0] is ContractTerminationFailedEvent,
                "The sent message is the wrong type");

            var message =
                (ContractTerminationFailedEvent)publishedMessages[0];

            Assert.AreEqual(
                contractNumber,
                message.ContractNumber,
                "Incorrect data in sent ContractTerminationFailedEvent message");
        }

    }
}
