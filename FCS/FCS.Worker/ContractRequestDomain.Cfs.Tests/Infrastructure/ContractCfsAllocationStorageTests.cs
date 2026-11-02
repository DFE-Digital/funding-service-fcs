namespace ContractRequestDomain.Cfs.Tests.Infrastructure
{
    using System;
    using Cfs.Infrastructure;
    using Dto;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    [TestClass]
    public class ContractCfsAllocationStorageTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractCfsAllocationStorage_ShouldStore()
        {
            // arrange
            ContractCfsAllocationStorage contractCfsAllocationStorage = new ContractCfsAllocationStorage();
            ContractCfsAllocation contractCfsAllocation = new ContractCfsAllocation
            {
                CfsAllocationId = Guid.NewGuid(),
                Contract = new ExtendedContractType
                {
                    contractNumber = "Test1",
                    contractVersionNumber = 1
                }
            };

            string key = contractCfsAllocationStorage.GetKey(contractCfsAllocation.Contract.contractNumber,
                contractCfsAllocation.Contract.contractVersionNumber);

            // act
            contractCfsAllocationStorage.UploadContract(key, contractCfsAllocation);

            // assert
            var retrievedContractCfsAllocation = contractCfsAllocationStorage.GetContract(key);

            Assert.IsNotNull(retrievedContractCfsAllocation, "The ContractCfsAllocation has not been retrieved");
            Assert.AreEqual(contractCfsAllocation.Contract.contractNumber, retrievedContractCfsAllocation.Contract.contractNumber, "The contract number is not correct");
            Assert.AreEqual(contractCfsAllocation.Contract.contractVersionNumber, retrievedContractCfsAllocation.Contract.contractVersionNumber, "The contractVersionNumber is not correct");
        }
    }
}
