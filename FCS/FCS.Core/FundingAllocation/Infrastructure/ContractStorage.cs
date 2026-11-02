namespace FundingAllocation.Infrastructure
{
    using System.IO;
    using System.Runtime.Serialization;
    using System.Runtime.Serialization.Formatters.Binary;
    using System.Threading.Tasks;
    using Azure;
    using Azure.Storage.Blobs;
    using Microsoft.Extensions.Configuration;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    public class ContractStorage : IContractStorage
    {
        private readonly IConfigurationRoot _configuration;
        private const string ContainerNameRoot = "fct-contract";

        public ContractStorage(IConfigurationRoot configuration)
        {
            _configuration = configuration;
        }

        public async Task<ETag> StoreContract(string key, ExtendedContractTypeAndIntent extendedContract)
        {
            var containerClient = await GetBlobContainerClient();
            var stream = CreateStreamForObject(extendedContract);

            try
            {
                var response = await containerClient.UploadBlobAsync(key, stream);

                return response.Value.ETag;
            }
            catch (RequestFailedException e) when (e.Status == 409)
            {
                // this is already there, delete the one there and then replace
                var blobClient = containerClient.GetBlobClient(key);
                await blobClient.DeleteIfExistsAsync();
                stream.Position = 0;
                var response = await containerClient.UploadBlobAsync(key, stream);

                return response.Value.ETag;
            }
        }

        public async Task<ExtendedContractTypeAndIntent> GetContract(string key)
        {
            var containerClient = await GetBlobContainerClient();
            var blobClient = containerClient.GetBlobClient(key);
            MemoryStream stream = new MemoryStream();
            await blobClient.DownloadToAsync(stream);
            var formatter = new BinaryFormatter();
            stream.Position = 0;

            return formatter.Deserialize(stream) as ExtendedContractTypeAndIntent;
        }

        public string GetKey(string contractNumber, int version, int subVersion)
        {
            return $"{contractNumber}___{version}___{subVersion}";
        }

        private string GetContainerName()
        {
            var environment = _configuration["StorageTableSuffix"];
            if (string.IsNullOrEmpty(environment))
            {
                return ContainerNameRoot;
            }

            return $"{ContainerNameRoot}-{environment.ToLower()}";
        }

        private static Stream CreateStreamForObject(ExtendedContractTypeAndIntent extendedContract)
        {
            MemoryStream stream = new MemoryStream();
            IFormatter formatter = new BinaryFormatter();
            formatter.Serialize(stream, extendedContract);
            stream.Position = 0;

            return stream;
        }

        private async Task<BlobContainerClient> GetBlobContainerClient()
        {
            BlobServiceClient blobServiceClient = new BlobServiceClient(_configuration.GetConnectionString("StorageConnectionString"));
            var containerName = GetContainerName();
            var client = blobServiceClient.GetBlobContainerClient(containerName);
            await client.CreateIfNotExistsAsync();

            return client;
        }
    }
}
