namespace FCT.Console.Config.Tests.DocumentFolders
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Config.DocumentFolders;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Moq;

    [TestClass]
    public class DocumentFolderCreatorIntegrationTests
    {

        [TestMethod, TestCategory("IntegrationTest")]
        public void DocumentFolderCreator_CanConnectToSharePoint_ShouldIndicateSuccessfulConnectionWhenUsingCorrectFolderName()
        {
            // arrange 
            const string folderName = "24+LOANS-1516-Input-Appendices";

            ILogger logger = Mock.Of<ILogger>();

            DocumentFolderCreator folderCreator = new DocumentFolderCreator(new Office365StorageWrapper { Logger = logger }, logger);

            // act
            bool successfulConnection = folderCreator.CanConnectToSharePoint(folderName);

            // assert
            Assert.IsTrue(successfulConnection, $"Did not Successfully connect to SharePoint when correct folder name was used. Folder name '{folderName}'");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DocumentFolderCreator_CanConnectToSharePoint_ShouldIndicateFailedConnectionWhenUsingIncorrectFolderName()
        {
            // arrange 
            const string folderName = "INCORRECT_FOLDER_NAME";

            ILogger logger = Mock.Of<ILogger>();

            DocumentFolderCreator folderCreator = new DocumentFolderCreator(new Office365StorageWrapper { Logger = logger }, logger);

            // act
            bool successfulConnection = folderCreator.CanConnectToSharePoint(folderName);

            // assert
            Assert.IsFalse(successfulConnection, $"Connected to SharePoint when incorrect folder name was used. Folder name '{folderName}'");
        }
    }
}
