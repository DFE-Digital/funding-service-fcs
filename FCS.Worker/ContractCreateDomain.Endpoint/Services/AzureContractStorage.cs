namespace ContractCreateDomain.Endpoint.Services
{
    using System.Configuration;
    using Infrastructure.Extensions;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    public class AzureContractStorage : IContractStorage
    {
        public void UploadContract(string key, ExtendedContractTypeAndIntent extendedContract)
        {
            AzureStorageWrapper.PutBlockBlob(
                CreateFctFile(key),
                extendedContract.ConvertObjectToByteArray());
        }

        public ExtendedContractTypeAndIntent GetContract(string key)
        {
            FctFile fctFile = CreateFctFile(key);
            byte[] objectBytes = AzureStorageWrapper.GetBlockBlobContents(fctFile);

            return objectBytes.ConvertByteArrayToObject<ExtendedContractTypeAndIntent>();
        }

        public void RemoveContract(string key)
        {
            FctFile fctFile = CreateFctFile(key);
            AzureStorageWrapper.DeleteBlockBlob(fctFile);
        }

        public string GetKey(string contractNumber, int version, int subVersion)
        {
            return $"{contractNumber}___{version}___{subVersion}";
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
    }
}
    
