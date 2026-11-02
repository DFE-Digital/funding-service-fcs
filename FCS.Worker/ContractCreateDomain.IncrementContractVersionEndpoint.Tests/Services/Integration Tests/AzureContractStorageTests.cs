namespace ContractCreateDomain.IncrementContractVersionEndpoint.Tests.Services.Integration_Tests
{
    using System;
    using IncrementContractVersionEndpoint.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    [TestClass]
    public class AzureContractStorageTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void AzureContractStorage_ShouldUpload()
        {
            // arrange
            const string contractNumber = "XX";
            const int version = 1;

            AzureContractStorage azureContractStorage = new AzureContractStorage();
            string key = azureContractStorage.GetKey(contractNumber, version);

            // act
            azureContractStorage.UploadContract(key, GetExtendedContractType(contractNumber, version));

            // assert
            ExtendedContractType retrievedContract = azureContractStorage.GetContract(key);

            Assert.AreEqual(contractNumber, retrievedContract.contractNumber);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AzureContractStorage_ShouldRemoveContract()
        {
            // arrange
            const string contractNumber = "XX";
            const int version = 1;

            AzureContractStorage azureContractStorage = new AzureContractStorage();
            string key = azureContractStorage.GetKey(contractNumber, version);
            azureContractStorage.UploadContract(key, GetExtendedContractType(contractNumber, version));

            // act
            azureContractStorage.RemoveContract(key);

            // assert
            bool hasExceptionBeenThrown = false;
            try
            {
                ExtendedContractType retrievedContract = azureContractStorage.GetContract(key);
            }
            catch (Exception)
            {
                hasExceptionBeenThrown = true;
            }

            Assert.AreEqual(true, hasExceptionBeenThrown);
        }

        private ExtendedContractType GetExtendedContractType(string contractNumber, int version)
        {
            return new ExtendedContractType
            {
                contractNumber = contractNumber,
                contractVersionNumber = version
            };
        }
    }
}