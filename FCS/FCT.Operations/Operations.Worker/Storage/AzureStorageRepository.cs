namespace Operations.Worker.Storage
{
    using Microsoft.WindowsAzure.Storage;
    using Microsoft.WindowsAzure.Storage.Blob;
    public static class AzureStorageRepository
    {
        public static void PutBlockBlob(string azureStorageConnectionString, string fileName, string containerName, byte[] contents)
        {
            CloudBlockBlob blockBlob = GetBlockBlob(azureStorageConnectionString, fileName, containerName);

            blockBlob.UploadFromByteArrayAsync(contents, 0, contents.Length).Wait();
        }

        public static CloudBlockBlob GetBlockBlob(string azureStorageConnectionString, string fileName, string containerName)
        {
            CloudBlobContainer container = GetContainer(azureStorageConnectionString, containerName);
            CloudBlockBlob blockBlob = container.GetBlockBlobReference(fileName);

            return blockBlob;
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
