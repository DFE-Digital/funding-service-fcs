namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests
{
    using System;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using CrossDomain.Integration.Common.Storage;
    using Moq;
    using Common.Models;
    using DocumentDeleter;

    [TestClass]
    public class DocumentDeleterTest
    {
        private Mock<IOffice365Adapter> _office365MockAdapter = null;

        [TestMethod, TestCategory("UnitTest")]
        public void DocGen_DocumentDeleterDeletesADocument_WhenSentADocumentDeleteRequest()
        {
            // Arrange
            DocumentDeleteRequest deleteRequest = new DocumentDeleteRequest()
            {
                DocumentFilename = "test.pdf",
                DocumentLocation = "IrrelevantDocListInO365"
            };

            _office365MockAdapter = new Mock<IOffice365Adapter>();
            _office365MockAdapter.Setup(m => m.DeleteFile(deleteRequest.DocumentFilename, deleteRequest.DocumentLocation)).Verifiable();

            // Act
            IDocumentDeleter documentDeleter = new DocumentDeleter(_office365MockAdapter.Object);
            documentDeleter.DeleteDocument(deleteRequest);

            // Assert
            _office365MockAdapter.Verify(m => m.DeleteFile(deleteRequest.DocumentFilename, deleteRequest.DocumentLocation), Times.Once, "Delete file should be called once with parameters with correctly populated request object");
        }
    }
}
