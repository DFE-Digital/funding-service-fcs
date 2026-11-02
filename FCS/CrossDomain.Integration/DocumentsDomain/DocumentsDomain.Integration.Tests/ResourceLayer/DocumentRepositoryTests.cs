using System;
using System.Configuration;
using System.IO;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.DocumentsDomain.Common.Models;
using SFA.FCT.DocumentsDomain.Integration;
using Aspose.Words;
using Moq;
using System.Collections.Generic;

namespace SFA.FCT.DocumentsDomain.Integration.Tests.ResourceLayer
{
    [TestClass]
    public class DocumentRepositoryTests
    {
        private Mock<IAzureStorageWrapper> _azureMock = null;
        private IDocumentRepository _documentRepository = null;

        private string ContainerName
        {
            get { return ConfigurationManager.AppSettings["testTargetContainer"]; }
        }

        [TestInitialize]
        public void Initialise()
        {
            _azureMock = new Mock<IAzureStorageWrapper>();
            _azureMock.Setup(m => m.PutBlockBlob(It.IsAny<FctFile>(), It.IsAny<byte[]>())).Verifiable();
            _azureMock.Setup(m => m.GetBlockBlobContents(It.IsAny<FctFile>())).Returns(new byte[1]).Verifiable();

            _documentRepository = new DocumentRepository(_azureMock.Object);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void SaveDocumentWithValidTarget()
        {
            // Arrange
            const string testFilename = "SimpleTemplate.docx";
            byte[] document;
            using (MemoryStream ms = new MemoryStream(Properties.Resources.SamplePdfFile))
            {
                document = ms.ToArray();
            }

            // Act
            _documentRepository.SaveDocument(new FctFile(ContainerName, testFilename), document);

            _azureMock.Verify(m => m.PutBlockBlob(It.IsAny<FctFile>(), It.IsAny<byte[]>()), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestDocumentRepositoryGetDocument()
        {
            FctFile file = new FctFile("document-io-ui", "unit-test.docx");
            _documentRepository.GetDocument(file);
            _azureMock.Verify(m => m.GetBlockBlobContents(It.Is<FctFile>(f => f.FileContainer == file.FileContainer && f.Filename == file.Filename)), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestDocumentRepositoryCopyDocument()
        {
            FctFile sourceFile = new FctFile("source-container", "source-filename");
            FctFile targetFile = new FctFile("target-container", "target-filename");
            _documentRepository.CopyDocument(sourceFile, targetFile);

            _azureMock.Verify(m => m.CopyBlockBlob(
                It.Is<FctFile>(f=>f.Filename=="source-filename"), 
                It.Is<FctFile>(f=>f.Filename=="target-filename")
            ), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestDocumentRepositoryFileExists()
        {
            FctFile fileToCheck = new FctFile("container-name", "file-name");
            _documentRepository.FileExists(fileToCheck);

            _azureMock.Verify(m => m.DoesBlockBlobExist(It.Is<FctFile>(f => f.FileContainer == "container-name" && f.Filename == "file-name")), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestDocumentRepositoryDeleteFile()
        {
            FctFile fileToDelete = new FctFile("container-name", "file-name");
            _documentRepository.DeleteFile(fileToDelete);

            _azureMock.Verify(m => m.DeleteBlockBlob(It.Is<FctFile>(f => f.FileContainer == "container-name" && f.Filename == "file-name")), Times.Once);
        }

    }
}
