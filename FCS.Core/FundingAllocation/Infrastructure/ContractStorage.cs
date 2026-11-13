namespace FundingAllocation.Infrastructure
{
    using Azure;
    using Azure.Storage.Blobs;
    using Azure.Storage.Blobs.Models;
    using FundingAllocation.Infrastructure;
    using Microsoft.Extensions.Configuration;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using System;
    using System.IO;
    using System.Text.Json;
    using System.Threading;
    using System.Threading.Tasks;

    public class ContractStorage : IContractStorage
    {
        private readonly IConfiguration _configuration;
        private const string ContainerNameRoot = "fct-contract";

        // Configure JSON once; adjust as needed for your model.
        private static readonly JsonSerializerOptions JsonOptions = new()
        {
            PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
            // If you have reference cycles, uncomment:
            // ReferenceHandler = System.Text.Json.Serialization.ReferenceHandler.Preserve
        };

        public ContractStorage(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        /// <summary>
        /// Stores the contract as JSON in a blob (overwrites if exists).
        /// </summary>
        public async Task<ETag> StoreContract(
            string key,
            ExtendedContractTypeAndIntent extendedContract,
            CancellationToken cancellationToken = default)
        {
            var containerClient = await GetBlobContainerClient(cancellationToken);
            var blobClient = containerClient.GetBlobClient(key);

            // Serialize to UTF-8 JSON bytes (safe alternative to BinaryFormatter).
            byte[] payload = JsonSerializer.SerializeToUtf8Bytes(extendedContract, JsonOptions);
            await using var stream = new MemoryStream(payload);

            // Overwrite existing blob if present.
            var upload = await blobClient.UploadAsync(stream, overwrite: true, cancellationToken);

            await blobClient.SetHttpHeadersAsync(
                new BlobHttpHeaders { ContentType = "application/json; charset=utf-8" },
                conditions: null,
                cancellationToken);

            return upload.Value.ETag;
        }

        /// <summary>
        /// Retrieves the contract by downloading the blob and deserializing from JSON.
        /// </summary>
        public async Task<ExtendedContractTypeAndIntent> GetContract(
            string key,
            CancellationToken cancellationToken = default)
        {
            var containerClient = await GetBlobContainerClient(cancellationToken);
            var blobClient = containerClient.GetBlobClient(key);

            // Use DownloadToAsync for broad compatibility across v12.* of Azure.Storage.Blobs.
            await using var ms = new MemoryStream();
            await blobClient.DownloadToAsync(ms, cancellationToken);
            ms.Position = 0;

            var result = JsonSerializer.Deserialize<ExtendedContractTypeAndIntent>(ms.ToArray(), JsonOptions);
            if (result is null)
                throw new InvalidOperationException($"Blob '{key}' could not be deserialized to {nameof(ExtendedContractTypeAndIntent)}.");

            return result;
        }

        public string GetKey(string contractNumber, int version, int subVersion)
            => $"{contractNumber}___{version}___{subVersion}";

        private async Task<BlobContainerClient> GetBlobContainerClient(CancellationToken cancellationToken = default)
        {
            var connectionString = _configuration.GetConnectionString("StorageConnectionString");
            var blobServiceClient = new BlobServiceClient(connectionString);

            var containerName = GetContainerName();
            var containerClient = blobServiceClient.GetBlobContainerClient(containerName);

            await containerClient.CreateIfNotExistsAsync(PublicAccessType.None, cancellationToken: cancellationToken);
            return containerClient;
        }

        private string GetContainerName()
        {
            var environment = _configuration["StorageTableSuffix"];
            return string.IsNullOrWhiteSpace(environment)
                ? ContainerNameRoot
                : $"{ContainerNameRoot}-{environment.ToLower()}";
        }
    }
}