using System;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using SFA.FCT.DocumentsDomain.Common.Models;
using SFA.FCT.DocumentsDomain.Integration;

namespace SFA.FCT.DocumentsDomain.UnitTests.ResourceLayer
{
    [TestClass]
    public class TemplateRepositoryTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void TestTemplateRepositoryCheckTemplateExistsWhenFound()
        {
            Mock<IAzureStorageWrapper> azureMock = GetAzureStorageWrapperMock();

            ITemplateRepository tr = new TemplateRepository(azureMock.Object);

            Assert.IsTrue(tr.CheckTemplateExists(new FctFile("document-io-ut", "A1_24+_1516_2015-08-01.docx")));
        }
        [TestMethod, TestCategory("UnitTest")]
        public void TestTemplateRepositoryCheckTemplateExistsWhenInCache()
        {
            Mock<IAzureStorageWrapper> azureMock = GetAzureStorageWrapperMock();

            ITemplateRepository tr = new TemplateRepository(azureMock.Object);

            FctFile fileToCache = new FctFile("document-io-ut", "A1_24+_1516_2015-08-01.docx");
            tr.GetTemplate(fileToCache);
            
            Assert.IsTrue(tr.CheckTemplateExists(fileToCache));

            azureMock.Verify(m => m.DoesBlockBlobExist(It.IsAny<FctFile>()), Times.Never);

        }
        [TestMethod, TestCategory("UnitTest")]
        public void TestTemplateRepositoryCheckTemplateExistsWhenNotFound()
        {
            Mock<IAzureStorageWrapper> azureMock = new Mock<IAzureStorageWrapper>();
            azureMock
                .Setup(m => m.DoesBlockBlobExist(It.Is<FctFile>(file => file.FileContainer == "document-io-ut" && file.Filename == "UnitTest.docx")))
                .Returns(true)
                .Verifiable();

            ITemplateRepository tr = new TemplateRepository(azureMock.Object);
            FctFile fileToCache = new FctFile("document-io-ut", "A1_24+_1516_2015-08-01.docx");
            tr.GetTemplate(fileToCache);

            Assert.IsFalse(tr.CheckTemplateExists(new FctFile("document-io-ut", "DoesntExist.docx")));
            azureMock.Verify(m => m.GetBlockBlobContents(It.Is<FctFile>(f => f.Filename == "A1_24+_1516_2015-08-01.docx")), Times.Once);
            azureMock.Verify(m => m.DoesBlockBlobExist(It.Is<FctFile>(f=>f.Filename=="DoesntExist.docx")), Times.Once);

        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestTemplateRepositoryGetTemplateNames()
        {
            Mock<IAzureStorageWrapper> azureMock = GetAzureStorageWrapperMock();

            ITemplateRepository tr = new TemplateRepository(azureMock.Object);
            string[] templateNames = tr.GetTemplateNames("document-io-ut");
            Assert.AreEqual(templateNames.Length, 14);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestTemplateRepositoryGetTemplate()
        {
            Mock<IAzureStorageWrapper> azureMock = GetAzureStorageWrapperMock();
            ITemplateRepository tr = new TemplateRepository(azureMock.Object);

            FctFile file = new FctFile("document-io-ut", "A2_DLS1516_2015-08-01.docx");

            tr.GetTemplate(file);
            azureMock.Verify(m => m.GetBlockBlobContents(It.Is<FctFile>(f => f.Filename == "A2_DLS1516_2015-08-01.docx")), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestTemplateRepositoryGetTemplateWithCaching()
        {
            Mock<IAzureStorageWrapper> azureMock = GetAzureStorageWrapperMock();
            ITemplateRepository tr = new TemplateRepository(azureMock.Object);

            FctFile file = new FctFile("document-io-ut", "A2_DLS1516_2015-08-01.docx");

            tr.GetTemplate(file);
            tr.GetTemplate(file);

            azureMock.Verify(m => m.GetBlockBlobContents(It.Is<FctFile>(f => f.Filename == "A2_DLS1516_2015-08-01.docx")), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestTemplateRepositoryGetTemplateWithCachingMultipleDocuments()
        {
            Mock<IAzureStorageWrapper> azureMock = GetAzureStorageWrapperMock();
            ITemplateRepository tr = new TemplateRepository(azureMock.Object);

            tr.GetTemplate(new FctFile("document-io-ut", "A2_DLS1516_2015-08-01.docx"));
            tr.GetTemplate(new FctFile("document-io-ut", "A2_DLS1516_2015-08-01.docx"));
            tr.GetTemplate(new FctFile("document-io-ut", "A1_24+_1516_2015-08-01.docx"));

            azureMock.Verify(m => m.GetBlockBlobContents(It.Is<FctFile>(f => f.Filename == "A2_DLS1516_2015-08-01.docx")), Times.Once);
            azureMock.Verify(m => m.GetBlockBlobContents(It.Is<FctFile>(f => f.Filename == "A1_24+_1516_2015-08-01.docx")), Times.Once);
        }


        private static Mock<IAzureStorageWrapper> GetAzureStorageWrapperMock()
        {
            string[] containerContents = new string[]
            {
                "A1_24+_1516_2015-08-01.docx",
                "A1_AGE_1516_2015-04-01.docx",
                "A1_ESF_1420_2014-08-01.docx",
                "A1_MAIN_1516_2015-08-01.docx",
                "A2_24+ALLB1516_2015-08-01.docx",
                "A2_AGE1516_2015-04-01.docx",
                "A2_ASC1516_2015-08-01.docx",
                "A2_CL1516_2015-08-01.docx",
                "A2_DLS1516_2015-08-01.docx",
                "A2_OLASS1516_2015-08-01.docx",
                "A2H_24+_2015-08-01.docx",
                "A2H_AGE_2015-04-01.docx",
                "A2H_ESF_2015-08-01.docx",
                "A2H_MAIN_2015-08-01.docx"
            };
            Mock<IAzureStorageWrapper> mock = new Mock<IAzureStorageWrapper>();
            mock
                .Setup(m => m.GetContainerContents("document-io-ut"))
                .Returns(containerContents)
                .Verifiable();

            mock
                .Setup(m => m.DoesBlockBlobExist(It.IsAny<FctFile>()))
                .Returns<FctFile>((f)=>containerContents.Contains(f.Filename))
                .Verifiable();

            mock
                .Setup(m => m.GetBlockBlobContents(It.Is<FctFile>(f=>containerContents.Contains(f.Filename))))
                .Returns<FctFile>(f =>new byte[1])
                .Verifiable();

            return mock;
        }
    }
}
