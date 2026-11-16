namespace ContractRequestDomain.Tests.BulkUpload
{
    extern alias CSICommon;
    using System;
    using System.IO;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using Newtonsoft.Json;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Interfaces;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Services;
    using SFA.FCT.ContractRequestDomain.Integration.BulkUpload;
    using CSICommon::SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Entities.ExcelUpload;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using UnitTests.Common;

    [TestClass]
    public class BulkUploadHandlerTechnicalExplorationTests
    {
        [TestMethod, TestCategory("TechnicalExploration_BulkUpdate")]
        public void BulkUploadHandler_ShouldAddLocationMappingToBulkImportLocationMappingTable()
        {
            // arrange
            BulkUploadHandler handler = new BulkUploadHandler
            {
                AzureTableStore = new AzureTableStore(),
                LocationMapper = new LocationMapper(),
                Data = new BulkUploadSagaData
                {
                    BatchId = Guid.NewGuid().ToString()
                },
            
               Logger = new Mock<ILogger>().Object
            };

            dataLoadResults dataLoadResults = GetDataLoadResults();

            var contractRequests = new TransformToContractRequest().Transform(dataLoadResults);

            handler.PublishContractRequestEvent(contractRequests, dataLoadResults, null);
        }

        [TestMethod, TestCategory("TechnicalExploration_BulkUpdate")]
        public void BulkUploadHandler_ShouldProcessContractRequestProcessedCommand()
        {
            // arrange
            Mock<IBulkUploadFileAccess> bulkUploadFileAccess = new Mock<IBulkUploadFileAccess>();
            bulkUploadFileAccess.Setup(bufa => bufa.GetProcessingFileContents(It.IsAny<string>()))
                .Returns(GetFileAsBytes());
            ContractRequestProcessedCommand command = GetContractRequestProcessedCommand();
            BulkUploadHandler handler = new BulkUploadHandler
            {
                AzureTableStore = new AzureTableStore(),
                LocationMapper = new LocationMapper(),
                Data = new BulkUploadSagaData
                {
                    BatchId = command.ContractRequest.correlationInfo.batchId,
                    FileName = "1619FUND AY 1718 15062017170719 v3_10021424Update3.xlsx"
                },
                Logger = new Mock<ILogger>().Object,
                BulkUploadFileAccess = bulkUploadFileAccess.Object,
                GenerateResultsReport = new GenerateResultsReport()
            };

            handler.Handle(command, null);
        }

        private byte[] GetFileAsBytes()
        {
            using (TestResource resource = new TestResource("ContractRequestDomain.Tests", @"Resources.1619FUND AY 1718 15062017170719 v3_10021424Update3.xlsx"))
            {

                resource.Stream.Position = 0;
                byte[] buffer = new byte[resource.Stream.Length];
                for (int totalBytesCopied = 0; totalBytesCopied < resource.Stream.Length;)
                {
                    totalBytesCopied += resource.Stream.Read(buffer, totalBytesCopied, Convert.ToInt32(resource.Stream.Length) - totalBytesCopied);
                }
                    
                return buffer;
            }
        }

        private dataLoadResults GetDataLoadResults()
        {
            using (TestResource resource = new TestResource("ContractRequestDomain.Tests", @"Resources.1619FUND AY 1718 15062017170719 v3_10021424Update3.xlsx"))
            {
                return new ExcelFileParser().ReadFile(resource.Stream, "TestFile.xlsx");
            }
        }

        private ContractRequestProcessedCommand GetContractRequestProcessedCommand()
        {
            using (TestResource resource = new TestResource("ContractRequestDomain.Tests",
                    @"Resources.ContractRequestProcessedCommand.json"))
            {
                using (StreamReader sr = new StreamReader(resource.Stream))
                {
                    return JsonConvert.DeserializeObject<ContractRequestProcessedCommand>(sr.ReadToEnd());
                }
            }
        }
    }
}
