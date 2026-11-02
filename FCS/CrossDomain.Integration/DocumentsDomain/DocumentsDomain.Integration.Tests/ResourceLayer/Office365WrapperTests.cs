namespace SFA.FCT.DocumentsDomain.Integration.Tests.ResourceLayer
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentSaver;
    using SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDeleter;
    using System.IO;
    using System.Configuration;
    using System.Linq;
    using global::UnitTests.Common;

    [TestClass]
    public class Office365WrapperTests
    {
        IOffice365Adapter _officeAdapter;

        private readonly string filename = "11111111_1111_v2222.pdf";
        private readonly string listName = "24+LOANS-1516-Input-Appendices";

        [TestInitialize]
        public void TestInitialise()
        {
            _officeAdapter = new Office365StorageWrapper();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DeleteContractDocumentSuccess()
        {
            // Arrange
            // Upload a file and then delete it
            byte[] document;
            using (MemoryStream ms = new MemoryStream(Properties.Resources.SamplePdfFile))
            {
                document = ms.ToArray();
            }
            // Force a delete incase a previous file has been left there from a failed test
            _officeAdapter.DeleteFile(filename, listName);
            _officeAdapter.UploadFile(filename, document, listName);

            // Act
            IDocumentDeleter documentDeleter = new DocumentDeleter(_officeAdapter);
            documentDeleter.DeleteDocument(new Common.Models.DocumentDeleteRequest() 
            { 
                DocumentFilename = filename,
                DocumentLocation = listName
            });

            // Assert
            Assert.IsFalse(_officeAdapter.DoesFileExist(listName, filename));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void UploadContractDocumentSucess()
        {
            // Arrange
            // Remove the file (if if exists)
            _officeAdapter.DeleteFile(filename, listName);

            // Test file to be uploaded
            byte[] document;
            using (MemoryStream ms = new MemoryStream(Properties.Resources.SamplePdfFile))
            {
                document = ms.ToArray();
            }
            
            // Act
            // Attempt to upload the file
            IDocumentSaver documentSaver = new DocumentSaver(_officeAdapter);
            documentSaver.SaveDocument(new Common.Commands.DocumentSaveCommand()
                                        {
                                            FCTDocumentDatabus = document,
                                            TargetFileName = filename,
                                            DocumentLocation = listName 
                                        });

            // Assert
            Assert.IsTrue(_officeAdapter.DoesFileExist(listName, filename));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void UploadContractDocumentWithRenameSucess()
        {
            // Arrange
            // Test file to be uploaded
            byte[] document;
            using (MemoryStream ms = new MemoryStream(Properties.Resources.SamplePdfFile))
            {
                document = ms.ToArray();
            }
            
            // Upload a same named file
            _officeAdapter.UploadFile(filename, document, listName);

            // Act
            // Attempt to upload the file
            IDocumentSaver documentSaver = new DocumentSaver(_officeAdapter);
            documentSaver.SaveDocument(new Common.Commands.DocumentSaveCommand()
            {
                FCTDocumentDatabus = document,
                TargetFileName = filename,
                DocumentLocation = listName
            });

            // Assert
            Assert.IsTrue(_officeAdapter.DoesFileExist(listName, filename));
            Assert.IsFalse(_officeAdapter.DoesFileExist(listName,filename + ".bak"));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void Office365StorageWrapper_UpsertFile_ShouldInsertWhenThereIsNoExistingFile()
        {
            // Arrange
            // Test file to be uploaded
            byte[] document;
            using (MemoryStream ms = new MemoryStream(Properties.Resources.SamplePdfFile))
            {
                document = ms.ToArray();
            }

            _officeAdapter.DeleteFile(filename, listName);

            // Act
            ((Office365StorageWrapper)_officeAdapter).UpsertFile(filename, document, listName);
    
            // Assert
            Assert.IsTrue(_officeAdapter.DoesFileExist(listName, filename));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void Office365StorageWrapper_UpsertFile_ShouldUpdateWhenThereIsAnExistingFile()
        {
            // Arrange
            byte[] originalDoc;
            using (MemoryStream ms = new MemoryStream(Properties.Resources.SamplePdfFile))
            {
                originalDoc = ms.ToArray();
            }

            Stream otherDocStream
                = new TestResource("SFA.FCT.DocumentsDomain.Integration.Tests", "Resources.AcademyTrustv1.1.pdf")
                .Stream;

            byte[] otherDoc = null;
            using (var memoryStream = new MemoryStream())
            {
                otherDocStream.CopyTo(memoryStream);
                otherDoc = memoryStream.ToArray();
            }

            // upload original
            _officeAdapter.UpsertFile(filename, originalDoc, listName);

            // Act - this will replave the original contents
            _officeAdapter.UpsertFile(filename, otherDoc, listName);

            // Assert
            Assert.IsTrue(_officeAdapter.DoesFileExist(listName, filename), "The file does not exist");
            ConfigurationManager.AppSettings["FileWatcher.DownloadBufferSize"] = "200000";
            var fileContents = _officeAdapter.GetFileContents(filename, listName);

            Assert.AreEqual(otherDoc.Length, fileContents.Length, "The updated contents does not have the same length");
            Assert.IsTrue(otherDoc.SequenceEqual(fileContents), "The file contents have not been updated");
        }

        [TestCleanup]
        public void TestCleanup()
        {
            // Remove any uploaded files
            _officeAdapter.DeleteFile(filename, listName);
            _officeAdapter.DeleteFile(filename + ".bak", listName);
        }
    }
}
