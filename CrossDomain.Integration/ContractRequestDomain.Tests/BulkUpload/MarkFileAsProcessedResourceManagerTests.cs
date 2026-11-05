namespace ContractRequestDomain.Tests.BulkUpload
{
    using System.Transactions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Interfaces;
    using SFA.FCT.ContractRequestDomain.Integration.BulkUpload;

    [TestClass]
    public class MarkFileAsProcessedResourceManagerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void TransactionCommit_MarksFileAsRetrieved()
        {
            var fileAccess = new Mock<IBulkUploadFileAccess>();
            var manager = new MarkFileAsProcessedResourceManager(fileAccess.Object, "upload.xlsx");

            using (var scope = new TransactionScope())
            {
                Transaction.Current.EnlistVolatile(manager, EnlistmentOptions.None);
                scope.Complete();
            }

            fileAccess.Verify(x => x.MarkFileAsRetrieved("upload.xlsx"), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TransactionRollback_DoesNotMarkFileAsRetrieved()
        {
            var fileAccess = new Mock<IBulkUploadFileAccess>();
            var manager = new MarkFileAsProcessedResourceManager(fileAccess.Object, "upload.xlsx");

            using (var scope = new TransactionScope())
            {
                Transaction.Current.EnlistVolatile(manager, EnlistmentOptions.None);
            }

            fileAccess.Verify(x => x.MarkFileAsRetrieved(It.IsAny<string>()), Times.Never);
        }
    }
}
