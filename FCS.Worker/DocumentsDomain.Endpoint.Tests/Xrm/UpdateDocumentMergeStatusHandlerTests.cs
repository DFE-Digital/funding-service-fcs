namespace DocumentsDomain.Endpoint.Tests.Xrm
{
    using System;
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
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Documents;
    using SFA.FCT.DocumentsDomain.Common;
    using SFA.FCT.DocumentsDomain.Common.Commands;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class UpdateDocumentMergeStatusHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void UpdateDocumentMergeStatusHandler_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<UpdateDocumentMergeStatusHandler>());
            container.BeginScope();

            // act
            container.Resolve<UpdateDocumentMergeStatusHandler>();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void UpdateDocumentMergeStatusHandler_ShouldSendGetDocumentsForDeleteCommand_ForSuccessfulMergeAndUpdate()
        {
            // arrange
            Mock<ILogger> loggerMock = new Mock<ILogger>();
            Mock<IXrmDocumentManager> xrmDocumentManagerMock = new Mock<IXrmDocumentManager>();

            UpdateDocumentMergeStatusHandler handler = new UpdateDocumentMergeStatusHandler(loggerMock.Object, xrmDocumentManagerMock.Object);

            Contract masterContract = new Contract
            {
                contracts = new List<contractType>
                {
                    new contractType()
                }
            };

            xrmDocumentManagerMock
                .Setup(m => m.UpdateContractWithDocumentMergeStatus(masterContract.contracts.First(), It.Is<MergeStatus>(x => x.IsMergeSuccessful)))
                .Returns(true);

            UpdateDocumentMergeStatusCommand cmd = new UpdateDocumentMergeStatusCommand
            {
                CorporateContract = masterContract,
                MergeStatus = new MergeStatus
                {
                    IsMergeSuccessful = true
                }
            };

            TestableMessageHandlerContext context = new TestableMessageHandlerContext();

            // act
            handler.Handle(cmd, context).Wait();

            // assert
            xrmDocumentManagerMock.VerifyAll();

            Assert.AreEqual(1, context.SentMessages.Count(m => m.Message is GetDocumentsForDeleteCommand), $"{nameof(GetDocumentsForDeleteCommand)} was not sent");

            loggerMock.Verify(l => l.LogInformation(DocumentsDomainLoggingEventId.UpdateDocumentMergeStatusHandlerMsgReceived, It.IsAny<string>()));
            loggerMock.Verify(l => l.LogInformation(DocumentsDomainLoggingEventId.UpdateDocumentMergeStatusHandlerUpdateSuccessful, It.IsAny<string>()));
            loggerMock.Verify(l => l.LogInformation(DocumentsDomainLoggingEventId.UpdateDocumentMergeStatusHandlerReplying, It.IsAny<string>()));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void UpdateDocumentMergeStatusHandler_ShouldNotReplyWithGetDocumentsForDeleteCommand_ForFailedMergeAndSuccessfulUpdate()
        {
            // arrange
            Mock<ILogger> loggerMock = new Mock<ILogger>();
            Mock<IXrmDocumentManager> xrmDocumentManagerMock = new Mock<IXrmDocumentManager>();

            UpdateDocumentMergeStatusHandler handler = new UpdateDocumentMergeStatusHandler(loggerMock.Object, xrmDocumentManagerMock.Object);

            contractType contract = new contractType();
            Contract masterContract = new Contract
            {
                contracts = new List<contractType>
                {
                    contract
                }
            };

            MergeStatus mergeStatus = new MergeStatus
            {
                IsMergeSuccessful = false
            };

            xrmDocumentManagerMock
                .Setup(m => m.UpdateContractWithDocumentMergeStatus(contract, mergeStatus))
                .Returns(true);

            UpdateDocumentMergeStatusCommand cmd = new UpdateDocumentMergeStatusCommand
            {
                CorporateContract = masterContract,
                MergeStatus = mergeStatus
            };

            TestableMessageHandlerContext context = new TestableMessageHandlerContext();

            // act
            handler.Handle(cmd, context).Wait();

            // assert
            xrmDocumentManagerMock.VerifyAll();

            Assert.AreEqual(0, context.SentMessages.Count(m => m.Message is GetDocumentsForDeleteCommand), $"Handler tried to send {nameof(GetDocumentsForDeleteCommand)}");

            loggerMock.Verify(l => l.LogInformation(DocumentsDomainLoggingEventId.UpdateDocumentMergeStatusHandlerMsgReceived, It.IsAny<string>()));
            loggerMock.Verify(l => l.LogInformation(DocumentsDomainLoggingEventId.UpdateDocumentMergeStatusHandlerUpdateSuccessful, It.IsAny<string>()));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void UpdateDocumentMergeStatusHandler_ShouldThrowException_WhenXrmUpdateContractThrowsException()
        {
            // arrange
            Mock<IXrmDocumentManager> xrmDocumentManagerMock = new Mock<IXrmDocumentManager>();

            UpdateDocumentMergeStatusHandler handler = new UpdateDocumentMergeStatusHandler(Mock.Of<ILogger>(), xrmDocumentManagerMock.Object);

            contractType contract = new contractType();
            Contract masterContract = new Contract
            {
                contracts = new List<contractType>
                {
                    contract
                }
            };

            MergeStatus mergeStatus = new MergeStatus
            {
                IsMergeSuccessful = false
            };

            xrmDocumentManagerMock
                .Setup(m => m.UpdateContractWithDocumentMergeStatus(contract, mergeStatus))
                .Throws(new Exception());

            UpdateDocumentMergeStatusCommand cmd = new UpdateDocumentMergeStatusCommand
            {
                CorporateContract = masterContract,
                MergeStatus = mergeStatus
            };

            bool expectedExceptionThrown = false;

            // act
            try
            {
                handler.Handle(cmd, new TestableMessageHandlerContext()).Wait();
            }
            catch (Exception)
            {
                expectedExceptionThrown = true;
            }

            // assert
            Assert.IsTrue(expectedExceptionThrown, "Expected exception not thrown");
        }
    }
}
