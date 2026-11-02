namespace Operations.Worker.Audit
{
    using Microsoft.WindowsAzure.Storage;
    using Microsoft.WindowsAzure.Storage.Blob;

    public static class AzureStorageRepository
    {
        public static CloudBlockBlob GetBlockBlob(string azureStorageConnectionString, string fileName, string containerName)
        {
            CloudBlobContainer container = GetContainer(azureStorageConnectionString, containerName);
            CloudBlockBlob blockBlob = container.GetBlockBlobReference(fileName);

            return blockBlob;
        }

        public static bool Exists(string azureStorageConnectionString, string fileName, string containerName)
        {
            CloudBlockBlob blockBlob = GetBlockBlob(azureStorageConnectionString, fileName, containerName);

            return blockBlob.ExistsAsync().Result;
        }

        private static CloudBlobContainer GetContainer(string azureStorageConnectionString, string containerName)
        {
            CloudStorageAccount storageAccount = CloudStorageAccount.Parse(azureStorageConnectionString);
            CloudBlobClient blobClient = storageAccount.CreateCloudBlobClient();
            CloudBlobContainer container = blobClient.GetContainerReference(containerName);
            container.CreateIfNotExistsAsync().Wait();

            return container;
        }
    }
}
