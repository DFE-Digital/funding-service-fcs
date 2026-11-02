namespace SFA.FCT.CrossDomain.Integration.Azure.Worker.Repositories
{
    using System.Configuration;
    using Microsoft.WindowsAzure.Storage;
    using Microsoft.WindowsAzure.Storage.Blob;

    public static class AzureStorageRepository
    {
        public static void PutBlockBlob(string fileName, string containerName, byte[] contents)
        {
            CloudBlockBlob blockBlob = GetBlockBlob(fileName, containerName);

            blockBlob.UploadFromByteArray(contents, 0, contents.Length);
        }

        public static CloudBlockBlob GetBlockBlob(string fileName, string containerName)
        {
            CloudBlobContainer container = GetContainer(containerName);
            CloudBlockBlob blockBlob = container.GetBlockBlobReference(fileName);

            return blockBlob;
        }

        private static CloudBlobContainer GetContainer(string containerName)
        {
            CloudStorageAccount storageAccount = CloudStorageAccount.Parse(ConfigurationManager.ConnectionStrings["StorageConnectionString"].ConnectionString);
            CloudBlobClient blobClient = storageAccount.CreateCloudBlobClient();
            CloudBlobContainer container = blobClient.GetContainerReference(containerName);
            container.CreateIfNotExists();

            return container;
        }
    }
}
