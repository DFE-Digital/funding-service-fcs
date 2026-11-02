using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Castle.Windsor.Installer;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using SFA.FCT.DocumentsDomain.Common.Models;
using SFA.FCT.DocumentsDomain.Integration;

namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests
{
    using Common.Commands;

    [TestClass]
    public class DocumentSaverToAzureBlobStorageTests
    {
        private Mock<IDocumentRepository> _documentRepository = null;

        [TestInitialize]
        public void Initialize()
        {
            _documentRepository = new Mock<IDocumentRepository>();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestSaveDocumentSuccessfulTest()
        {
            // Arrange
            byte[] document = Properties.Resources.TestPDFFile;
            FctFile targetFile = new FctFile(ConfigurationManager.AppSettings["DocumentGeneration.TargetContainer"],
                "TestPDFFile.PDF");
            _documentRepository.Setup(m => m.SaveDocument(It.IsAny<FctFile>(), It.IsAny<byte[]>())).Verifiable();
            _documentRepository.Setup(m => m.FileExists(It.IsAny<FctFile>())).Returns(true).Verifiable();
            _documentRepository.Setup(m => m.CopyDocument(It.IsAny<FctFile>(), It.IsAny<FctFile>())).Verifiable();
            _documentRepository.Setup(m => m.DeleteFile(It.IsAny<FctFile>())).Verifiable();


            // Act
            DocumentSaver.IDocumentSaver documentSaver = new DocumentSaver.DocumentSaverToAzureBlobStorage(_documentRepository.Object);
            documentSaver.SaveDocument(new DocumentSaveCommand{FCTDocumentDatabus = document, TargetFileName = targetFile.Filename});

            // Assert
            _documentRepository.Verify(m => m.SaveDocument(It.IsAny<FctFile>(), It.IsAny<byte[]>()), Times.Once);
        }
    }
}