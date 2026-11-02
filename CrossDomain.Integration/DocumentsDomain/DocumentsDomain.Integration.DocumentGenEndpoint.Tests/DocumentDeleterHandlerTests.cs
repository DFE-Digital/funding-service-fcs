using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using SFA.FCT.DocumentsDomain.Common.Commands;
using SFA.FCT.Framework.Logging.Interfaces;
using SFA.FCT.DocumentsDomain.Common.Models;
using SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDeleter;

namespace SFA.FCT.DocumentsDomain.Integration.DocumentGenEndpoint.Tests
{
    using DocumentGenerationEndpoint.DocumentDeleteEndpoint;
    using NServiceBus.Testing;

    [TestClass]
    public class DocumentDeleterHandlerTests
    {
        private Mock<ILogger> _logger;
        private Mock<IDocumentDeleter> _documentDeleter;

        [TestInitialize]
        public void Initialise()
        {
            _logger = new Mock<ILogger>();
            _documentDeleter = new Mock<IDocumentDeleter>();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Test_Handle_EnsureHandlerPassesCorrectNumberOfDeleteRequestsToTheDocumentDeleterObject()
        {
            // Arrange
            DocumentDeleterHandler handler = new DocumentDeleterHandler(
                _documentDeleter.Object,
                _logger.Object);

            DocumentDeleteCommand command = new DocumentDeleteCommand();
            string fileName1 = "test1.pdf";
            string fileName2 = "test2.pdf";
            string location1 = "Location1";
            string location2 = "Location2";

            command.Files.Add(new FctFile { Filename = fileName1, FileContainer = location1 });
            command.Files.Add(new FctFile { Filename = fileName2, FileContainer = location2 });

            _documentDeleter.Setup(c => c.DeleteDocument(It.Is<DocumentDeleteRequest>(r => r.DocumentFilename == fileName1 && r.DocumentLocation == location1))).Verifiable();
            _documentDeleter.Setup(c => c.DeleteDocument(It.Is<DocumentDeleteRequest>(r => r.DocumentFilename == fileName2 && r.DocumentLocation == location2))).Verifiable();

            // Act
            handler.Handle(command, new TestableMessageHandlerContext()).Wait();

            // Assert
            _documentDeleter.Verify(c => c.DeleteDocument(It.Is<DocumentDeleteRequest>(r => r.DocumentFilename == fileName1 && r.DocumentLocation == location1)), Times.Once);
            _documentDeleter.Verify(c => c.DeleteDocument(It.Is<DocumentDeleteRequest>(r => r.DocumentFilename == fileName2 && r.DocumentLocation == location2)), Times.Once);
        }

        [TestCleanup]
        public void CleanUp()
        {
            _logger = null;
            _documentDeleter = null;
        }
    }
}
