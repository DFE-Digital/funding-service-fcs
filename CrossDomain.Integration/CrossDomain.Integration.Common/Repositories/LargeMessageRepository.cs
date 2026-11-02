namespace SFA.FCT.CrossDomain.Integration.Common.Repositories
{
    using System.Configuration;
    using Storage;

    public static class LargeMessageRepository
    {
        public static string StoreMessageBody(string key, byte[] bytes)
        {
            AzureStorageWrapper.PutBlockBlob(
                CreateFctFile(key),
                contents:bytes);

            return key;
        }

        public static byte[] GetMessageBody(string key)
        {
            FctFile fctFile = CreateFctFile(key);
            
            return AzureStorageWrapper.GetBlockBlobContents(fctFile);
        }

        private static FctFile CreateFctFile(string key)
        {
            string containerName = $"fcs-large-message{GetEnvironmentSuffix()}";
            AzureStorageWrapper.CreateIfNotExists(containerName);

            return new FctFile(containerName, key);
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
