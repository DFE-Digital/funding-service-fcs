namespace CrossDomain.Integration.Common.Tests.Integration.Office365
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;

    [TestClass]
    public class Office365StorageDataDependentTests
    {
        [TestMethod, TestCategory("DataDependent")]
        public void Office365StorageWrapper_DoesFileExistInAnArchiveFolder()
        {
            // this was used against Live
            bool doesFileExist = new Office365StorageWrapper().DoesFileExist(listName: @"CDA Reports/Archive",
                folderName: "15-16 Year End",
                fileName: "CDA Last Approved Version Mainstream and 24plus Loans 15-16.csv");

            Assert.AreEqual(true, doesFileExist);
        }
    }
}
