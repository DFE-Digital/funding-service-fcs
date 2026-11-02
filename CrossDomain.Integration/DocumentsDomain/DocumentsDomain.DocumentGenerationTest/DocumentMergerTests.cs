using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Aspose.Words;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using SFA.FCT.DocumentsDomain.Common.Models;
using SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentMerger;
using SFA.FCT.DocumentsDomain.Integration;

namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests
{
    [TestClass]
    public class DocumentMergerTests
    {
        private Mock<IAsposeWrapper> _asposeWrapperMock = null;

        [TestInitialize]
        public void Initialize()
        {
            _asposeWrapperMock = new Mock<IAsposeWrapper>();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestMergeDocumentsNoPDFSuccess()
        {
            // Arrange
            DocumentConvertRequest dcr = new DocumentConvertRequest();
            DocumentConvertRequestPart dcrPart = new DocumentConvertRequestPart();
            dcrPart.DocPart = new Document();
            dcrPart.SequenceNumber = 1;
            dcr.DocConvertRequests = new List<DocumentConvertRequestPart>();
            dcr.DocConvertRequests.Add(dcrPart);
            dcr.TargetFile = new FctFile("", "");

            _asposeWrapperMock.Setup(m => m.ConvertToPdf(It.IsAny<List<DocumentConvertRequestPart>>())).Returns(new byte[1]);

            // Act
            IDocumentMerger documentMerger = new DocumentMerger.DocumentMerger(_asposeWrapperMock.Object);
            byte[] testOut = documentMerger.MergeDocuments(dcr);

            // Assert
            Assert.IsNotNull(testOut, "No PDF returned");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestMergeDocumentsSuccessfulTest()
        {
            //Arrange
            DocumentConvertRequest request = new DocumentConvertRequest();
            DocumentConvertRequestPart part = new DocumentConvertRequestPart();
            part.DocPart = new Document();
            part.SequenceNumber = 1;
            request.DocConvertRequests = new List<DocumentConvertRequestPart>();
            request.DocConvertRequests.Add(part);
            request.TargetFile = new FctFile(ConfigurationManager.AppSettings["DocumentGeneration.TargetContainer"],
                "TargetFile.docx");

            _asposeWrapperMock.Setup(m=>m.ConvertToPdf(It.IsAny<List<DocumentConvertRequestPart>>())).Returns(new byte[10]).Verifiable();

            //Act
            IDocumentMerger documentMerger = new DocumentMerger.DocumentMerger(_asposeWrapperMock.Object);
            byte[] documents = documentMerger.MergeDocuments(request);

            //Assert
            Assert.IsTrue(documents.Length == 10);
        }
    }
}
