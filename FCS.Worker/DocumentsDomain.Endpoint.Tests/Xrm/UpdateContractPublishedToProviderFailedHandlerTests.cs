namespace DocumentsDomain.Endpoint.Tests.Xrm
{
    using System;
    using System.Collections.Generic;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Endpoint.Xrm;
    using Endpoint.Xrm.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.DocumentsDomain.Common.Commands;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class UpdateContractPublishedToProviderFailedHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void UpdateContractPublishedToProviderFailedHandler_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<UpdateContractPublishedToProviderFailedHandler>());
            container.BeginScope();

            // act
            container.Resolve<UpdateContractPublishedToProviderFailedHandler>();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void UpdateContractPublishedToProviderFailedHandler_ShouldEnsureCorrectServiceResponseAndReasonIsPassedToUpdateContractStatusAndPublishedDateInCrm()
        {
            // arrange
            Mock<IXrmDocumentManager> xrmDocumentManagerMock = new Mock<IXrmDocumentManager>();

            UpdateContractPublishedToProviderFailedHandler handler = new UpdateContractPublishedToProviderFailedHandler(
                Mock.Of<ILogger>(), xrmDocumentManagerMock.Object);

            contractType contract = new contractType();
            contract masterContract = new contract
            {
                contracts = new List<contractType>
                {
                    contract
                }
            };

            const string failureReason = "Failed because of something";

            // act
            handler.Handle(new UpdateContractPublishedToProviderFailedCommand
            {
                CorporateContract = masterContract,
                ReasonForFailure = failureReason
            }, new TestableMessageHandlerContext()).Wait();

            // assert
            xrmDocumentManagerMock.Verify(m => m.UpdateContractPublishedToProviderFailed(contract, failureReason), Times.Once());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void UpdateContractPublishedToProviderFailedHandler_ShouldUpdateContractPublishedToProviderFailedCommand_LogsAndThrowErrorWhenNoContractInMessageAndDoesNotPerformUpdateContractPublishedToProvider()
        {
            // arrange
            Mock<ILogger> loggerMock = new Mock<ILogger>();
            Mock<IXrmDocumentManager> xrmDocumentManagerMock = new Mock<IXrmDocumentManager>();

            UpdateContractPublishedToProviderFailedHandler handler = new UpdateContractPublishedToProviderFailedHandler(
                loggerMock.Object, xrmDocumentManagerMock.Object);

            contract masterContract = new contract
            {
                contracts = new List<contractType>()
            };

            const string failureReason = "Failed because of something";

            try
            {
                // act
                handler.Handle(new UpdateContractPublishedToProviderFailedCommand
                {
                    CorporateContract = masterContract,
                    ReasonForFailure = failureReason
                }, new TestableMessageHandlerContext()).Wait();
            }
            catch (Exception e)
            {
                Assert.IsTrue(e is ArgumentNullException, $"{e.GetType()}");
                loggerMock.Verify(x => x.LogError(It.IsAny<int>(), e, e.Message), Times.Once, "Error was not logged");
            }

            xrmDocumentManagerMock.Verify(x => x.UpdateContractPublishedToProviderFailed(It.IsAny<contract>(), It.IsAny<string>()), Times.Never, $"{nameof(IXrmDocumentManager)} was called");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void UpdateContractPublishedToProviderFailedHandler_ShouldLogAndThrowErrorWhenNoReasonForFailureInMessageAndShouldNotPerformUpdateContractPublishedToProvider()
        {
            // arrange
            Mock<ILogger> loggerMock = new Mock<ILogger>();
            Mock<IXrmDocumentManager> xrmDocumentManagerMock = new Mock<IXrmDocumentManager>();

            UpdateContractPublishedToProviderFailedHandler handler = new UpdateContractPublishedToProviderFailedHandler(
                loggerMock.Object, xrmDocumentManagerMock.Object);

            contractType contract = new contractType();
            contract masterContract = new contract
            {
                contracts = new List<contractType>
                {
                    contract
                }
            };

            string failureReason = string.Empty;

            try
            {
                // act
                handler.Handle(new UpdateContractPublishedToProviderFailedCommand
                {
                    CorporateContract = masterContract,
                    ReasonForFailure = failureReason
                }, new TestableMessageHandlerContext()).Wait();
            }
            catch (Exception e)
            {
                Assert.IsTrue(e is ArgumentNullException, $"Expected exception type: {nameof(ArgumentException)}, actual exception type: {e.GetType()}");
                loggerMock.Verify(x => x.LogError(It.IsAny<int>(), e, e.Message), Times.Once, "Error was not logged");
            }

            xrmDocumentManagerMock.Verify(x => x.UpdateContractPublishedToProviderFailed(It.IsAny<contract>(), It.IsAny<string>()), Times.Never, $"{nameof(IXrmDocumentManager)} was called");
        }
    }
}
