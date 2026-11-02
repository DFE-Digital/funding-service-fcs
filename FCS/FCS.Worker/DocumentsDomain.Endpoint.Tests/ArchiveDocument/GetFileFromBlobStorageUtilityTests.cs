namespace DocumentsDomain.Endpoint.Tests.ArchiveDocument
{
    using System.Configuration;
    using System.IO;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;

    [TestClass]
    public class GetFileFromBlobStorageUtilityTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void GetAFileFromBlobStorage_FromContainerName_fcs_document_archive()
        {
            // arrange
            var containerName = $"fcs-document-archive{GetEnvironmentSuffix()}";

            AzureStorageWrapper.CreateIfNotExists(containerName);

            // Get guid below from [DocumentsDomain].[ArchivedDocument] PAAS table using the filename
            // Note:- files in DAT blob storage refreshes every night so guid below will not exist in storage
            const string blobGuid = "9eaa73ec-4faa-d42b-3e79-282fdd3df20c";
            var fctFile = new FctFile(containerName, blobGuid);

            // act
            var bytes = AzureStorageWrapper.GetBlockBlobContents(fctFile);
            File.WriteAllBytes($"file_{blobGuid.Substring(0, 7)}.pdf", bytes);
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