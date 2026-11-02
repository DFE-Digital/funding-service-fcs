namespace ContractCreateDomain.Endpoint.Infrastructure
{
    using System.Configuration;
    using System.IO;
    using System.IO.Compression;
    using DTOs;
    using Newtonsoft.Json;
    using SFA.FCT.CrossDomain.Integration.Common.Serializers;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;

    public class SagaDataStorage : ISagaDataStorage
    {
        public void UploadSagaData<T>(string key, T sagaData) where T : IHttpStorageValue
        {
            string json = JsonConvert.SerializeObject(sagaData);

            var jsonAsBytes = json.ConvertObjectToByteArray();

            var zippedJsonAsBytes = ToCompressedBytes(jsonAsBytes);

            AzureStorageWrapper.PutBlockBlob(
                CreateFctFile(key),
                zippedJsonAsBytes,
                sagaData.Etag);
        }

        public T GetSagaData<T>(string key) where T : IHttpStorageValue
        {
            FctFile fctFile = CreateFctFile(key);
            BlobContents blob = AzureStorageWrapper.GetBlobContents(fctFile);

            var objectBytes = ToDecompressedBytes(blob.Contents);

            string json = objectBytes.ConvertByteArrayToObject<string>();

            T value = JsonConvert.DeserializeObject<T>(json);

            value.Etag = blob.Etag;

            return value;
        }

        public void RemoveData(string key)
        {
            FctFile fctFile = CreateFctFile(key);
            AzureStorageWrapper.DeleteBlockBlob(fctFile);
        }

        private static FctFile CreateFctFile(string key)
        {
            string containerName = $"fct-contract{GetEnvironmentSuffix()}";
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

        static byte[] ToCompressedBytes(byte[] data)
        {
            using (var compressedStream = new MemoryStream())
            using (var zipStream = new GZipStream(compressedStream, CompressionMode.Compress))
            {
                zipStream.Write(data, 0, data.Length);
                zipStream.Close();
                return compressedStream.ToArray();
            }
        }

        static byte[] ToDecompressedBytes(byte[] data)
        {
            using (var compressedStream = new MemoryStream(data))
            using (var zipStream = new GZipStream(compressedStream, CompressionMode.Decompress))
            using (var resultStream = new MemoryStream())
            {
                zipStream.CopyTo(resultStream);
                return resultStream.ToArray();
            }
        }
    }
}
