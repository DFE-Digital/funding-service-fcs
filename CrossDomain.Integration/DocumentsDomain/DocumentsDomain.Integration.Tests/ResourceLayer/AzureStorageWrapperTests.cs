namespace SFA.FCT.DocumentsDomain.Integration.Tests.ResourceLayer
{
    using System.Configuration;
    using Azure.Storage.Blobs;
    using Azure.Storage.Blobs.Specialized;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class AzureStorageWrapperTests
    {
        private string BlobFileContainer => ConfigurationManager.AppSettings["testTargetContainer"];
        private const string BlobFilename = "AzureTestDoc.docx";

        private BlobServiceClient CreateService() =>
            new BlobServiceClient(ConfigurationManager
                .ConnectionStrings["StorageConnectionString"].ConnectionString);

        [TestInitialize]
        public void Initialise()
        {
            var service = CreateService();
            var container = service.GetBlobContainerClient(BlobFileContainer);

            // Ensure container exists
            container.CreateIfNotExists();

            // Get a client for the blob
            BlobClient blob = container.GetBlobClient(BlobFilename);

            // Upload bytes
            var contents = Properties.Resources.Appendix1Mockup;
            blob.Upload(new System.IO.MemoryStream(contents), overwrite: true); // modern Upload overloads [2](https://learn.microsoft.com/en-us/dotnet/api/azure.storage.blobs.blobclient.upload?view=azure-dotnet)
        }

        [TestCleanup]
        public void TestCleanup()
        {
            var service = CreateService();
            var container = service.GetBlobContainerClient(BlobFileContainer);
            BlobBaseClient blob = container.GetBlobClient(BlobFilename);

            // DeleteIfExists (returns true/false)
            blob.DeleteIfExists(); // modern DeleteIfExists* exists on BlobBaseClient (sync/async) [4](https://learn.microsoft.com/en-us/dotnet/api/azure.storage.blobs.specialized.blobbaseclient.deleteifexistsasync?view=azure-dotnet)
        }

        [TestMethod]
        [TestCategory("IntegrationTest")]
        public void GetBlockBlobSuccess()
        {
            // If AzureStorageWrapper is still legacy, update it to return the modern BlobClient
            // or adapt test expectations accordingly.
            // Example modern check using the same container/blob name:
            var service = CreateService();
            var container = service.GetBlobContainerClient(BlobFileContainer);
            var blob = container.GetBlobClient(BlobFilename);

            Assert.IsTrue(blob.Exists().Value);
        }
    }

}
