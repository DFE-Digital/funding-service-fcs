namespace WorkerRole.Repositories
{
    using System.Configuration;
    using System.IO;
    using Microsoft.WindowsAzure.Storage.Blob;

    public static class LargeMessageStorageService
    {
        private static string ContainerName => $"fcs-large-message{GetEnvironmentSuffix()}";

        public static void StoreMessageBody(string key, byte[] bytes)
        {
            AzureStorageRepository.PutBlockBlob(fileName:key, containerName: ContainerName, contents: bytes);
        }

        public static byte[] GetMessageBody(string key)
        {
            CloudBlockBlob cloudBlockBlob = AzureStorageRepository.GetBlockBlob(fileName: key, containerName: ContainerName);

            using (MemoryStream blobStream = new MemoryStream())
            {
                cloudBlockBlob.DownloadToStream(blobStream);

                return blobStream.ToArray();
            }
        }

        private static string GetEnvironmentSuffix()
        {
            string environment = ConfigurationManager.AppSettings["StorageTableSuffix"].ToLower();

            if (!string.IsNullOrEmpty(environment))
            {
                return "-" + environment;
            }

            return environment;
        }
    }
}
