namespace ContractCreateDomain.Tests.Repositories
{
    using System;
    using System.Configuration;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Common.Repositories;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;

    [TestClass]
    public class LargeMessageRepositoryTests
    {
        private string ContainerName =>  $"fcs-large-message{GetEnvironmentSuffix()}";

        [TestMethod, TestCategory("IntegrationTest")]
        public void LargeMessageRepository_ShouldGetMessageBody()
        {
            // arrange
            const string fileName = "some_file_1";
            byte[] fileContents = new byte[10]{1,2,3,4,5,6,7,8,9,10};
            AzureStorageWrapper.CreateIfNotExists(ContainerName);
            AzureStorageWrapper.DeleteBlockBlob(new FctFile(ContainerName, fileName));

            AzureStorageWrapper.PutBlockBlob(new FctFile(ContainerName, fileName), fileContents);
            // act
            var body = LargeMessageRepository.GetMessageBody(fileName);
            
            // assert
            Assert.IsTrue(fileContents.SequenceEqual(body));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void LargeMessageRepository_ShouldStoreMessageBody()
        {
            // arrange
            byte[] fileContents = new byte[10] { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
            AzureStorageWrapper.CreateIfNotExists(ContainerName);
            string key = Guid.NewGuid().ToString();
            
            // act
            LargeMessageRepository.StoreMessageBody(key, fileContents);

            // assert
            var body = AzureStorageWrapper.GetBlobContents(new FctFile(ContainerName, key)).Contents;

            Assert.IsTrue(fileContents.SequenceEqual(body));

            // clear down
            AzureStorageWrapper.DeleteBlockBlob(new FctFile(ContainerName, key));
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
