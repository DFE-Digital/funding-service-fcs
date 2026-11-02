namespace WorkerRole.Tests.Services
{
    using System;
    using System.Configuration;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;

    [TestClass]
    public class LargeMessageStorageServiceTests
    {
        private string ContainerName => $"fcs-large-message{GetEnvironmentSuffix()}";

        [TestMethod, TestCategory("IntegrationTest")]
        public void LargeMessageStorageService_ShouldStoreMessageBody()
        {
            // arrange
            const string fileName = "some_file_worker";
            byte[] fileContents = new byte[10] { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
            AzureStorageWrapper.CreateIfNotExists(ContainerName);
            AzureStorageWrapper.DeleteBlockBlob(new FctFile(ContainerName, fileName));

            AzureStorageWrapper.PutBlockBlob(new FctFile(ContainerName, fileName), fileContents);
            // act
            var body = LargeMessageStorageService.GetMessageBody(fileName);

            // assert
            Assert.IsTrue(fileContents.SequenceEqual(body));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void LargeMessageStorageService_ShouldGetMessageBody()
        {
            // arrange
            byte[] fileContents = new byte[10] { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
            AzureStorageWrapper.CreateIfNotExists(ContainerName);
            var key = Guid.NewGuid().ToString();
            // act
            LargeMessageStorageService.StoreMessageBody(key, fileContents);

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
