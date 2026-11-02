namespace Datafix.Tests.Repositories
{
    using System.Configuration;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;

    public static class LargeMessageRepository
    {
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