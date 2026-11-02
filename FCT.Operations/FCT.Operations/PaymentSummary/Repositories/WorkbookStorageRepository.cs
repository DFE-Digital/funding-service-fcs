namespace FCT.Operations.PaymentSummary.Repositories
{
    using Aspose.Cells;
    using System.IO;
    using Infrastructure;
    using SFA.FCS.Worker.Common;

    public class WorkbookStorageRepository : IWorkbookStorageRepository
    {
        private const string ContainerRootName = "fcs-payment-report"; 
        private readonly IFcsConfiguration _appConfiguration;

        public WorkbookStorageRepository(IFcsConfiguration appConfiguration)
        {
            _appConfiguration = appConfiguration;
        }

        private string AzureStorageConnectionString => _appConfiguration["ConnectionStrings:StorageConnectionString"];
        private string ContainerName => $"{ContainerRootName}{GetEnvironmentSuffix()}";

        public void Upload(Workbook workbook, string filename)
        {
            var memoryStream = ConvertToMemoryStream(workbook);

            AzureStorageRepository.PutBlockBlob(AzureStorageConnectionString, filename, ContainerName, memoryStream.ToArray());
        }

        public bool Exists(string filename)
        {
            return AzureStorageRepository.Exists(AzureStorageConnectionString, filename, ContainerName);
        }

        public byte[] GetWorkbookBytes(string filename)
        {
            var blockBlob = AzureStorageRepository.GetBlockBlob(AzureStorageConnectionString, filename, ContainerName);

            using MemoryStream blobStream = new MemoryStream();
            blockBlob.DownloadToStreamAsync(blobStream).Wait();

            return blobStream.ToArray();
        }

        private static MemoryStream ConvertToMemoryStream(Workbook workbook)
        {
            var memoryStream = new MemoryStream();

            workbook.Save(memoryStream, (SaveFormat)workbook.FileFormat);
            return memoryStream;
        }

        private string GetEnvironmentSuffix()
        {
            var environment = _appConfiguration["StorageTableSuffix"].ToLower();

            if (!string.IsNullOrEmpty(environment))
            {
                return "-" + environment;
            }

            return environment;
        }
    }
}