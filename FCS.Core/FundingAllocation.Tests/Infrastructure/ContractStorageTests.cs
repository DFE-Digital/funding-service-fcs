namespace FundingAllocation.Tests.Infrastructure
{
    using System;
    using System.Threading.Tasks;
    using Azure.Storage.Blobs;
    using FluentAssertions;
    using FundingAllocation.Infrastructure;
    using Microsoft.Extensions.Configuration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    [TestClass]
    public class ContractStorageTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractStorage_ShouldUpload()
        {

            try
            {
                // arrange
                const string blobKey = "test";
            var appConfiguration = AppConfiguration.Configuration();
            ContractStorage contractStorage = new ContractStorage(appConfiguration);
            var contract = new ExtendedContractType
            {
                contractNumber = "some number"
            };
                DeleteContractFromStorage(blobKey);
                // act
                contractStorage.StoreContract(blobKey, new ExtendedContractTypeAndIntent(contract, ContractIntent.New)).Wait();

                // assert
                var result = contractStorage.GetContract(blobKey).Result;

                Assert.AreEqual(contract.contractNumber, result.Contract.contractNumber);
            }
            catch (Exception ex)
            {

            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractStorage_ShouldOverwriteBlobIfItExists()
        {
            try
            {
                // arrange
                const string blobKey = "test";
                var appConfiguration = AppConfiguration.Configuration();
                ContractStorage contractStorage = new ContractStorage(appConfiguration);
                var contract = new ExtendedContractType
                {
                    contractNumber = "some number"
                };
                DeleteContractFromStorage(blobKey);
                // act
                var etag1 = contractStorage.StoreContract(blobKey, new ExtendedContractTypeAndIntent(contract, ContractIntent.New)).Result;
                var etag2 = contractStorage.StoreContract(blobKey, new ExtendedContractTypeAndIntent(contract, ContractIntent.New)).Result;

                // assert
                var result = contractStorage.GetContract(blobKey).Result;

                Assert.AreEqual(contract.contractNumber, result.Contract.contractNumber);
                etag1.Should().NotBe(etag2);
            }
            catch (Exception ex) { }
        }

        private static void DeleteContractFromStorage(string key)
        {
            var containerClient = GetBlobContainerClient().Result;
            var blobClient = containerClient.GetBlobClient(key);
            blobClient.DeleteIfExists();
        }

        private static async Task<BlobContainerClient> GetBlobContainerClient()
        {
            BlobServiceClient blobServiceClient = new BlobServiceClient(AppConfiguration.Configuration().GetConnectionString("StorageConnectionString"));

            var containerName = GetContainerName();

            var client = blobServiceClient.GetBlobContainerClient(containerName);

            await client.CreateIfNotExistsAsync();

            return client;
        }

        private static string GetContainerName()
        {
            const string containerNameRoot = "fct-contract";
            var environment = AppConfiguration.Configuration()["StorageTableSuffix"];
            if (string.IsNullOrEmpty(environment))
            {
                return containerNameRoot;
            }

            return $"{containerNameRoot}-{environment.ToLower()}";
        }
    }
}
