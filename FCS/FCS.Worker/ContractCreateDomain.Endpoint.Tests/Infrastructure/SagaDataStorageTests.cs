namespace ContractCreateDomain.Endpoint.Tests.Infrastructure
{
    using System;
    using Endpoint.Infrastructure;
    using Endpoint.Infrastructure.DTOs;
    using Endpoint.Infrastructure.Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Newtonsoft.Json;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    [TestClass]
    public class SagaDataStorageTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void SagaDataStorage_ShouldUpload()
        {
            SagaDataStorage storage = new SagaDataStorage();

            ExtendedContract contract = new ExtendedContract
            {
                contractNumber = "XX"
            };

            ModifyContractSagaData data = new ModifyContractSagaData
            {
                ProcessId = Guid.NewGuid().ToString(),
                ExtendedCorporateContract = contract.ConvertObjectToByteArray()
            };

            string key = data.ProcessId;

            SagaStorageValue sagaDataStorage = new SagaStorageValue(data, Intent.Update);

            // act
            storage.UploadSagaData(key, sagaDataStorage);

            // assert
            var dataRetrieved = storage.GetSagaData<SagaStorageValue>(key);

            Assert.IsNotNull(dataRetrieved, "The ModifyContractSagaData has not been retrieved");
            Assert.AreEqual(Intent.Update, dataRetrieved.Intent, "The Intent is not correct");
            ExtendedContract returnedExtendedContract = JsonConvert.DeserializeObject<ModifyContractSagaData>(dataRetrieved.SagaDataAsJson).ExtendedCorporateContract.ConvertByteArrayToObject<ExtendedContract>();
            Assert.AreEqual(contract.contractNumber, returnedExtendedContract.contractNumber, "The contractNumber is not correct");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void SagaDataStorage_ShouldUploadIfEtagHasNotChanged()
        {
            SagaDataStorage storage = new SagaDataStorage();

            ExtendedContract contract = new ExtendedContract
            {
                contractNumber = "XX"
            };

            ModifyContractSagaData data = new ModifyContractSagaData
            {
                ProcessId = Guid.NewGuid().ToString(),
                ExtendedCorporateContract = contract.ConvertObjectToByteArray()
            };

            string key = data.ProcessId;

            SagaStorageValue sagaDataStorage = new SagaStorageValue(data, Intent.Update);
            storage.UploadSagaData(key, sagaDataStorage);
            var sagaWithEtag = storage.GetSagaData<SagaStorageValue>(key);
            Assert.IsNotNull(sagaWithEtag.Etag, "Etag not set");

            // act
            try
            {
                storage.UploadSagaData(key, sagaDataStorage);
            }
            catch (Exception)
            {
                // assert
                Assert.Fail("The update has not worked");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void SagaDataStorage_ShouldNotUploadIfEtagHashanged()
        {
            SagaDataStorage storage = new SagaDataStorage();

            ExtendedContract contract = new ExtendedContract
            {
                contractNumber = "XX"
            };

            ModifyContractSagaData data = new ModifyContractSagaData
            {
                ProcessId = Guid.NewGuid().ToString(),
                ExtendedCorporateContract = contract.ConvertObjectToByteArray()
            };

            string key = data.ProcessId;

            SagaStorageValue sagaDataStorage = new SagaStorageValue(data, Intent.Update);
            storage.UploadSagaData(key, sagaDataStorage);
            var sagaWithEtag = storage.GetSagaData<SagaStorageValue>(key);
            Assert.IsNotNull(sagaWithEtag.Etag, "Etag is not set");
            string originalEtag = sagaWithEtag.Etag;

            // this will reset the etag
            storage.UploadSagaData(key, sagaWithEtag);

            sagaWithEtag = storage.GetSagaData<SagaStorageValue>(key);
            Assert.AreNotEqual(originalEtag, sagaWithEtag.Etag, "The etag has not been updated");
            sagaWithEtag.Etag = originalEtag;

            bool exceptionThrown = false;
            // act
            try
            {
                storage.UploadSagaData(key, sagaWithEtag);
            }
            catch (Exception)
            {                 
                exceptionThrown = true;
            }

            // assert
            Assert.IsTrue(exceptionThrown);
        }
    }
}
