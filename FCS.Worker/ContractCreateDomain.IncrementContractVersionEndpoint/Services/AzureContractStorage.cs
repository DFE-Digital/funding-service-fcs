namespace ContractCreateDomain.IncrementContractVersionEndpoint.Services
{
    using System.Configuration;
    using SFA.FCT.CrossDomain.Integration.Common.Serializers;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    public class AzureContractStorage : IContractStorage
    {
        public void UploadContract(string key, ExtendedContractType extendedContract)
        {
            AzureStorageWrapper.PutBlockBlob(
                CreateFctFile(key),
                extendedContract.ConvertObjectToByteArray());
        }

        public ExtendedContractType GetContract(string key)
        {
            FctFile fctFile = CreateFctFile(key);
            byte[] objectBytes = AzureStorageWrapper.GetBlockBlobContents(fctFile);

            return objectBytes.ConvertByteArrayToObject<ExtendedContractType>();
        }

        public void RemoveContract(string key)
        {
            FctFile fctFile = CreateFctFile(key);
            AzureStorageWrapper.DeleteBlockBlob(fctFile);
        }

        public string GetKey(string contractNumber, int version)
        {
            return $"{contractNumber}____{version}";
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