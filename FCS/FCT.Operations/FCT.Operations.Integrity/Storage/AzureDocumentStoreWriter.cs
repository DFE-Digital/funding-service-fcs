namespace SFA.FCT.Operations.Integrity.Storage
{
    using FCS.Worker.Common;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;

    public class AzureDocumentStoreWriter : ICheckerDocumentStoreWriter
    {
        private readonly string _integrityCheckerContainerName;
        private readonly IFcsConfiguration _configuration;
        public AzureDocumentStoreWriter(IFcsConfiguration configuration)
        {
            _configuration = configuration;
            _integrityCheckerContainerName = _configuration["IntegrityCheckerContainer"];
        }

        public void WriteCheckerResult(byte[] document, string filename)
        {
            var saveAs = new FctFile(_integrityCheckerContainerName, filename);
            var azureStorageConnectionString = _configuration["ConnectionStrings:StorageConnectionString"];

            AzureStorageRepository.PutBlockBlob(azureStorageConnectionString, filename, _integrityCheckerContainerName,  document);
        }
    }
}
