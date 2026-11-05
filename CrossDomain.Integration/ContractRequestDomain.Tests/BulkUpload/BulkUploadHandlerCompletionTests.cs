namespace ContractRequestDomain.Tests.BulkUpload
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.WindowsAzure.Storage.Table;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Interfaces;
    using SFA.FCT.ContractRequestDomain.Common;
    using SFA.FCT.ContractRequestDomain.Common.Commands;
    using SFA.FCT.ContractRequestDomain.Integration.BulkUpload;
    using SFA.FCT.ContractRequestDomain.Integration.BulkUpload.Repositories;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Common.Serializers;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class BulkUploadHandlerCompletionTests
    {
        private Mock<IAzureTableStore> _tableStore;
        private Mock<IBulkUploadFileAccess> _fileAccess;
        private Mock<IGenerateResultsReport> _report;
        private BulkUploadHandler _handler;

        [TestInitialize]
        public void Setup()
        {
            _tableStore = new Mock<IAzureTableStore>();
            _fileAccess = new Mock<IBulkUploadFileAccess>();
            _report = new Mock<IGenerateResultsReport>();
            _handler = new BulkUploadHandler
            {
                Data = new BulkUploadSagaData { BatchId = "batch", FileName = "file.xlsx", Timestamp = "ts" },
                Logger = Mock.Of<ILogger>(),
                AzureTableStore = _tableStore.Object,
                BulkUploadFileAccess = _fileAccess.Object,
                GenerateResultsReport = _report.Object
            };
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Timeout_GeneratesResultsFileMovesProcessingRowAndPublishesCompletion()
        {
            var result = new SagaContractRequestResult(new contractRequestType
            {
                correlationInfo = new correlationInfoType { batchId = "batch", correlationId = "c1" }
            });
            var rows = new List<BulkUploadProcessingEntity>
            {
                new BulkUploadProcessingEntity { Complete = true, ContractRequestResult = ZipHelper.ToZippedBytesFromBytes(result.SerializedContractRequestResult) },
                new BulkUploadProcessingEntity { Complete = false, ContractRequestResult = new byte[0] }
            };
            var locations = new[] { new ExcelLocation { CorrelationId = "c1", Sheet = "S", Row = 3 } };
            var mappingRows = new List<BulkUploadLocationMappingEntity>
            {
                new BulkUploadLocationMappingEntity { RowKey = "0", LocationMapping = locations.ConvertObjectToByteArray() }
            };
            var processingRow = new FileWatcherProcessingEntity { PartitionKey = "file.xlsx", RowKey = "ts", BatchId = "batch" };

            _tableStore.Setup(t => t.GetRows<BulkUploadProcessingEntity>(EndpointConfig.BulkImportProcessingTable, "batch")).Returns(rows);
            _tableStore.Setup(t => t.GetRows<BulkUploadLocationMappingEntity>(EndpointConfig.BulkImportLocationMappingTable, "batch")).Returns(mappingRows);
            _tableStore.Setup(t => t.GetRow<FileWatcherProcessingEntity>(It.IsAny<string>(), "file.xlsx", "ts")).Returns(processingRow);
            _fileAccess.Setup(f => f.GetProcessingFileContents("file.xlsx")).Returns(new byte[] { 1 });
            _report.Setup(r => r.GenerateReport(It.IsAny<byte[]>(), It.IsAny<ContractRequestResult[]>(), It.IsAny<ExcelLocation[]>())).Returns(new byte[] { 9 });
            var context = new TestableMessageHandlerContext();

            _handler.Timeout(_handler.Data, context).Wait();

            _report.Verify(r => r.GenerateReport(It.IsAny<byte[]>(), It.Is<ContractRequestResult[]>(x => x.Length == 1), It.Is<ExcelLocation[]>(x => x.Length == 1 && x[0].Row == 3)), Times.Once());
            _fileAccess.Verify(f => f.CreateResultsReport("file.xlsx", It.Is<byte[]>(b => b.Length == 1 && b[0] == 9)), Times.Once());
            _tableStore.Verify(t => t.DeleteRow(It.IsAny<string>(), "file.xlsx", "ts"), Times.Once());
            _tableStore.Verify(t => t.CreateRow(It.IsAny<string>(), It.Is<FileWatcherProcessedEntity>(e => e.Result == "COMPLETE" && e.BatchId == "batch")), Times.Once());
            _tableStore.Verify(t => t.DeleteRows(EndpointConfig.BulkImportProcessingTable, "batch"), Times.Once());
            _tableStore.Verify(t => t.DeleteRows(EndpointConfig.BulkImportLocationMappingTable, "batch"), Times.Once());
            Assert.IsTrue(_handler.Completed);
            Assert.AreEqual(1, context.PublishedMessages.Length);
            Assert.IsInstanceOfType(context.PublishedMessages[0].Message, typeof(BulkUploadCompleteEvent));
        }
    }
}
