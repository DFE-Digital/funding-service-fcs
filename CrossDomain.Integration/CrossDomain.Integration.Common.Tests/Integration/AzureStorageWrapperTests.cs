namespace CrossDomain.Integration.Common.Tests.Integration
{
    using System;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;

    [TestClass]
    public class AzureStorageWrapperTests
    {
        [TestMethod, TestCategory("DataDependent")]
        public void AzureStorageWrapper_ShouldGetBlobInfos()
        {
            DateTime startDate = new DateTime(2016, 8, 1, 0, 0, 0, DateTimeKind.Utc);
            var blobInfos = AzureStorageWrapper.GetBlobInfosInContainerAfterDate("integrity-check-dat", startDate);

            Assert.AreEqual(80, blobInfos.Count);
            Assert.IsTrue(blobInfos.All(bi => bi.LastModified != null));
        }
    }
}
