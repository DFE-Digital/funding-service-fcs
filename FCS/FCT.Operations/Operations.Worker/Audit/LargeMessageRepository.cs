namespace Operations.Worker.Audit
{
    using System.IO;
    using Microsoft.WindowsAzure.Storage.Blob;
    using SFA.FCS.Worker.Common;

    public class LargeMessageRepository
    {
        private readonly IFcsConfiguration _appConfiguration;
        private string _containerName = null;
        private string AzureStorageConnectionString => _appConfiguration["ConnectionStrings:StorageConnectionString"];

        public LargeMessageRepository(IFcsConfiguration appConfiguration)
        {
            _appConfiguration = appConfiguration;
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
