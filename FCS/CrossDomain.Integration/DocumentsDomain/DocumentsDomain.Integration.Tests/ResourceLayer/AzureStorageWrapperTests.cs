namespace SFA.FCT.DocumentsDomain.Integration.Tests.ResourceLayer
{
    using System.Configuration;
    using Common.Models;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.WindowsAzure.Storage;
    using Microsoft.WindowsAzure.Storage.Blob;
    using Properties;

    [TestClass]
    public class AzureStorageWrapperTests
    {
        private string BlobFileContainer
        {
            get { return ConfigurationManager.AppSettings["testTargetContainer"]; }
        }
        private const string BlobFilename = "AzureTestDoc.docx";


        [TestInitialize]
        public void Initialise()
        {
            CloudStorageAccount storageAccount = CloudStorageAccount.Parse(ConfigurationManager.ConnectionStrings["StorageConnectionString"].ConnectionString);
            CloudBlobClient blobClient = storageAccount.CreateCloudBlobClient();
            CloudBlobContainer container = blobClient.GetContainerReference(BlobFileContainer);
            CloudBlockBlob blockBlob = container.GetBlockBlobReference(BlobFilename);

            byte[] contents =
                Resources.Appendix1Mockup;

            blockBlob.UploadFromByteArray(contents, 0, contents.Length);

        }

        [TestCleanup]
        public void TestCleanup()
        {
            CloudStorageAccount storageAccount = CloudStorageAccount.Parse(ConfigurationManager.ConnectionStrings["StorageConnectionString"].ConnectionString);
            CloudBlobClient blobClient = storageAccount.CreateCloudBlobClient();
            CloudBlobContainer container = blobClient.GetContainerReference(BlobFileContainer);
            CloudBlockBlob blockBlob = container.GetBlockBlobReference(BlobFilename);
            blockBlob.DeleteIfExists();
        }

        [TestMethod]
        [TestCategory("IntegrationTest")]
        public void GetBlockBlobSuccess()
        {
            // Arrange
            FctFile file = new FctFile(BlobFileContainer, BlobFilename);
            CloudBlockBlob blob = null;

            // Act
            blob = new AzureStorageWrapper().GetBlockBlob(file);

            // Assert
            Assert.IsNotNull(blob);
        }


    }
}
