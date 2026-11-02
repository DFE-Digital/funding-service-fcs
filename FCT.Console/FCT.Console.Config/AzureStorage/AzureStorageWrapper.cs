namespace FCT.Console.Config.AzureStorage
{
    using System.Configuration;
    using System.Diagnostics.Contracts;
    using Microsoft.WindowsAzure.Storage;
    using Microsoft.WindowsAzure.Storage.Blob;

    public static class AzureStorageWrapper
    {
        public static CloudBlockBlob GetBlockBlob(FctFile file)
        {
            Contract.Requires(file != null);

            CloudBlobContainer container = GetContainer(file.FileContainer);
            CloudBlockBlob blockBlob = container.GetBlockBlobReference(file.Filename);

            return blockBlob;
        }

        public static void PutBlockBlob(FctFile file, byte[] contents)
        {
            Contract.Requires(file != null);

            CloudBlockBlob blockBlob = GetBlockBlob(file);

            blockBlob.UploadFromByteArray(contents, 0, contents.Length);
        }

        public static void DeleteBlockBlob(FctFile file)
        {
            Contract.Requires(file != null);

            CloudBlockBlob fileBlob = GetBlockBlob(file);
            fileBlob.DeleteIfExists();
        }

        public static bool DoesBlockBlobExist(FctFile file)
        {
            Contract.Requires(file != null);

            return GetBlockBlob(file).Exists();
        }

        private static CloudBlobContainer GetContainer(string containerName)
        {
            CloudStorageAccount storageAccount = CloudStorageAccount.Parse(ConfigurationManager.ConnectionStrings["StorageConnectionString"].ConnectionString);
            CloudBlobClient blobClient = storageAccount.CreateCloudBlobClient();
            CloudBlobContainer container = blobClient.GetContainerReference(containerName);

            return container;
        }
    }
}