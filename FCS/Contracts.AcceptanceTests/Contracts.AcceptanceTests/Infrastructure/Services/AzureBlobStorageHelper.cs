namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Services
{
    using System.Configuration;
    using MoreLinq;
    using CrossDomain.Integration.Common.Storage;

    public class AzureBlobStorageHelper
    {
        public static void DeleteBlobIfExists(string containerName, string fileName)
        {
            FctFile blobInfo = new FctFile(fileContainer: containerName, filename: fileName);

            bool doesBlobExist = AzureStorageWrapper.DoesBlockBlobExist(blobInfo);
            if (doesBlobExist)
            {
                AzureStorageWrapper.DeleteBlockBlob(blobInfo);
            }
        }

        public static void RemoveAll(string containerName)
        {
            var blobNames = AzureStorageWrapper.GetBlobsInContainer(containerName);
            blobNames.ForEach(blobName => AzureStorageWrapper.DeleteBlockBlob(new FctFile(fileContainer: containerName, filename: blobName)));
        }

        public static string GetEnvironmentSuffix()
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