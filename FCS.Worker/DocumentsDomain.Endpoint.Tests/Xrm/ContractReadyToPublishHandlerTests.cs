namespace DocumentsDomain.Endpoint.Tests.Xrm
{
    using System.Collections.Generic;
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Endpoint.Xrm;
    using Endpoint.Xrm.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractApproval;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class ContractReadyToPublishHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractReadyToPublishHandler_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<ContractReadyToPublishHandler>());
            container.BeginScope();

            // act
            container.Resolve<ContractReadyToPublishHandler>();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractReadyToPublishHandler_ShouldUpdateCrmWithManualApprovalResponse()
        {
            // arrange
            Mock<IXrmDocumentManager> xrmDocumentManagerMock = new Mock<IXrmDocumentManager>();

            ContractReadyToPublishHandler handler = new ContractReadyToPublishHandler(Mock.Of<ILogger>(), xrmDocumentManagerMock.Object);

            contractType contract = new contractType();
                Contract masterContract = new Contract
            {
                contracts = new List<contractType>
                {
                    contract
                }
            };

            // act
            handler.Handle(new ContractReadyToPublishEvent
            {
                CorporateContract = masterContract
            }, new TestableMessageHandlerContext()).Wait();

            // assert
            xrmDocumentManagerMock.Verify(m => m.UpdateContractPublishedToProviderManualApproval(contract), Times.Once());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractReadyToPublishHandler_ShouldUpdateCrmWithElectronicApprovalResponse()
        {
            // arrange
            Mock<IXrmDocumentManager> xrmDocumentManagerMock = new Mock<IXrmDocumentManager>();

            ContractReadyToPublishHandler handler = new ContractReadyToPublishHandler(Mock.Of<ILogger>(), xrmDocumentManagerMock.Object);

            contractType contract = new contractType();
            Contract masterContract = new Contract
            {
                contracts = new List<contractType>
                {
                    contract
                }
            };

            // act
            handler.Handle(new ContractReadyToPublishEvent
            {
                CorporateContract = masterContract,
                ContractApprovalType = ContractApprovalType.Electronic
            }, new TestableMessageHandlerContext()).Wait();

            // Assert
            xrmDocumentManagerMock.Verify(m => m.UpdateContractPublishedToProviderForElectronicApproval(contract), Times.Once(), "The handler should call Xrm (electronic approval)");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_ContractReadyToPublishEvent_UpdateCrmWithAutoApprovalResponse()
        {
            // arrange
            Mock<IXrmDocumentManager> xrmDocumentManagerMock = new Mock<IXrmDocumentManager>();

            ContractReadyToPublishHandler handler = new ContractReadyToPublishHandler(Mock.Of<ILogger>(), xrmDocumentManagerMock.Object);

            contractType contract = new contractType
            {
                amendmentType = SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.amendmentType.Notification.ToString()
            };

            Contract masterContract = new Contract
            {
                contracts = new List<contractType>
                {
                    contract
                }
            };

            TestableMessageHandlerContext context = new TestableMessageHandlerContext();

            // act
            handler.Handle(new ContractReadyToPublishEvent
            {
                CorporateContract = masterContract,
                ContractApprovalType = ContractApprovalType.Electronic
            }, context).Wait();

            // assert
            xrmDocumentManagerMock.Verify(m => m.UpdateContractPublishedToProviderForAutoApproval(contract), Times.Once(), "The handler should call Xrm (auto approval)");

            Assert.AreEqual(1, context.PublishedMessages.Count(m => m.Message is ContractNotificationPublishedToProviderEvent), $"{nameof(ContractNotificationPublishedToProviderEvent)} was not published");
        }
    }
}
