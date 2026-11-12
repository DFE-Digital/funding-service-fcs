namespace ContractRequestDomain.Tests
{
    extern alias CSICommon;
    using System;
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Interfaces;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Services;
    using CSICommon::SFA.FCT.CrossDomain.Integration.Common;
    using CSICommon::SFA.FCT.CrossDomain.Integration.Common.Storage;

    [TestClass]
    public class Office365FileAccessTests
    {
        private Mock<IOffice365Adapter> _mockOffice365Adapter;

        [TestInitialize]
        public void Setup()
        {
            _mockOffice365Adapter = new Mock<IOffice365Adapter>();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Check_GetNewFiles_ReturnsNoFiles_WhenTheFolderIsEmpty()
        {
            //Arrange
            _mockOffice365Adapter.Setup(p => p.GetAllFiles(CommonUtil.InputFolderName)).Returns(new List<string>());

            IBulkUploadFileAccess uut = new Office365FileAccess(_mockOffice365Adapter.Object);

            //Act

            var files = uut.GetNewFiles();

            //Assert
            Assert.IsNotNull(files, "GetNewFiles Retun null object");
            Assert.AreEqual(0, files.Count, "GetNewFiles List in not Empty");

        }

        [TestMethod, TestCategory("UnitTest")]
        public void Office365FileAccess_MoveFailedFileFromProcessed_ShouldMoveAndRenameFile()
        {
            Mock<IOffice365Adapter> adapterMock = new Mock<IOffice365Adapter>();
            IBulkUploadFileAccess access = new Office365FileAccess(adapterMock.Object);

            access.MoveRejectedFileFromProcessingToProcessed("test", FileRejectionReason.FailedSyntax);

            adapterMock.Verify(x => x.MoveFileWithRename("test", "Processing", "Processed", It.Is<string>(y => y.Contains($"test.FailedSyntax-{DateTime.UtcNow.ToString("ddMMyyyy")}"))));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Office365FileAccess_ShouldMoveRejectedFileFromProcessingToProcessed()
        {
            Mock<IOffice365Adapter> adapterMock = new Mock<IOffice365Adapter>();
            IBulkUploadFileAccess access = new Office365FileAccess(adapterMock.Object);

            access.MoveRejectedFileFromProcessingToProcessed("test", FileRejectionReason.Duplicate);

            adapterMock.Verify(x => x.MoveFileWithRename("test", "Processing", "Processed", It.Is<string>(y => y.Contains($"test.Duplicate-{DateTime.UtcNow.ToString("ddMMyyyy")}"))));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Check_GetNewFiles_ReturnsFileList_WhenTheFolderIsNotEmpty()
        {

            //Arrange

            _mockOffice365Adapter.Setup(p => p.GetAllFiles(CommonUtil.InputFolderName)).Returns(new List<string> { "File1", "File2" });
            IBulkUploadFileAccess uut = new Office365FileAccess(_mockOffice365Adapter.Object);
            //  IOffice365Adapter 

            //Act

            var files = uut.GetNewFiles();


            //Assert
            Assert.IsNotNull(files, "GetNewFiles Retun null object");
            Assert.AreEqual(2, files.Count, "GetNewFiles List count did not match");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Check_GetBulkUploadFileContents_DoesNotReturnFile_WhenFileDoesnotExist()
        {
            var data = new byte[0];
            const string filePath = "filePath";
            //Arrange
            _mockOffice365Adapter.Setup(p => p.GetFileContents(filePath, CommonUtil.InputFolderName)).Returns(data);

            IBulkUploadFileAccess uut = new Office365FileAccess(_mockOffice365Adapter.Object);

            //Act

            var fileData = uut.GetBulkUploadFileContents(filePath);

            //Assert

            Assert.AreEqual(0, fileData.Length, "GetBulkUploadFileContents has returned byte array with content");

        }

        [TestMethod, TestCategory("UnitTest")]
        public void Check_GetBulkUploadFileContents_ReturnFile()
        {
            var data = new byte[] { 0, 1 };
            const string filePath = "filePath";
            //Arrange
            _mockOffice365Adapter.Setup(p => p.GetFileContents(filePath, CommonUtil.InputFolderName)).Returns(data);

            IBulkUploadFileAccess uut = new Office365FileAccess(_mockOffice365Adapter.Object);

            //Act

            var fileData = uut.GetBulkUploadFileContents(filePath);

            //Assert
            Assert.AreEqual(2, fileData.Length, "GetBulkUploadFileContents has returned byte array with incorrect content");

        }

        [TestMethod, TestCategory("UnitTest")]
        public void Check_MarkFileAsRetrieved_ShouldMoveFileFromSouceToTargetFolder()
        {
            var data = new byte[0];
            const string fileName = "fileName";

            //Arrange
            _mockOffice365Adapter.Setup(p => p.MoveFile(fileName, CommonUtil.InputFolderName, CommonUtil.ProcessingFolderName));

            IBulkUploadFileAccess uut = new Office365FileAccess(_mockOffice365Adapter.Object);

            //Act

            uut.MarkFileAsRetrieved(fileName);

            //Assert
            _mockOffice365Adapter.Verify(m => m.MoveFile("fileName", CommonUtil.InputFolderName, CommonUtil.ProcessingFolderName), Times.Once(), "MarkFileAsRetrieved did not move file");

        }

        [TestMethod, TestCategory("UnitTest")]
        public void Check_MarkFileAsRetrieved_ShouldBubbleAnyOfficce365Exception()
        {

            const string fileName = "fileName";

            //Arrange
            _mockOffice365Adapter.Setup(p => p.MoveFile(fileName, CommonUtil.InputFolderName, CommonUtil.ProcessingFolderName)).Throws(new Exception("Test Exception"));

            IBulkUploadFileAccess uut = new Office365FileAccess(_mockOffice365Adapter.Object);

            //Act
            var isExceptionThrown = false;
            try
            {
                uut.MarkFileAsRetrieved(fileName);
            }
            catch (Exception)
            {

                isExceptionThrown = true;
            }

            //Assert
            Assert.IsTrue(isExceptionThrown, "MarkFileAsRetrieved did not throw an exception");

        }

        [TestMethod, TestCategory("UnitTest")]
        public void Check_GetProcessingFileContents_DoesNotReturnFile_WhenFileDoesnotExist()
        {
            var data = new byte[0];
            const string filePath = "filePath";
            //Arrange
            _mockOffice365Adapter.Setup(p => p.GetFileContents(filePath, CommonUtil.ProcessingFolderName)).Returns(data);

            IBulkUploadFileAccess uut = new Office365FileAccess(_mockOffice365Adapter.Object);

            //Act
            var fileData = uut.GetProcessingFileContents(filePath);

            //Assert
            Assert.AreEqual(0, fileData.Length, "GetProcessingFileContents has returned byte array with content");

        }

        [TestMethod, TestCategory("UnitTest")]
        public void Check_GetProcessingFileContents_ReturnFile()
        {
            var data = new byte[] { 0, 1 };
            const string filePath = "filePath";
            //Arrange
            _mockOffice365Adapter.Setup(p => p.GetFileContents(filePath, CommonUtil.ProcessingFolderName)).Returns(data);

            IBulkUploadFileAccess uut = new Office365FileAccess(_mockOffice365Adapter.Object);

            //Act
            var fileData = uut.GetProcessingFileContents(filePath);

            //Assert
            Assert.AreEqual(2, fileData.Length, "GetProcessingFileContents has returned byte array with incorrect content");

        }

        [TestMethod, TestCategory("UnitTest")]
        public void Check_CreateSyntaxReport_ShouldConvertByteArrayFromString()
        {
            const string content = "content of syntax report file";
            const string fileName = "fileName";

            //Arrange
            _mockOffice365Adapter.Setup(p => p.UploadFile(fileName, It.IsAny<byte[]>(), It.IsAny<string>()));

            IBulkUploadFileAccess uut = new Office365FileAccess(_mockOffice365Adapter.Object);

            //Act
            uut.CreateSyntaxReport(fileName, content);

            //Assert
            _mockOffice365Adapter.Verify(p => p.UploadFile(It.IsAny<string>(), It.Is<byte[]>(x => x.Length > 0), It.IsAny<string>()), Times.Once(), "CreateSyntaxReport did not convert to byte array");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Check_CreateSyntaxReport_ShouldUploadByteArrayToOffice365()
        {
            const string content = "content of syntax report file";
            const string fileName = "fileName";

            //Arrange
            _mockOffice365Adapter.Setup(p => p.UploadFile(fileName, It.IsAny<byte[]>(), It.IsAny<string>()));

            IBulkUploadFileAccess uut = new Office365FileAccess(_mockOffice365Adapter.Object);

            //Act
            uut.CreateSyntaxReport(fileName, content);

            //Assert
            _mockOffice365Adapter.Verify(p => p.UploadFile(It.IsAny<string>(), It.IsAny<byte[]>(), It.IsAny<string>()), Times.Once(), "CreateSyntaxReport did not upload byte array");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Check_CreateResultsReport_ShouldUploadByteArrayToOffice365()
        {
            var content = new byte[] { 0, 1 };
            const string fileName = "fileName";

            //Arrange
            _mockOffice365Adapter.Setup(p => p.UploadFile(It.IsAny<string>(), It.IsAny<byte[]>(), It.IsAny<string>()));



            IBulkUploadFileAccess uut = new Office365FileAccess(_mockOffice365Adapter.Object);

            //Act
            uut.CreateResultsReport(fileName, content);

            //Assert
            _mockOffice365Adapter.Verify(p => p.UploadFile(It.IsAny<string>(), It.IsAny<byte[]>(), It.IsAny<string>()), Times.Once(), "CreateResultsReport did not upload byte array");

        }

        [TestMethod, TestCategory("UnitTest")]
        public void Check_CreateResultsReport_ShouldMoveFileFromSouceToTargetFolder()
        {
            var content = new byte[] { 0, 1 };
            const string fileName = "fileName";

            //Arrange
            _mockOffice365Adapter.Setup(p => p.MoveFile(It.IsAny<string>(), CommonUtil.ProcessingFolderName, CommonUtil.ProcessedFolderName));

            IBulkUploadFileAccess uut = new Office365FileAccess(_mockOffice365Adapter.Object);

            //Act
            uut.CreateResultsReport(fileName, content);

            //Assert
            _mockOffice365Adapter.Verify(m => m.MoveFile("fileName",CommonUtil.ProcessingFolderName ,CommonUtil.ProcessedFolderName), Times.Once(), "CreateResultsReport did not move file");

        }
    }
}
