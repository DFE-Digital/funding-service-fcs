namespace ContractManagement.Cfs.ContractCreate.Services
{
    using System.Configuration;
    using Dtos;
    using Newtonsoft.Json;
    using SFA.FCT.CrossDomain.Integration.Common.Serializers;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;

    public class ContractCfsAllocationRetrievalService : IContractCfsAllocationRetrievalService
    { 
        public ContractCfsAllocation GetContractCfsAllocation(string key)
        {
            FctFile fctFile = CreateFctFile(key);
            byte[] objectBytes = AzureStorageWrapper.GetBlockBlobContents(fctFile);

            string json = objectBytes.ConvertByteArrayToObject<string>();

            return JsonConvert.DeserializeObject<ContractCfsAllocation>(json);
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
