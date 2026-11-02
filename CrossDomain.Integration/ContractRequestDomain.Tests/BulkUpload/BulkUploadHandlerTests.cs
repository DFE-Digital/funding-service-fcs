namespace ContractRequestDomain.Tests.BulkUpload
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Interfaces;
    using SFA.FCT.ContractRequestDomain.Integration.BulkUpload;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class BulkUploadHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void BulkUploadHandler_ShouldMoveFileToProcessedWhenAlreadyInProcessing()
        {
            // arrange
            BulkUploadHandler handler = new BulkUploadHandler();
            handler.Data = new BulkUploadSagaData();
            Mock<ILogger> loggerMock = new Mock<ILogger>();
            Mock<IBulkUploadFileAccess> bulkUploadMock = new Mock<IBulkUploadFileAccess>();
            handler.Logger = loggerMock.Object;
            handler.BulkUploadFileAccess = bulkUploadMock.Object;
            bulkUploadMock.Setup(b => b.DoesFileExistInProcessing(It.IsAny<string>())).Returns(true);
            bulkUploadMock.Setup(b => b.DoesFileExistInInputFolder(It.IsAny<string>())).Returns(true);
            var contextMock = new TestableMessageHandlerContext();
            // act
            handler.Handle(new NewExcelUploadFileEvent(), contextMock).Wait();

            // assert
            bulkUploadMock.Verify(b => b.MoveRejectedFileFromInputToProcessed(It.IsAny<string>(), FileRejectionReason.Duplicate));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void BulkUploadHandler_ShouldMoveFileToProcessedWhenAlreadyInProcessed()
        {
            // arrange
            BulkUploadHandler handler = new BulkUploadHandler();
            handler.Data = new BulkUploadSagaData();
            Mock<ILogger> loggerMock = new Mock<ILogger>();
            Mock<IBulkUploadFileAccess> bulkUploadMock = new Mock<IBulkUploadFileAccess>();
            handler.Logger = loggerMock.Object;
            handler.BulkUploadFileAccess = bulkUploadMock.Object;
            bulkUploadMock.Setup(b => b.DoesFileExistInProcessedFolder(It.IsAny<string>())).Returns(true);
            bulkUploadMock.Setup(b => b.DoesFileExistInInputFolder(It.IsAny<string>())).Returns(true);
            var contextMock = new TestableMessageHandlerContext();
            
            // act
            handler.Handle(new NewExcelUploadFileEvent(), contextMock).Wait();

            // assert
            bulkUploadMock.Verify(b => b.MoveRejectedFileFromInputToProcessed(It.IsAny<string>(), FileRejectionReason.Duplicate));
        }

        private class NewExcelUploadFileEvent : INewExcelUploadFileEvent
        {
            public string UploadedFilename { get; set; }
            public string BatchId { get; set; }
        }
    }
}
