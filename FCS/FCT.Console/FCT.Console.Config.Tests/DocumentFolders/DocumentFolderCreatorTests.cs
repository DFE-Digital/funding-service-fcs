namespace FCT.Console.Config.Tests.DocumentFolders
{
    using Config.DocumentFolders;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class DocumentFolderCreatorTests
    {
        private readonly Mock<IOffice365Adapter> _mockAdapter = new Mock<IOffice365Adapter>();
        private readonly Mock<ILogger> _mockLogger = new Mock<ILogger>();

        [TestMethod, TestCategory("UnitTest")]
        public void DocumentFolderCreator_FolderDoesNotAlreadyExist_ShouldCreateNewFolder()
        {
            // arrange
            _mockAdapter.Setup(m => m.DoesLibraryExist(It.IsAny<string>())).Returns(false);
            DocumentFolderCreator folderCreator = new DocumentFolderCreator(_mockAdapter.Object, _mockLogger.Object);

            // act
            folderCreator.CreateFolderIfNotExists("TestFolder-1617-Input-Appendices");

            // assert
            _mockAdapter.Verify(m => m.CreateLibrary(It.IsAny<string>()), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocumentFolderCreator_FolderAlreadyExists_ShouldNotCreateNewFolder()
        {
            // arrange
            _mockAdapter.Setup(m => m.DoesLibraryExist(It.IsAny<string>())).Returns(true);
            DocumentFolderCreator folderCreator = new DocumentFolderCreator(_mockAdapter.Object, _mockLogger.Object);

            // act
            folderCreator.CreateFolderIfNotExists("TestFolder-1617-Input-Appendices");

            // assert
            _mockAdapter.Verify(m => m.CreateLibrary(It.IsAny<string>()), Times.Never);
        }
    }
}