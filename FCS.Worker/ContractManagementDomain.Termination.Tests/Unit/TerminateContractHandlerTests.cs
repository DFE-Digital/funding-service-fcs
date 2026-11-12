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
    using NServiceBus.Testing;
    using Services;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.ContractManagementService.Common.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;

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
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<TerminateContractHandler>().ImplementedBy<TerminateContractHandler>());
            _ = container.Register(Component.For<Microsoft.Xrm.Sdk.IOrganizationService>().Instance(Mock.Of<Microsoft.Xrm.Sdk.IOrganizationService>()).IsDefault());

            _ = container.BeginScope();

            return container.Resolve<TerminateContractHandler>();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TerminateContractHandler_WhenValidateFails_ShouldSendIssueCrmNotificationCommand()
        {
            // Arramge
            const string contractNumber = "Contract1";
            const int versionNumber = 1;
            const int subVersionNumber = 0;

            var terminateContractInfo = new TerminateContractInfo(isLatest: false,
                contractTerminationDate: DateTime.Now,
                contractIdentifier: new ContractIdentifier(contractNumber, versionNumber, subVersionNumber),
                hasOutStandingPayments: null,
                isMonthEndRunning: null,
                currentDate: DateTime.Now);

            Mock<ITerminateContractInfoCreator> terminateContractInfoCreatorMock = new Mock<ITerminateContractInfoCreator>();
            _ = terminateContractInfoCreatorMock.Setup(tcic => tcic.CreateTerminateContractInfo(It.IsAny<ContractIdentifier>(), It.IsAny<ConnectionInfo>()))
                .Returns(terminateContractInfo);

            Mock<ITerminateContractValidationService> terminateContractValidationServiceMock = new Mock<ITerminateContractValidationService>();
            _ = terminateContractValidationServiceMock.Setup(tcvs => tcvs.Validate(terminateContractInfo))
                .Returns(new Either<RejectionReason, TerminateContractInfo>(
                                new RejectionReason(
                                    "Contract Termination Date must be in the past",
                                    RejectionReason.Why.TerminationDateIsNotValid)));

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

            TerminateContractCommand command = new TerminateContractCommand
            {
                ContractNumber = contractNumber,
                SubVersionNumber = versionNumber,
                VersionNumber = subVersionNumber
            };

            TestableMessageHandlerContext testableMessageHandlerContext = new TestableMessageHandlerContext();

            // Act
            _ = handler.Handle(command, testableMessageHandlerContext);

            // Assert
            Assert.AreEqual(1, testableMessageHandlerContext.PublishedMessages.Length, "The wrong number of messages were sent");
            Assert.IsTrue(testableMessageHandlerContext.PublishedMessages[0].Message is ContractTerminationFailedEvent, "The sent message is the wrong type");

            ContractTerminationFailedEvent message = (ContractTerminationFailedEvent) testableMessageHandlerContext.PublishedMessages[0].Message;
            Assert.AreEqual(message.ContractNumber, contractNumber, "Incorrect data in sent ContractTerminationFailedEvent message");
        }
    }
}
