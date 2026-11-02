namespace FundingAllocation.Tests.Storage
{
    using System.IO;
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class AzureStorageRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void AzureStorageRepository_GetBlockBlob_ShouldReturnData()
        {
            // arrange
            const string filename = "test-filename";
            var appConfiguration = AppConfiguration.Configuration();
            string azureStorageConnectionString = appConfiguration["ConnectionStrings:StorageConnectionString"];
            byte[] contents = new [] {byte.MinValue};

            FundingAllocation.Storage.AzureStorageRepository.PutBlockBlob(azureStorageConnectionString, filename, GetContainerName(), contents);

            // act
            var cloudBlockBlob =
                FundingAllocation.Storage.AzureStorageRepository.GetBlockBlob(azureStorageConnectionString,
                    filename,
                    GetContainerName());

            // assert
            using MemoryStream blobStream = new MemoryStream();
            cloudBlockBlob.DownloadToStreamAsync(blobStream).Wait();

            blobStream.ToArray().Should().BeEquivalentTo(contents);
        }

        private string GetContainerName()
        {
            return $"fcs-large-message{GetEnvironmentSuffix()}";
        }

        private string GetEnvironmentSuffix()
        {
            string environment = AppConfiguration.Configuration()["StorageTableSuffix"].ToLower();

            if (!string.IsNullOrEmpty(environment))
            {
                return "-" + environment;
            }

            return environment;
        }
    }

}
