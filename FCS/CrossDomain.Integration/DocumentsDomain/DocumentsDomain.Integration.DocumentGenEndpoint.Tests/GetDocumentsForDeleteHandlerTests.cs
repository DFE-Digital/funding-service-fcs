namespace SFA.FCT.DocumentsDomain.Integration.DocumentGenEndpoint.Tests
{
    using System.Collections.Generic;
    using System.Linq;
    using Common;
    using Common.Commands;
    using CrossDomain.Integration.Common.Storage;
    using CrossDomain.Integration.Entities.CorporateContract;
    using DocumentGenerationEndpoint.DocumentDeleteEndpoint;
    using SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentLocationResolver;
    using Framework.Logging.Interfaces;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus;
    using NServiceBus.Testing;

    [TestClass]
    public class GetDocumentsForDeleteHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void GetDocumentsForDeleteHandler_GetsLocationAndFilenamesAndSendsDeleteCommand()
        {
            // arrange
            var mockO365Adapter = new Mock<IOffice365Adapter>();
            var mockResolver = new Mock<IDocumentLocationResolver>();
            var mockLogger = new Mock<ILogger>();

            var handler = new GetDocumentsForDeleteHandler(mockO365Adapter.Object, mockResolver.Object)
            {
                Logger = mockLogger.Object
            };

            const string contractNumber = "MAIN-123";
            const int ukprn = 10000000;

            var contract = new contractType
            {
                contractNumber = contractNumber,
                contractor = new contractor
                {
                    ukprn = ukprn
                }
            };

            var cmd = new GetDocumentsForDeleteCommand
            {
                Contract = contract
            };

            mockResolver.Setup(r => r.GetLocationOfTermsAndConditions(contract)).Returns("testLibrary");

            const string fileName = "10000000_MAIN-123_1.pdf";

            mockO365Adapter.Setup(oa => oa.GetFilenamesByFileNameStartText("testLibrary", "10000000_MAIN-123_")).Returns(new List<string>
            {
                fileName
            });

            var context = new TestableMessageHandlerContext();

            // act
            handler.Handle(cmd, context).Wait();

            // assert
            mockResolver.VerifyAll();
            mockO365Adapter.VerifyAll();
            Assert.AreEqual(1,
                context.SentMessages
                    .Select(m => m.Message)
                    .OfType<DocumentDeleteCommand>()
                    .Count(c => c.Files.Any(f => f.Filename == fileName)),
                $"{nameof(DocumentDeleteCommand)} not sent");

            mockLogger.Verify(l => l.LogInformation(DocumentsDomainLoggingEventId.GetDocumentsForDeleteHandlerMsgReceived, It.IsAny<string>()), Times.Once);
            mockLogger.Verify(l => l.LogInformation(DocumentsDomainLoggingEventId.GetDocumentsForDeleteHandlerGettingDocs, It.IsAny<string>()), Times.Once);
            mockLogger.Verify(l => l.LogInformation(DocumentsDomainLoggingEventId.GetDocumentsForDeleteHandlerSendingDeleteCmd, It.IsAny<string>()), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetDocumentsForDeleteHandler_DoesNotSendDeleteCommandWhenNoFilesFound()
        {
            // arrange
            var mockO365Adapter = new Mock<IOffice365Adapter>();
            var mockResolver = new Mock<IDocumentLocationResolver>();
            var mockLogger = new Mock<ILogger>();

            var handler = new GetDocumentsForDeleteHandler(mockO365Adapter.Object, mockResolver.Object)
            {
                Logger = mockLogger.Object
            };

            const string contractNumber = "MAIN-123";
            const int ukprn = 10000000;

            var contract = new contractType
            {
                contractNumber = contractNumber,
                contractor = new contractor
                {
                    ukprn = ukprn
                }
            };

            var cmd = new GetDocumentsForDeleteCommand
            {
                Contract = contract
            };

            mockResolver.Setup(r => r.GetLocationOfTermsAndConditions(contract)).Returns("testLibrary");

            const string fileName = "10000000_MAIN-123_1.pdf";

            mockO365Adapter.Setup(oa => oa.GetFilenamesByFileNameStartText("testLibrary", "10000000_MAIN-123_")).Returns(new List<string>());

            var context = new TestableMessageHandlerContext();

            // act
            handler.Handle(cmd, context).Wait();

            // assert
            mockResolver.VerifyAll();
            mockO365Adapter.VerifyAll();
            Assert.AreEqual(0,
                context.SentMessages
                    .Select(m => m.Message)
                    .OfType<DocumentDeleteCommand>()
                    .Count(c => c.Files.Any(f => f.Filename == fileName)),
                $"{nameof(DocumentDeleteCommand)} was sent");

            mockLogger.Verify(l => l.LogInformation(DocumentsDomainLoggingEventId.GetDocumentsForDeleteHandlerMsgReceived, It.IsAny<string>()), Times.Once);
            mockLogger.Verify(l => l.LogInformation(DocumentsDomainLoggingEventId.GetDocumentsForDeleteHandlerGettingDocs, It.IsAny<string>()), Times.Once);
            mockLogger.Verify(l => l.LogWarning(DocumentsDomainLoggingEventId.GetDocumentsForDeleteHandlerNoDocsFound, It.IsAny<string>()), Times.Once);
        }
    }
}
