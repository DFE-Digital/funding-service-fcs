namespace CrossDomain.Integration.Common.Tests.Integration.Office365
{
    using System.Collections.Generic;
    using System.IO;
    using System.Net;
    using System.Reflection;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;

    [TestClass]
    public class Office365StorageWrapperTests
    {
        private string _testDirectoryName = "AGE-1516-Input-Terms And Conditions";
        private string _testTargetDirectoryName = "AGE-1516-Output-Documents for Publication";
        private const string TestEmbeddedFilesNameSpace = "CrossDomain.Integration.Common.Tests.Integration.Office365.TestEmbeddedFiles.";
        private IOffice365Adapter _office365StorageWrapper;
        
        [TestInitialize]
        public void Initialise()
        {
            ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;
            _office365StorageWrapper = new Office365StorageWrapper();
            DeleteTestFiles();
            UploadTestFiles();
        }

        [TestCleanup]
        public void CleanUp()
        {
            DeleteTestFiles();
            _office365StorageWrapper = null;
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void GetFilenamesByFileNameStartText_EnsureCorrectFilenamesReturned()
        {
            IList<string> tAndCFileNames = _office365StorageWrapper.GetFilenamesByFileNameStartText(_testDirectoryName, "12345_ty434");
            Assert.IsTrue(tAndCFileNames.Count == 4, "The number of files returned should be 4");

            int count = 1;
            foreach (var tAndCFile in tAndCFileNames)
            {
                Assert.IsTrue(tAndCFile == "12345_ty434_" + count + ".pdf", "The file at index " + count + " should be named '12345_ty434_" + count + ".pdf'");
                count++;
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void GetFilesByFileNameStartText_EnsureCorrectFilesReturned()
        {
            
            Dictionary<string, byte[]> TandCs = _office365StorageWrapper.GetFilesByFileNameStartText(_testDirectoryName, "12345_ty434");
            Assert.IsTrue(TandCs.Count == 4, "The number of files returned should be 4");

            int count = 1;
            foreach(var TandC in TandCs)
            {
                Assert.IsTrue(TandC.Key == "12345_ty434_" + count + ".pdf"  , "The file at index " + count + " should be named '12345_ty434_" + count + ".pdf'");
                Assert.IsTrue(TandC.Value.Length == ReturnEmbededFileAsByteArray(TestEmbeddedFilesNameSpace + "12345_ty434_" + count +".pdf").Length, "Return file does not match expected file array length thus different file ");
                count++;    
            }

            
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void GetFileVersionCount_Test()
        {
            _office365StorageWrapper.UploadFileWithOverwrite("12345_ty434_1.pdf", ReturnEmbededFileAsByteArray(TestEmbeddedFilesNameSpace + "12345_ty434_1.pdf"), _testDirectoryName);
            int versionCount = _office365StorageWrapper.GetFileVersionCount("12345_ty434_1.pdf", _testDirectoryName);
            Assert.AreEqual(2, versionCount, "There should be only one version");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void MoveFile_Test()
        {
            _office365StorageWrapper.UploadFileWithOverwrite("12345_ty434_1.pdf", ReturnEmbededFileAsByteArray(TestEmbeddedFilesNameSpace + "12345_ty434_1.pdf"), _testDirectoryName);
            _office365StorageWrapper.MoveFile("12345_ty434_1.pdf", _testDirectoryName, _testTargetDirectoryName);
            
            Assert.IsTrue(_office365StorageWrapper.DoesFileExist(_testTargetDirectoryName, "12345_ty434_1.pdf"), "File move failed from source to target document list");
            
            //move back so cleanup can work
            _office365StorageWrapper.MoveFile("12345_ty434_1.pdf", _testTargetDirectoryName, _testDirectoryName);
            Assert.IsTrue(_office365StorageWrapper.DoesFileExist(_testDirectoryName, "12345_ty434_1.pdf"), "File move failed from source to target document list");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void Office365StorageWrapper_MoveFileWithRename_ShouldMoveAndRenameFile()
        {
            _testDirectoryName = "Processing";
            _testTargetDirectoryName = "Processed";

            string startFileName = "12345_ty434_1.pdf";
            string changedFileName = "12345_ty434_1Rejected1234.pdf";
            _office365StorageWrapper.UploadFileWithOverwrite(startFileName, ReturnEmbededFileAsByteArray(TestEmbeddedFilesNameSpace + "12345_ty434_1.pdf"), _testDirectoryName);
            _office365StorageWrapper.MoveFileWithRename(startFileName, _testDirectoryName, _testTargetDirectoryName, changedFileName);

            Assert.IsTrue(_office365StorageWrapper.DoesFileExist(_testTargetDirectoryName, changedFileName), "File move failed from source to target document list");

            //move back so cleanup can work
            _office365StorageWrapper.MoveFileWithRename(changedFileName, _testTargetDirectoryName, _testDirectoryName, startFileName);
            Assert.IsTrue(_office365StorageWrapper.DoesFileExist(_testDirectoryName, startFileName), "File move failed from source to target document list");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void Office365StorageWrapper_DoesFileExist_ShouldReturnFalseIfNotExists()
        {
            // File is not created as part of TestInitialize
            Assert.IsFalse(_office365StorageWrapper.DoesFileExist(_testDirectoryName, "12345_ty434_6.pdf"));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void Office365StorageWrapper_DoesFileExist_WithFolder_ShouldReturnFalseIfNotExists()
        {
            // arrange
            const string folderName = "testFolder";

            if (!_office365StorageWrapper.DoesFolderExist(_testDirectoryName, folderName))
            {
                _office365StorageWrapper.CreateFolder(_testDirectoryName, folderName);
            }

            // assert
            Assert.IsFalse(_office365StorageWrapper.DoesFileExist(_testDirectoryName, folderName, "12345_ty434_7.pdf"));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void Office365StorageWrapper_CreateLibrary()
        {
            // arrange
            const string libraryName = "testLibrary";

            // act
            _office365StorageWrapper.CreateLibrary(libraryName);

            // assert
            Assert.IsTrue(_office365StorageWrapper.DoesLibraryExist(libraryName));
        }


        [TestMethod, TestCategory("IntegrationTest")]
        public void Office365StorageWrapper_DoesFileExist_WithFolder_ShouldReturnTrueIfExists()
        {
            // arrange
            const string folderName = "testFolder";

            if (!_office365StorageWrapper.DoesFolderExist(_testDirectoryName, folderName))
            {
                _office365StorageWrapper.CreateFolder(_testDirectoryName, folderName);
            }

            _office365StorageWrapper.DeleteFile("12345_ty434_6.pdf", _testDirectoryName, folderName);

            _office365StorageWrapper.UploadFileToFolderWithOverwrite(_testDirectoryName, folderName, ReturnEmbededFileAsByteArray(TestEmbeddedFilesNameSpace + "12345_ty434_1.pdf"), "12345_ty434_6.pdf");

            // assert
            Assert.IsTrue(_office365StorageWrapper.DoesFileExist(_testDirectoryName, folderName, "12345_ty434_6.pdf"));
        }

        private void UploadTestFiles()
        {
            _office365StorageWrapper.UploadFileWithOverwrite("12345_ty434_1.pdf", ReturnEmbededFileAsByteArray(TestEmbeddedFilesNameSpace + "12345_ty434_1.pdf"), _testDirectoryName);
            _office365StorageWrapper.UploadFileWithOverwrite("12345_ty434_2.pdf", ReturnEmbededFileAsByteArray(TestEmbeddedFilesNameSpace + "12345_ty434_2.pdf"), _testDirectoryName);
            _office365StorageWrapper.UploadFileWithOverwrite("12345_ty434_3.pdf", ReturnEmbededFileAsByteArray(TestEmbeddedFilesNameSpace + "12345_ty434_3.pdf"), _testDirectoryName);
            _office365StorageWrapper.UploadFileWithOverwrite("12345_ty434_4.pdf", ReturnEmbededFileAsByteArray(TestEmbeddedFilesNameSpace + "12345_ty434_4.pdf"), _testDirectoryName);
            _office365StorageWrapper.UploadFileWithOverwrite("34224_fdfcv_2.pdf", ReturnEmbededFileAsByteArray(TestEmbeddedFilesNameSpace + "34224_fdfcv_2.pdf"), _testDirectoryName);
            _office365StorageWrapper.UploadFileWithOverwrite("34343_awerr_5.pdf", ReturnEmbededFileAsByteArray(TestEmbeddedFilesNameSpace + "34343_awerr_5.pdf"), _testDirectoryName);
        }
        
        private void DeleteTestFiles()
        {
            _office365StorageWrapper.DeleteFile("12345_ty434_1.Rejected1234", _testTargetDirectoryName);
            _office365StorageWrapper.DeleteFile("12345_ty434_1.pdf", _testDirectoryName);
            _office365StorageWrapper.DeleteFile("12345_ty434_2.pdf", _testDirectoryName);
            _office365StorageWrapper.DeleteFile("12345_ty434_3.pdf", _testDirectoryName);
            _office365StorageWrapper.DeleteFile("12345_ty434_4.pdf", _testDirectoryName);
            _office365StorageWrapper.DeleteFile("34224_fdfcv_2.pdf", _testDirectoryName);
            _office365StorageWrapper.DeleteFile("34343_awerr_5.pdf", _testDirectoryName);
        }

        private static byte[] ReturnEmbededFileAsByteArray(string embeddedFileName)
        {
            var assembly = Assembly.GetExecutingAssembly();
            using (Stream resFilestream = assembly.GetManifestResourceStream(embeddedFileName))
            {
                if (resFilestream == null) return null;
                byte[] ba = new byte[resFilestream.Length];
                resFilestream.Read(ba, 0, ba.Length);
                return ba;
            }
        }
    }
}
