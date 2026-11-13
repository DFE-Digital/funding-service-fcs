namespace ContractRequestDomain.Tests.BulkUpload
{
    using System;
    using SFA.FCT.ContractRequestDomain.Common;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Interfaces;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Entities.ExcelUpload;
    using SFA.FCT.ContractRequestDomain.Common.Commands;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.ContractRequestDomain.Integration.BulkUpload;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.ContractRequestDomain.Integration.BulkUpload.Repositories;

    [TestClass]
    public class BulkUploadHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void BulkUploadHandler_ShouldMoveFileToProcessedWhenAlreadyInProcessing()
        {
            // arrange
            var handler = new BulkUploadHandler();
            handler.Data = new BulkUploadSagaData();
            var loggerMock = new Mock<ILogger>();
            var bulkUploadMock = new Mock<IBulkUploadFileAccess>();
            handler.Logger = loggerMock.Object;
            handler.BulkUploadFileAccess = bulkUploadMock.Object;
            bulkUploadMock.Setup(b => b.DoesFileExistInProcessing(It.IsAny<string>())).Returns(true);
            bulkUploadMock.Setup(b => b.DoesFileExistInInputFolder(It.IsAny<string>())).Returns(true);
            var contextMock = new TestableMessageHandlerContext();
            // act
            handler.Handle(new NewExcelUploadFileEvent(), contextMock).Wait();

            // assert
            bulkUploadMock.Verify(b => b.MoveRejectedFileFromInputToProcessed(It.IsAny<string>(), FileRejectionReason.Duplicate));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void BulkUploadHandler_ShouldMoveFileToProcessedWhenAlreadyInProcessed()
        {
            // arrange
            var handler = new BulkUploadHandler();
            handler.Data = new BulkUploadSagaData();
            var loggerMock = new Mock<ILogger>();
            var bulkUploadMock = new Mock<IBulkUploadFileAccess>();
            handler.Logger = loggerMock.Object;
            handler.BulkUploadFileAccess = bulkUploadMock.Object;
            bulkUploadMock.Setup(b => b.DoesFileExistInProcessedFolder(It.IsAny<string>())).Returns(true);
            bulkUploadMock.Setup(b => b.DoesFileExistInInputFolder(It.IsAny<string>())).Returns(true);
            var contextMock = new TestableMessageHandlerContext();
            
            // act
            handler.Handle(new NewExcelUploadFileEvent(), contextMock).Wait();

            // assert
            bulkUploadMock.Verify(b => b.MoveRejectedFileFromInputToProcessed(It.IsAny<string>(), FileRejectionReason.Duplicate));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void StartBulkImportProcessing_ShouldRejectFileWhenInitialValidationFails()
        {
            var fileAccess = new Mock<IBulkUploadFileAccess>();
            var fileParser = new Mock<IExcelFileParser>();
            var validation = new Mock<ICheckForErrorValidation>();
            var tableStore = new Mock<IAzureTableStore>();
            var fileName = "upload.xlsx";
            var results = new dataLoadResults
            {
                fileName = fileName,
                error = new[] { new errorInfo { Value = "Invalid file" } }
            };
            var processingRow = new FileWatcherProcessingEntity
            {
                PartitionKey = fileName,
                RowKey = "timestamp"
            };
            var context = new TestableMessageHandlerContext();
            var handler = new BulkUploadHandler
            {
                Data = new BulkUploadSagaData { BatchId = "batch", Timestamp = "timestamp" },
                Logger = Mock.Of<ILogger>(),
                BulkUploadFileAccess = fileAccess.Object,
                FileParser = fileParser.Object,
                CheckForErrorValidation = validation.Object,
                AzureTableStore = tableStore.Object
            };

            fileAccess.Setup(x => x.GetProcessingFileContents(fileName)).Returns(new byte[0]);
            fileParser.Setup(x => x.ReadFile(It.IsAny<System.IO.Stream>(), fileName)).Returns(results);
            validation.Setup(x => x.Validate(results)).Returns(false);
            tableStore.Setup(x => x.GetRow<FileWatcherProcessingEntity>(It.IsAny<string>(), fileName, "timestamp"))
                .Returns(processingRow);

            handler.Handle(new StartBulkImportProcessingCommand { BatchId = "batch", Filename = fileName }, context).Wait();

            fileAccess.Verify(x => x.MoveRejectedFileFromProcessing(fileName, It.Is<string>(name => name.StartsWith(fileName + ".Rejected", StringComparison.Ordinal))));
            fileAccess.Verify(x => x.CreateSyntaxReport(It.Is<string>(name => name.StartsWith(fileName + ".Rejected", StringComparison.Ordinal)), It.Is<string>(report => report.Contains("Invalid file"))));
            tableStore.Verify(x => x.DeleteRow(It.IsAny<string>(), fileName, "timestamp"));
            tableStore.Verify(x => x.CreateRow(It.IsAny<string>(), It.Is<FileWatcherProcessedEntity>(entity => entity.Result == "FAILED SYNTAX")));
            Assert.AreEqual(0, context.SentMessages.Length);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void StartBulkImportProcessing_ShouldStopAfterFileLevelValidationFails()
        {
            var fileAccess = new Mock<IBulkUploadFileAccess>();
            var fileParser = new Mock<IExcelFileParser>();
            var validation = new Mock<ICheckForErrorValidation>();
            var fscEnrichment = new Mock<IFileValidationFscEnrichment>();
            var fileLevelValidation = new Mock<IContractBulkUploadFileLevelValidation>();
            var sessionConnectionFactory = new Mock<ISessionConnectionFactory>();
            var tableStore = new Mock<IAzureTableStore>();
            var fileName = "upload.xlsx";
            var results = new dataLoadResults { fileName = fileName };
            var processingRow = new FileWatcherProcessingEntity
            {
                PartitionKey = fileName,
                RowKey = "timestamp"
            };
            var context = new TestableMessageHandlerContext();
            var connectionInfo = ConnectionInfo.CreateDefault();
            var handler = new BulkUploadHandler
            {
                Data = new BulkUploadSagaData { BatchId = "batch", Timestamp = "timestamp" },
                Logger = Mock.Of<ILogger>(),
                BulkUploadFileAccess = fileAccess.Object,
                FileParser = fileParser.Object,
                CheckForErrorValidation = validation.Object,
                FileValidationFscEnrichment = fscEnrichment.Object,
                ContractBulkUploadFileLevelValidation = fileLevelValidation.Object,
                SessionConnectionFactory = sessionConnectionFactory.Object,
                AzureTableStore = tableStore.Object
            };

            fileAccess.Setup(x => x.GetProcessingFileContents(fileName)).Returns(new byte[0]);
            fileParser.Setup(x => x.ReadFile(It.IsAny<System.IO.Stream>(), fileName)).Returns(results);
            validation.Setup(x => x.Validate(results)).Returns(true);
            sessionConnectionFactory.Setup(x => x.GetConnection(context)).Returns(connectionInfo);
            fileLevelValidation.Setup(x => x.ValidateFile(results, connectionInfo)).Returns(false);
            tableStore.Setup(x => x.GetRow<FileWatcherProcessingEntity>(It.IsAny<string>(), fileName, "timestamp"))
                .Returns(processingRow);

            handler.Handle(new StartBulkImportProcessingCommand { BatchId = "batch", Filename = fileName }, context).Wait();

            fscEnrichment.Verify(x => x.Enrich(results));
            tableStore.Verify(x => x.ReplaceRow(It.IsAny<string>(), processingRow));
            fileAccess.Verify(x => x.CreateSyntaxReport(fileName, It.Is<string>(report => report.Contains("Success"))));
            Assert.AreEqual(0, context.SentMessages.Length);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void StartBulkImportProcessing_ShouldContinueWhenValidationSucceeds()
        {
            var fileAccess = new Mock<IBulkUploadFileAccess>();
            var fileParser = new Mock<IExcelFileParser>();
            var validation = new Mock<ICheckForErrorValidation>();
            var fscEnrichment = new Mock<IFileValidationFscEnrichment>();
            var fileLevelValidation = new Mock<IContractBulkUploadFileLevelValidation>();
            var syntaxValidation = new Mock<IContractSyntaxValidation>();
            var transformer = new Mock<ITransformToContractRequest>();
            var locationMapper = new Mock<ILocationMapper>();
            var sessionConnectionFactory = new Mock<ISessionConnectionFactory>();
            var tableStore = new Mock<IAzureTableStore>();
            var fileName = "upload.xlsx";
            var results = new dataLoadResults { fileName = fileName };
            var request = new contractRequestType
            {
                correlationInfo = new correlationInfoType { batchId = "batch", correlationId = "correlation" },
                contract = new contractType
                {
                    fundingTypeCode = "DAS",
                    contracts = new System.Collections.Generic.List<contractType>
                    {
                        new contractType
                        {
                            period = new periodType
                            {
                                periodType1 = new periodTypeType { periodTypeCode = "AY" },
                                period = "2025"
                            }
                        }
                    }
                },
                errorInfo = new System.Collections.Generic.List<errorInfoType>
                {
                    new errorInfoType { Value = "Request requires correction" }
                }
            };
            var processingRow = new FileWatcherProcessingEntity
            {
                PartitionKey = fileName,
                RowKey = "timestamp"
            };
            var context = new TestableMessageHandlerContext();
            var connectionInfo = ConnectionInfo.CreateDefault();
            var handler = new BulkUploadHandler
            {
                Data = new BulkUploadSagaData { BatchId = "batch", Timestamp = "timestamp" },
                Logger = Mock.Of<ILogger>(),
                BulkUploadFileAccess = fileAccess.Object,
                FileParser = fileParser.Object,
                CheckForErrorValidation = validation.Object,
                FileValidationFscEnrichment = fscEnrichment.Object,
                ContractBulkUploadFileLevelValidation = fileLevelValidation.Object,
                ContractSyntaxValidation = syntaxValidation.Object,
                TransformToContractRequest = transformer.Object,
                LocationMapper = locationMapper.Object,
                SessionConnectionFactory = sessionConnectionFactory.Object,
                AzureTableStore = tableStore.Object
            };

            fileAccess.Setup(x => x.GetProcessingFileContents(fileName)).Returns(new byte[0]);
            fileParser.Setup(x => x.ReadFile(It.IsAny<System.IO.Stream>(), fileName)).Returns(results);
            validation.Setup(x => x.Validate(results)).Returns(true);
            sessionConnectionFactory.Setup(x => x.GetConnection(context)).Returns(connectionInfo);
            fileLevelValidation.Setup(x => x.ValidateFile(results, connectionInfo)).Returns(true);
            transformer.Setup(x => x.Transform(results)).Returns(new[] { request });
            locationMapper.Setup(x => x.GenerateExcelLocations(results))
                .Returns(new System.Collections.Generic.Dictionary<string, ExcelLocation>());
            tableStore.Setup(x => x.GetRow<FileWatcherProcessingEntity>(It.IsAny<string>(), fileName, "timestamp"))
                .Returns(processingRow);

            handler.Handle(new StartBulkImportProcessingCommand { BatchId = "batch", Filename = fileName }, context).Wait();

            syntaxValidation.Verify(x => x.Enrich(results), Times.Once);
            transformer.Verify(x => x.Transform(results), Times.Once);
            tableStore.Verify(x => x.CreateRows(
                It.IsAny<string>(),
                It.Is<System.Collections.Generic.IEnumerable<BulkUploadProcessingEntity>>(rows => System.Linq.Enumerable.Count(rows) == 1)), Times.Once);
            fileAccess.Verify(x => x.CreateSyntaxReport(fileName, It.Is<string>(report => report.Contains("Success"))));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractRequestProcessedCommand_WhenMessageIsDuplicate_ShouldNotUpdateProcessingRow()
        {
            var connectionInfo = ConnectionInfo.CreateDefault();
            var context = new TestableMessageHandlerContext();
            var processedMessages = new Mock<IProcessedMessageRepository>();
            var sessionConnectionFactory = new Mock<ISessionConnectionFactory>();
            var tableStore = new Mock<IAzureTableStore>();
            var handler = new BulkUploadHandler
            {
                Data = new BulkUploadSagaData { BatchId = "batch" },
                Logger = Mock.Of<ILogger>(),
                ProcessedMessageRepository = processedMessages.Object,
                SessionConnectionFactory = sessionConnectionFactory.Object,
                AzureTableStore = tableStore.Object
            };
            var message = new ContractRequestProcessedCommand
            {
                ContractRequest = new contractRequestType
                {
                    correlationInfo = new correlationInfoType { batchId = "batch", correlationId = "correlation" }
                }
            };

            sessionConnectionFactory.Setup(x => x.GetConnection(context)).Returns(connectionInfo);
            processedMessages.Setup(x => x.Add(context.MessageId, connectionInfo)).Returns(false);

            handler.Handle(message, context).Wait();

            tableStore.Verify(
                x => x.GetRow<BulkUploadProcessingEntity>(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()),
                Times.Never);
            tableStore.Verify(x => x.ReplaceRow(It.IsAny<string>(), It.IsAny<BulkUploadProcessingEntity>()), Times.Never);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PublishContractRequestEvent_WhenRequestHasErrors_ShouldPersistProcessingRowsAndLocallyQueueCompletion()
        {
            var tableStore = new Mock<IAzureTableStore>();
            var locationMapper = new Mock<ILocationMapper>();
            var context = new TestableMessageHandlerContext();
            var request = new contractRequestType
            {
                correlationInfo = new correlationInfoType { batchId = "batch", correlationId = "correlation" },
                errorInfo = new System.Collections.Generic.List<errorInfoType>
                {
                    new errorInfoType { Value = "Invalid request" }
                }
            };
            locationMapper.Setup(x => x.GenerateExcelLocations(It.IsAny<dataLoadResults>()))
                .Returns(new System.Collections.Generic.Dictionary<string, ExcelLocation>());

            var handler = new BulkUploadHandler
            {
                Data = new BulkUploadSagaData { BatchId = "batch" },
                Logger = Mock.Of<ILogger>(),
                AzureTableStore = tableStore.Object,
                LocationMapper = locationMapper.Object
            };

            handler.PublishContractRequestEvent(new[] { request }, new dataLoadResults(), context).Wait();

            tableStore.Verify(x => x.CreateTableIfNotExists(EndpointConfig.BulkImportLocationMappingTable), Times.Once);
            tableStore.Verify(x => x.CreateTableIfNotExists(EndpointConfig.BulkImportProcessingTable), Times.Once);
            tableStore.Verify(x => x.CreateRows(
                EndpointConfig.BulkImportProcessingTable,
                It.Is<System.Collections.Generic.IEnumerable<BulkUploadProcessingEntity>>(rows =>
                    System.Linq.Enumerable.Count(rows) == 1)), Times.Once);
            Assert.AreEqual(1, context.SentMessages.Length);
            Assert.IsInstanceOfType(context.SentMessages[0].Message, typeof(ContractRequestProcessedCommand));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PublishContractRequestEvent_WhenRequestIsValid_ShouldSendContractCommand()
        {
            var tableStore = new Mock<IAzureTableStore>();
            var locationMapper = new Mock<ILocationMapper>();
            var context = new TestableMessageHandlerContext();
            var request = new contractRequestType
            {
                correlationInfo = new correlationInfoType { batchId = "batch", correlationId = "correlation" },
                contract = new contractType
                {
                    contracts = new System.Collections.Generic.List<contractType>
                    {
                        new contractType { CRMIntent = Intent.New }
                    }
                }
            };
            locationMapper.Setup(x => x.GenerateExcelLocations(It.IsAny<dataLoadResults>()))
                .Returns(new System.Collections.Generic.Dictionary<string, ExcelLocation>());

            var handler = new BulkUploadHandler
            {
                Data = new BulkUploadSagaData { BatchId = "batch" },
                Logger = Mock.Of<ILogger>(),
                AzureTableStore = tableStore.Object,
                LocationMapper = locationMapper.Object
            };

            handler.PublishContractRequestEvent(new[] { request }, new dataLoadResults(), context).Wait();

            Assert.AreEqual(1, context.SentMessages.Length);
            Assert.IsInstanceOfType(context.SentMessages[0].Message, typeof(NewContractRequestCommand));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PublishContractRequestEvent_WhenIntentIsUnsupported_RecordsErrorAndLocallyQueuesCompletion()
        {
            var tableStore = new Mock<IAzureTableStore>();
            var locationMapper = new Mock<ILocationMapper>();
            var context = new TestableMessageHandlerContext();
            var request = new contractRequestType
            {
                correlationInfo = new correlationInfoType { batchId = "batch", correlationId = "correlation" },
                contract = new contractType
                {
                    contracts = new System.Collections.Generic.List<contractType>
                    {
                        new contractType { CRMIntent = (Intent)999 }
                    }
                }
            };
            locationMapper.Setup(x => x.GenerateExcelLocations(It.IsAny<dataLoadResults>()))
                .Returns(new System.Collections.Generic.Dictionary<string, ExcelLocation>());

            var handler = new BulkUploadHandler
            {
                Data = new BulkUploadSagaData { BatchId = "batch" },
                Logger = Mock.Of<ILogger>(),
                AzureTableStore = tableStore.Object,
                LocationMapper = locationMapper.Object
            };

            handler.PublishContractRequestEvent(new[] { request }, new dataLoadResults(), context).Wait();

            Assert.AreEqual("Unrecognised Intent type", request.errorInfo[0].Value);
            Assert.AreEqual(1, context.SentMessages.Length);
            Assert.IsInstanceOfType(context.SentMessages[0].Message, typeof(ContractRequestProcessedCommand));
        }

        private class NewExcelUploadFileEvent : INewExcelUploadFileEvent
        {
            public string UploadedFilename { get; set; }
            public string BatchId { get; set; }
        }
    }
}
