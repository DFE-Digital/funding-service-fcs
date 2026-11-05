namespace ContractRequestDomain.Tests.BulkUpload
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Reflection;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.ContractRequestDomain.Common;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Interfaces;
    using SFA.FCT.ContractRequestDomain.Common.Commands;
    using SFA.FCT.ContractRequestDomain.Integration.BulkUpload;
    using SFA.FCT.ContractRequestDomain.Integration.BulkUpload.Repositories;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class BulkUploadHandlerStartAndTimeoutTests
    {
        private Mock<IAzureTableStore> _tableStore;
        private Mock<IBulkUploadFileAccess> _fileAccess;
        private BulkUploadHandler _handler;

        private class UploadEvent : INewExcelUploadFileEvent
        {
            public string UploadedFilename { get; set; }

            public string BatchId { get; set; }
        }

        [TestInitialize]
        public void Setup()
        {
            _tableStore = new Mock<IAzureTableStore>();
            _fileAccess = new Mock<IBulkUploadFileAccess>();
            _handler = new BulkUploadHandler
            {
                Data = new BulkUploadSagaData(),
                Logger = Mock.Of<ILogger>(),
                AzureTableStore = _tableStore.Object,
                BulkUploadFileAccess = _fileAccess.Object
            };
        }

        [TestMethod, TestCategory("UnitTest")]
        public void NewExcelUploadFile_NotYetProcessed_RecordsTimestampCommitsAndSendsStartCommand()
        {
            var timestamp = new DateTime(2020, 1, 2, 3, 4, 5, DateTimeKind.Utc);
            _fileAccess.Setup(f => f.GetFileTimestamp("new.xlsx")).Returns(timestamp);
            var context = new TestableMessageHandlerContext();

            _handler.Handle(new UploadEvent { UploadedFilename = "new.xlsx", BatchId = "b1" }, context).Wait();

            Assert.AreEqual("b1", _handler.Data.BatchId);
            Assert.AreEqual("new.xlsx", _handler.Data.FileName);
            Assert.AreEqual(timestamp.ToString("O", System.Globalization.DateTimeFormatInfo.InvariantInfo), _handler.Data.Timestamp);
            Assert.AreEqual(1, context.SentMessages.Length);
            var sent = (StartBulkImportProcessingCommand)context.SentMessages[0].Message;
            Assert.AreEqual("b1", sent.BatchId);
            Assert.AreEqual("new.xlsx", sent.Filename);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Timeout_WhenCompletionFails_StillPublishesBulkUploadComplete()
        {
            _handler.Data.BatchId = "b2";
            _tableStore.Setup(t => t.GetRows<BulkUploadProcessingEntity>(It.IsAny<string>(), It.IsAny<string>()))
                .Throws(new InvalidOperationException("boom"));
            var context = new TestableMessageHandlerContext();

            _handler.Timeout(_handler.Data, context).Wait();

            Assert.AreEqual(1, context.PublishedMessages.Length);
            var published = (BulkUploadCompleteEvent)context.PublishedMessages[0].Message;
            Assert.AreEqual("b2", published.BatchId);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AddLocationMappingToBulkImportLocationMappingTable_LargeMapping_UploadsInBatchesOfTen()
        {
            _handler.Data.BatchId = "b3";
            var mapping = Enumerable.Range(0, 12).ToDictionary(
                i => "c" + i,
                i => new ExcelLocation { CorrelationId = "c" + i, Sheet = new string('x', 40 * 1024), Row = i });
            var batches = new List<int>();
            _tableStore.Setup(t => t.CreateRows(EndpointConfig.BulkImportLocationMappingTable, It.IsAny<IEnumerable<BulkUploadLocationMappingEntity>>()))
                .Callback<string, IEnumerable<BulkUploadLocationMappingEntity>>((table, rows) => batches.Add(rows.Count()));

            typeof(BulkUploadHandler)
                .GetMethod("AddLocationMappingToBulkImportLocationMappingTable", BindingFlags.Instance | BindingFlags.NonPublic)
                .Invoke(_handler, new object[] { mapping });

            Assert.IsTrue(batches.Count >= 2, "Expected a full batch followed by a remainder");
            Assert.AreEqual(10, batches[0]);
            Assert.IsTrue(batches.Skip(1).All(b => b > 0 && b <= 10));
        }
    }
}
