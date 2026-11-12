namespace DocumentsDomain.Endpoint.Tests.ArchiveDocument
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Endpoint.ArchiveDocument;
    using Endpoint.ArchiveDocument.Services;
    using Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.DocumentsDomain.Common;
    using SFA.FCT.DocumentsDomain.Common.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using DocFileInfo = Endpoint.ArchiveDocument.FileInfo;

    [TestClass]
    public class ContractApprovedAndWithdrawnHandlerFlowTests
    {
        private Mock<IArchiveFileOrchestrator> _orchestrator;
        private Mock<IPolicyQueryService> _policyQueryService;
        private TestableMessageHandlerContext _context;
        private ContractApprovedAndWithdrawnHandler _handler;

        [TestInitialize]
        public void Setup()
        {
            _orchestrator = new Mock<IArchiveFileOrchestrator>();
            _policyQueryService = new Mock<IPolicyQueryService>();
            _policyQueryService
                .Setup(p => p.ShouldGenerateDocumentationForContract(It.IsAny<contract>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(true);
            _context = new TestableMessageHandlerContext();
            _handler = new ContractApprovedAndWithdrawnHandler(
                Mock.Of<ILogger>(),
                _orchestrator.Object,
                Mock.Of<ISessionConnectionFactory>(),
                _policyQueryService.Object);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Approved_WhenDocumentationNotRequired_ShouldNotOrchestrateOrSend()
        {
            _policyQueryService
                .Setup(p => p.ShouldGenerateDocumentationForContract(It.IsAny<contract>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(false);

            _handler.Handle(Approved("Variation"), _context).Wait();

            _orchestrator.Verify(o => o.OrchestrateForNotification(It.IsAny<contract>()), Times.Never);
            _orchestrator.Verify(o => o.OrchestrateForNonNotification(It.IsAny<contract>()), Times.Never);
            Assert.AreEqual(0, _context.SentMessages.Length);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Withdrawn_WhenDocumentationNotRequired_ShouldNotOrchestrateOrSend()
        {
            _policyQueryService
                .Setup(p => p.ShouldGenerateDocumentationForContract(It.IsAny<contract>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(false);

            _handler.Handle(Withdrawn("Variation"), _context).Wait();

            _orchestrator.Verify(o => o.OrchestrateForNotification(It.IsAny<contract>()), Times.Never);
            _orchestrator.Verify(o => o.OrchestrateForNonNotification(It.IsAny<contract>()), Times.Never);
            Assert.AreEqual(0, _context.SentMessages.Length);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Approved_WhenAmendmentIsNotification_ShouldUseNotificationOrchestration()
        {
            _orchestrator
                .Setup(o => o.OrchestrateForNotification(It.IsAny<contract>()))
                .Returns(new List<DocFileInfo>());

            _handler.Handle(Approved("Notification"), _context).Wait();

            _orchestrator.Verify(o => o.OrchestrateForNotification(It.IsAny<contract>()), Times.Once);
            _orchestrator.Verify(o => o.OrchestrateForNonNotification(It.IsAny<contract>()), Times.Never);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Withdrawn_WhenAmendmentIsNotNotification_ShouldUseNonNotificationOrchestration()
        {
            _orchestrator
                .Setup(o => o.OrchestrateForNonNotification(It.IsAny<contract>()))
                .Returns(new List<DocFileInfo>());

            _handler.Handle(Withdrawn("Variation"), _context).Wait();

            _orchestrator.Verify(o => o.OrchestrateForNonNotification(It.IsAny<contract>()), Times.Once);
            _orchestrator.Verify(o => o.OrchestrateForNotification(It.IsAny<contract>()), Times.Never);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Approved_WhenFileMarkedForDelete_ShouldSendDocumentDeleteCommand()
        {
            SetupNonNotificationFiles(new DocFileInfo("a.pdf", "folderA", FileAction.Delete, ContractAmendmentType.Variation));

            _handler.Handle(Approved("Variation"), _context).Wait();

            DocumentDeleteCommand command = _context.SentMessages.Select(m => m.Message).OfType<DocumentDeleteCommand>().Single();
            Assert.AreEqual(1, command.Files.Count);
            Assert.AreEqual("a.pdf", command.Files[0].Filename);
            Assert.AreEqual("folderA", command.Files[0].FileContainer);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Approved_WhenFileMarkedForArchive_ShouldSendArchiveCommandWithApprovalEventType()
        {
            DocFileInfo file = new DocFileInfo("b.pdf", "folderB", FileAction.Archive, ContractAmendmentType.Variation);
            SetupNonNotificationFiles(file);

            _handler.Handle(Approved("Variation"), _context).Wait();

            AssertArchiveCommandSent(file, EventType.Approval);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Withdrawn_WhenFileMarkedForArchive_ShouldSendArchiveCommandWithWithdrawalEventType()
        {
            DocFileInfo file = new DocFileInfo("c.pdf", "folderC", FileAction.Archive, ContractAmendmentType.Variation);
            SetupNonNotificationFiles(file);

            _handler.Handle(Withdrawn("Variation"), _context).Wait();

            AssertArchiveCommandSent(file, EventType.Withdrawal);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Withdrawn_WhenFileMarkedForDelete_ShouldSendDocumentDeleteCommand()
        {
            SetupNonNotificationFiles(new DocFileInfo("d.pdf", "folderD", FileAction.Delete, ContractAmendmentType.Variation));

            _handler.Handle(Withdrawn("Variation"), _context).Wait();

            Assert.AreEqual(1, _context.SentMessages.Count(m => m.Message is DocumentDeleteCommand));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Approved_WhenSeveralFiles_ShouldSendOneCommandPerFile()
        {
            SetupNonNotificationFiles(
                new DocFileInfo("a.pdf", "f", FileAction.Delete, ContractAmendmentType.Variation),
                new DocFileInfo("b.pdf", "f", FileAction.Archive, ContractAmendmentType.Variation),
                new DocFileInfo("c.pdf", "f", FileAction.Archive, ContractAmendmentType.Variation));

            _handler.Handle(Approved("Variation"), _context).Wait();

            Assert.AreEqual(3, _context.SentMessages.Length);
            Assert.AreEqual(1, _context.SentMessages.Count(m => m.Message is DocumentDeleteCommand));
            Assert.AreEqual(2, _context.SentMessages.Count(m => m.Message is ArchiveDocumentCommand));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Approved_WhenFileActionNotSupported_ShouldThrow()
        {
            SetupNonNotificationFiles(new DocFileInfo("e.pdf", "f", FileAction.NotSet, ContractAmendmentType.Variation));

            AggregateException exception = null;
            try
            {
                _handler.Handle(Approved("Variation"), _context).Wait();
            }
            catch (AggregateException e)
            {
                exception = e;
            }

            Assert.IsNotNull(exception);
            Assert.IsInstanceOfType(exception.InnerException, typeof(ArgumentException));
        }

        private void AssertArchiveCommandSent(DocFileInfo file, EventType expectedEventType)
        {
            var sent = _context.SentMessages.Single(m => m.Message is ArchiveDocumentCommand);
            ArchiveDocumentCommand command = (ArchiveDocumentCommand)sent.Message;
            Assert.AreEqual(file.Filename, command.FileName);
            Assert.AreEqual(file.FolderName, command.FolderOrigin);
            Assert.AreEqual(file.AmendmentType, command.AmendmentType);
            Assert.AreEqual(file.GetGuid(), command.Key);
            Assert.AreEqual(expectedEventType, command.EventType);
        }

        private void SetupNonNotificationFiles(params DocFileInfo[] files)
        {
            _orchestrator
                .Setup(o => o.OrchestrateForNonNotification(It.IsAny<contract>()))
                .Returns(files);
        }

        private static ContractApprovedEvent Approved(string amendmentType)
        {
            return new ContractApprovedEvent { CorporateContract = CreateContract(amendmentType) };
        }

        private static ContractWithdrawnEvent Withdrawn(string amendmentType)
        {
            return new ContractWithdrawnEvent { CorporateContract = CreateContract(amendmentType) };
        }

        private static contract CreateContract(string amendmentType)
        {
            return new contract
            {
                contractNumber = "MAS-1",
                contracts = { new contract { contractNumber = "CON-1", amendmentType = amendmentType } }
            };
        }
    }
}
