namespace FCT.Console.Config.AzureStorage
{
    using System;
    using System.Configuration;
    using System.Diagnostics.Contracts;
    using Azure.Storage.Blobs;
    using Azure.Storage.Blobs.Specialized;

    public static class AzureStorageWrapper
    {
        private static BlobContainerClient GetContainer(string containerName)
        {
            var connectionString =
                ConfigurationManager.ConnectionStrings["StorageConnectionString"].ConnectionString;

            var containerClient = new BlobContainerClient(connectionString, containerName);

            return containerClient;
        }

        public static BlobClient GetBlockBlob(FctFile file)
        {
            Contract.Requires(file != null);

            var container = GetContainer(file.FileContainer);
            return container.GetBlobClient(file.Filename);
        }

        public static void PutBlockBlob(FctFile file, byte[] contents)
        {
            Contract.Requires(file != null);

            var blob = GetBlockBlob(file);

            using var stream = new System.IO.MemoryStream(contents);
            blob.Upload(stream, overwrite: true);
        }

        public static void DeleteBlockBlob(FctFile file)
        {
            Contract.Requires(file != null);

            var blob = GetBlockBlob(file);
            blob.DeleteIfExists();
        }

        public static bool DoesBlockBlobExist(FctFile file)
        {
            Contract.Requires(file != null);

            var blob = GetBlockBlob(file);
            return blob.Exists();
        }
    }
}
