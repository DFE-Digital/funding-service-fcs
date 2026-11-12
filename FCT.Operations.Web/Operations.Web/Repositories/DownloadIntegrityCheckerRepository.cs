namespace Operations.Web.Repositories
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using System.Threading.Tasks;
    using Dapper;
    using Dtos;
    using Microsoft.WindowsAzure.Storage;
    using Microsoft.WindowsAzure.Storage.Blob;
    using System.IO;
    public class DownloadIntegrityCheckerRepository : IDownloadIntegrityCheckerRepository
    {
        string connectionString = ConfigurationManager
               .ConnectionStrings["ContractManagementDbContext"].ConnectionString;
        private static string _containerName => $"integrity-check{GetEnvironmentSuffix()}";

        public async Task<IReadOnlyCollection<DownloadIntegrityCheckerCollection>> GetClosedCollectionsDesc()
        {

            using (var connection = new SqlConnection(connectionString))
            {
                var downloadIntegrityCollections = await connection.QueryAsync<DownloadIntegrityCheckerCollection>(
                        "dbo.sp_OpsWeb_GetDwnldClosedCollectionsDesc", new { })
                    .ConfigureAwait(false);

                return downloadIntegrityCollections.ToList();
            }
        }



        public async Task<byte[]> GetAttachmentAsync(string fileName)
        {
            var container = GetContainer(_containerName);
            var blockBlob = container.GetBlockBlobReference(fileName);
            using (var memoryStream = new MemoryStream())
            {
                await blockBlob.DownloadToStreamAsync(memoryStream);
                return memoryStream.ToArray();
            }
        }

        private static CloudBlobContainer GetContainer(string containerName)
        {
            CloudStorageAccount storageAccount = CloudStorageAccount.Parse(ConfigurationManager.ConnectionStrings["StorageConnectionString"].ConnectionString);
            CloudBlobClient blobClient = storageAccount.CreateCloudBlobClient();
            CloudBlobContainer container = blobClient.GetContainerReference(containerName);
            container.CreateIfNotExistsAsync().GetAwaiter().GetResult();

            return container;
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