namespace FundingAllocation.Storage
{
    using System.IO;
    using Microsoft.Extensions.Configuration;
    using Microsoft.WindowsAzure.Storage.Blob;

    public class LargeMessageStorageService : ILargeMessageStorageService
    {
        private readonly IConfigurationRoot _appConfiguration;
        private string _containerName = null;
        private string AzureStorageConnectionString => _appConfiguration["ConnectionStrings:StorageConnectionString"];

        public LargeMessageStorageService(IConfigurationRoot appConfiguration)
        {
            _appConfiguration = appConfiguration;
        }

        public void StoreMessageBody(string key, byte[] bytes)
        {
            AzureStorageRepository.PutBlockBlob(
                AzureStorageConnectionString,
                fileName: key,
                containerName: GetContainerName(),
                contents: bytes);
        }

        public byte[] GetMessageBody(string key)
        {
            CloudBlockBlob cloudBlockBlob = AzureStorageRepository.GetBlockBlob(
                AzureStorageConnectionString,
                fileName: key,
                containerName: GetContainerName());

            using MemoryStream blobStream = new MemoryStream();
            cloudBlockBlob.DownloadToStreamAsync(blobStream).Wait();

            return blobStream.ToArray();
        }

        private string GetContainerName()
        {
            return _containerName ??= $"fcs-large-message{GetEnvironmentSuffix()}";
        }

        private string GetEnvironmentSuffix()
        {
            string environment = _appConfiguration["StorageTableSuffix"].ToLower();

            if (!string.IsNullOrEmpty(environment))
            {
                return "-" + environment;
            }

            return environment;
        }
    }
}
