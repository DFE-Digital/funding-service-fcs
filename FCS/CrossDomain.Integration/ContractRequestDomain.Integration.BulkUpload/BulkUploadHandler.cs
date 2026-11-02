namespace SFA.FCT.ContractRequestDomain.Integration.BulkUpload
{
    using System;
    using System.Collections.Generic;
    using System.Globalization;
    using System.IO;
    using System.Linq;
    using System.Text;
    using System.Threading.Tasks;
    using System.Transactions;
    using BusinessLogic.Interfaces;
    using Common;
    using Common.Commands;
    using Common.Utils;
    using CrossDomain.Integration.Common;
    using CrossDomain.Integration.Common.Serializers;
    using CrossDomain.Integration.Common.Storage;
    using CrossDomain.Integration.Entities.ContractRequest;
    using CrossDomain.Integration.Entities.ExcelUpload;
    using CrossDomain.Integration.Events;
    using CrossDomain.Integration.Messages.Commands;
    using Extensions;
    using Framework.Logging.Interfaces;
    using Framework.Logging.NullObjects;
    using Microsoft.WindowsAzure.Storage.Table;
    using NServiceBus;
    using Repositories;
    using SFA.FCS.Worker.Common.Slack;

    public class BulkUploadHandler : Saga<BulkUploadSagaData>, 
                                    IAmStartedByMessages<INewExcelUploadFileEvent>, 
                                    IHandleMessages<StartBulkImportProcessingCommand>,
                                    IHandleMessages<ContractRequestProcessedCommand>,
                                    IHandleTimeouts<BulkUploadSagaData>
    {
        private readonly string _processingTable;
        private readonly string _processedTable;

        public BulkUploadHandler()
        {
            Logger = new LoggerNullObject();
            _processingTable = ConfigurationHelper.GetSetting(ConfigurationHelper.ProcessingTableConfigEntryKey);
            _processedTable = ConfigurationHelper.GetSetting(ConfigurationHelper.ProcessedTableConfigEntryKey);
        }

        public ILogger Logger { get; set; }

        public ILocationMapper LocationMapper { get; set; }

        public IBulkUploadFileAccess BulkUploadFileAccess { get; set; }

        public IExcelFileParser FileParser { get; set; }

        public IAzureTableStore AzureTableStore { get; set; }

        public IGenerateResultsReport GenerateResultsReport { get; set; }

        public ICheckForErrorValidation CheckForErrorValidation { get; set; }

        public IFileValidationFscEnrichment FileValidationFscEnrichment { get; set; }

        public IContractBulkUploadFileLevelValidation ContractBulkUploadFileLevelValidation { get; set; }

        public IContractSyntaxValidation ContractSyntaxValidation { get; set; }

        public ITransformToContractRequest TransformToContractRequest { get; set; }

        public IProcessedMessageRepository ProcessedMessageRepository { get; set; }

        public ISessionConnectionFactory SessionConnectionFactory { get; set; }

        public async Task Handle(INewExcelUploadFileEvent message, IMessageHandlerContext context)
        {
            //if (string.IsNullOrEmpty(Data.FileName)) // todo: I have changed this from Batch Id
            //{
            //    return;
            //}

            Logger.LogInformation(ContractRequestDomainEventLoggingId.NewExcelUploadFileEventReceived, "NewExcelUploadFileEventReceived for batch {0}", message.BatchId);
            Data.BatchId = message.BatchId;

            if (!IsFilePresentInProcessingOrProcessedFolder(message.UploadedFilename))
            {
                Data.FileName = message.UploadedFilename;
                Data.Timestamp = BulkUploadFileAccess.GetFileTimestamp(message.UploadedFilename)
                    .ToString("O", DateTimeFormatInfo.InvariantInfo);

                using (TransactionScope scope = new TransactionScope())
                {

                    Transaction.Current.EnlistVolatile(
                        new MarkFileAsProcessedResourceManager(BulkUploadFileAccess, message.UploadedFilename),
                        EnlistmentOptions.None);

                    var entity = new FileWatcherProcessingEntity
                    {
                        PartitionKey = message.UploadedFilename,
                        RowKey = Data.Timestamp,
                        BatchId = message.BatchId,
                        BatchStartedTimestamp = DateTime.Now
                    };

                    Transaction.Current.EnlistVolatile(
                        new CreateFileWatcherProcessingTableRowResourceManager(AzureTableStore, entity),
                        EnlistmentOptions.None);
                    scope.Complete();
                }

                await context.Send<StartBulkImportProcessingCommand>(c =>
                {
                    c.BatchId = message.BatchId;
                    c.Filename = message.UploadedFilename;
                });
            }
            else
            {
                if (BulkUploadFileAccess.DoesFileExistInInputFolder(message.UploadedFilename))
                {
                    MoveFileFromInputToProcessedForDuplicateReason(message.UploadedFilename);
                    Logger.LogInformation(ContractRequestDomainEventLoggingId.NewExcelUploadFileEventMovedFileFromInputToProcessed, "File has been rejected; moved file: {0} to processed", message.UploadedFilename);
                }
                
                // we will be creating a Saga here, we don't want one so just populate the data with defaults
                SetSagaDataToDefault();
            }

            Logger.LogInformation(ContractRequestDomainEventLoggingId.NewExcelUploadFileEventReceived, "NewExcelUploadFileEventReceived for batch {0} processed", message.BatchId);
        }

        private void SetSagaDataToDefault()
        {
            Data.FileName = Guid.NewGuid().ToString();
            Data.Timestamp = DateTime.UtcNow.ToString("O", DateTimeFormatInfo.InvariantInfo);
        }

        private void MoveFileFromInputToProcessedForDuplicateReason(string uploadedFilename)
        {
            BulkUploadFileAccess.MoveRejectedFileFromInputToProcessed(uploadedFilename, FileRejectionReason.Duplicate);
        }

        private bool IsFilePresentInProcessingOrProcessedFolder(string uploadedFilename)
        {
            return BulkUploadFileAccess.DoesFileExistInProcessing(uploadedFilename) || 
                BulkUploadFileAccess.DoesFileExistInProcessedFolder(uploadedFilename);
        }

        public async Task Handle(StartBulkImportProcessingCommand message, IMessageHandlerContext context)
        {
            Logger.LogInformation(ContractRequestDomainEventLoggingId.StartingBulkImportProcessing, "Starting bulk import processing for batch {0}", Data.BatchId);

            byte[] filedata = BulkUploadFileAccess.GetProcessingFileContents(message.Filename);

            dataLoadResults dataLoadResults;
            using (MemoryStream inputStream = new MemoryStream(filedata))
            {
                dataLoadResults = FileParser.ReadFile(inputStream, Path.GetFileName(message.Filename));
            }

            dataLoadResults.batchId = message.BatchId;

            Data.BatchId = message.BatchId;
            Data.FileName = dataLoadResults.fileName;
            Logger.LogInformation(ContractRequestDomainEventLoggingId.StartingBulkImportProcessing, "File read and transformed to dataloadresults batch {0}", message.BatchId);

            if (!CheckForErrorValidation.Validate(dataLoadResults))
            {
                PublishFileValidationFailure(dataLoadResults);

                return;
            }

            Logger.LogInformation(ContractRequestDomainEventLoggingId.StartingBulkImportProcessing, "CheckForErrorValidation complete batch {0}", message.BatchId);

            FileValidationFscEnrichment.Enrich(dataLoadResults);

            var connection = SessionConnectionFactory.GetConnection(context);

            if (!ContractBulkUploadFileLevelValidation.ValidateFile(dataLoadResults, connection))
            {
                PublishFileValidationFailure(dataLoadResults);

                return;
            }

            Logger.LogInformation(ContractRequestDomainEventLoggingId.StartingBulkImportProcessing, "Just about to publish file validation batch {0}", message.BatchId);
            PublishFileValidationSuccess(dataLoadResults);

            Logger.LogInformation(ContractRequestDomainEventLoggingId.StartingBulkImportProcessing, "Published file validation batch {0}", message.BatchId);

            ContractSyntaxValidation.Enrich(dataLoadResults);

            Logger.LogInformation(ContractRequestDomainEventLoggingId.StartingBulkImportProcessing, "ContractSyntaxValidation.Enrich complete {0}", message.BatchId);

            var contractRequests = TransformToContractRequest.Transform(dataLoadResults);

            Logger.LogInformation(ContractRequestDomainEventLoggingId.StartingBulkImportProcessing, "TransformToContractRequest.Transform complete {0}", message.BatchId);

            await SetupSagaTimeout(contractRequests, context);

            Logger.LogInformation(ContractRequestDomainEventLoggingId.StartingBulkImportProcessing, "PublishContractRequestEvent - just about to call {0}", message.BatchId);
            await PublishContractRequestEvent(contractRequests, dataLoadResults, context);
            await PublishBulkUploadInProgressEvent(contractRequests.GetFundingInfo(), message.BatchId, context);

            Logger.LogInformation(ContractRequestDomainEventLoggingId.EndingBulkImportProcessing, "Ending bulk import processing for batch {0}", Data.BatchId);
        }

        public async Task Handle(ContractRequestProcessedCommand message, IMessageHandlerContext context)
        {
            Logger.LogInformation(ContractRequestDomainEventLoggingId.ContractRequestProcessedCommandReceived, "ContractRequestProcessedCommand received for BatchId {0} CorrelationId {1}", message.ContractRequest.correlationInfo.batchId, message.ContractRequest.correlationInfo.correlationId);

            string messageId = context.MessageId;

            var connection = SessionConnectionFactory.GetConnection(context);

            if (ProcessedMessageRepository.Add(messageId, connection))
            {
                // update the entry in the azure table store for this request - keyed by batch and correlation id
                var tableEntry = AzureTableStore.GetRow<BulkUploadProcessingEntity>(
                    EndpointConfig.BulkImportProcessingTable,
                    message.ContractRequest.correlationInfo.batchId,
                    message.ContractRequest.correlationInfo.correlationId);

                // we are now zipping the the ContractRequestResult, later we may need to store this in Blob Storage or similar as the max is 64k
                var result = new SagaContractRequestResult(message.ContractRequest);
                tableEntry.ContractRequestResult = ZipHelper.ToZippedBytesFromBytes(result.SerializedContractRequestResult);
                tableEntry.Complete = true;
                AzureTableStore.ReplaceRow(EndpointConfig.BulkImportProcessingTable, tableEntry);

                await CheckAndCompleteIfDone(Data.BatchId, context);
            }
            else
            {
                Logger.LogInformation(ContractRequestDomainEventLoggingId.ContractRequestProcessedCommandDuplicate,
                    $"ContractRequestProcessedCommand duplicate detected for BatchId {message.ContractRequest.correlationInfo.batchId} CorrelationId {message.ContractRequest.correlationInfo.correlationId}");
            }

            Logger.LogInformation(ContractRequestDomainEventLoggingId.ContractRequestProcessedCommandProcessed, "ContractRequestProcessedCommand processed for BatchId {0} CorrelationId {1}", message.ContractRequest.correlationInfo.batchId, message.ContractRequest.correlationInfo.correlationId);
        }

        public async Task Timeout(BulkUploadSagaData state, IMessageHandlerContext context)
        {
            try
            {
                await CompleteAndCloseSaga(Data.BatchId, context);
            }
            catch (Exception e)
            {
                var originatingEndpoint = context.MessageHeaders.GetTextAndValueIfPresent("NServiceBus.OriginatingEndpoint");

                var logError = $"{originatingEndpoint}, Bulk upload timed out - BatchId: {Data.BatchId}, ErrorMessage:{e.Message}, Trace:{e.StackTrace}";
                Logger.LogInformation(ContractRequestDomainEventLoggingId.SagaTimeout, logError);

                await context.Publish(new BulkUploadCompleteEvent(Data.BatchId));
                var slackError = $"{originatingEndpoint}, Bulk upload timed out";
                ErrorMessageNotifier.SendMessage(slackError, Logger, "CrossDomain.Integration");
            }
        }

        protected override void ConfigureHowToFindSaga(SagaPropertyMapper<BulkUploadSagaData> mapper)
        {
            mapper.ConfigureMapping<INewExcelUploadFileEvent>(e => e.BatchId).ToSaga(m => m.BatchId);

            mapper.ConfigureMapping<StartBulkImportProcessingCommand>(s => s.BatchId).ToSaga(m => m.BatchId);

            mapper.ConfigureMapping<ContractRequestProcessedCommand>(s => s.ContractRequest.correlationInfo.batchId)
                    .ToSaga(m => m.BatchId);
        }

        private async Task CheckAndCompleteIfDone(string batchId, IMessageHandlerContext context)
        {
            CloudTable processingTable = AzureTableStore.GetTable(EndpointConfig.BulkImportProcessingTable);
            TableQuery<BulkUploadProcessingEntity> notFinishedQuery = new TableQuery<BulkUploadProcessingEntity>()
                .Where(TableQuery.CombineFilters(
                    TableQuery.GenerateFilterCondition("PartitionKey", QueryComparisons.Equal, batchId),
                    TableOperators.And,
                    TableQuery.GenerateFilterConditionForBool("Complete", QueryComparisons.Equal, false)))
                .Take(1);

            var anyNotFinished = processingTable.ExecuteQuery(notFinishedQuery);
            if (anyNotFinished.Any())
            {
                return;
            }

            await CompleteAndCloseSaga(Data.BatchId, context);
        }

        private async Task CompleteAndCloseSaga(string batchId, IMessageHandlerContext context)
        {
            GenerateResultsFile();
            UpdateProcessingTableEntryWithFinalResults();

            Logger.LogInformation(ContractRequestDomainEventLoggingId.SagaComplete, "Saga for BatchId {0} is being marked as complete", batchId);
            MarkAsComplete();

            await context.Publish(new BulkUploadCompleteEvent(batchId));
        }

        private async Task SetupSagaTimeout(contractRequestType[] message, IMessageHandlerContext context)
        {
            int timeoutMinimum = ConfigurationHelper.GetSetting(ConfigurationHelper.BulkUpdateContractProcessingTimeoutMinimumMins, 10);
            int timeoutPer100 = ConfigurationHelper.GetSetting(ConfigurationHelper.BulkUpdateContractProcessingTimeoutPer100Mins, 0); 
            int timeout = (int)(timeoutMinimum + (((decimal)message.Length / 100) * timeoutPer100));

            await RequestTimeout<BulkUploadSagaData>(context, TimeSpan.FromMinutes(timeout));
        }

        private void PublishFileValidationFailure(dataLoadResults dataLoadResults)
        {
            Logger.LogInformation(ContractRequestDomainEventLoggingId.PublishSyntaxValidationFailure, "Publish syntax validation failure event for {0}", dataLoadResults.batchId);

            GenerateSyntaxFileReport(dataLoadResults);
            MarkAsComplete();
        }

        private void PublishFileValidationSuccess(dataLoadResults dataLoadResults)
        {
            Logger.LogInformation(ContractRequestDomainEventLoggingId.PublishSyntaxValidationSuccess, "Publish syntax validation success event for {0}", dataLoadResults.batchId);

            GenerateSyntaxFileReport(dataLoadResults);
        }

        private void GenerateSyntaxFileReport(dataLoadResults results)
        {
            StringBuilder sb = new StringBuilder();
            string timeStamp = DateTime.UtcNow.ToString("yyyyMMdd-hhmmss");
            string fileName = Data.FileName;

            if (results.IsSuccess())
            {
                sb.AppendLine($"{results.fileName} Success");
            }
            else
            {
                sb.AppendLine($"{results.fileName} Failed");
                fileName += $".Rejected{timeStamp}";

                foreach (errorInfo err in results.error)
                {
                    sb.AppendLine(err.Value);
                }

                BulkUploadFileAccess.MoveRejectedFileFromProcessing(Data.FileName, fileName);
            }

            BulkUploadFileAccess.CreateSyntaxReport(fileName, sb.ToString());
            UpdateProcessingTableEntryForSyntaxReport(results);
            Logger.LogInformation(ContractRequestDomainEventLoggingId.CreatedSyntaxReport, "Created syntax report for batch {0}", results.batchId);
        }

        private void UpdateProcessingTableEntryForSyntaxReport(dataLoadResults results)
        {
            var processingRow = AzureTableStore.GetRow<FileWatcherProcessingEntity>(_processingTable, results.fileName, Data.Timestamp);

            if (results.IsSuccess())
            {
                processingRow.SyntaxReportTimestamp = DateTime.Now;
                AzureTableStore.ReplaceRow(_processingTable, processingRow);
            }
            else
            {
                AzureTableStore.DeleteRow(_processingTable, processingRow.PartitionKey, processingRow.RowKey);

                FileWatcherProcessedEntity processedEntity = new FileWatcherProcessedEntity
                {
                    PartitionKey = processingRow.PartitionKey,
                    RowKey = processingRow.RowKey,
                    BatchId = processingRow.BatchId,
                    BatchStartedTimestamp = processingRow.BatchStartedTimestamp,
                    SyntaxReportTimestamp = DateTime.Now,
                    Result = "FAILED SYNTAX"
                };

                AzureTableStore.CreateTableIfNotExists(_processedTable);
                AzureTableStore.CreateRow(_processedTable, processedEntity);
            }
        }

        private void GenerateResultsFile()
        {
            IEnumerable<BulkUploadProcessingEntity> bulkUploadProcessingRows = AzureTableStore.GetRows<BulkUploadProcessingEntity>(EndpointConfig.BulkImportProcessingTable, Data.BatchId);
            var completedRows =
                bulkUploadProcessingRows
                    .Where(r => r.Complete && r.ContractRequestResult.Length > 0);

            IEnumerable<ContractRequestResult> results =
                completedRows
                    .Select(
                        r =>
                            new SagaContractRequestResult
                            {
                                SerializedContractRequestResult =
                                    ZipHelper.ToBytesFromZippedBytes(r.ContractRequestResult)
                            }.GetContractRequestResult());

            // the location mapping IList<ExcelLocation> is sliced across a number of rows on the azure table store to get around
            // the 64k property size limit.  This way makes it unlimited.
            var locationMappingRows = AzureTableStore.GetRows<BulkUploadLocationMappingEntity>(EndpointConfig.BulkImportLocationMappingTable, Data.BatchId).ToArray();
            var locationMappingBytes =
                locationMappingRows
                .OrderBy(r => int.Parse(r.RowKey))
                .SelectMany(r => r.LocationMapping)
                .ToArray();

            var locationMapping = locationMappingBytes.ConvertByteArrayToObject<ExcelLocation[]>();
            
            Logger.LogInformation(ContractRequestDomainEventLoggingId.GeneratingResultsFile, "Generating results file for BatchId {0}", Data.BatchId);

            byte[] originalFileContents = BulkUploadFileAccess.GetProcessingFileContents(Data.FileName);
            byte[] reportFileContents = GenerateResultsReport.GenerateReport(originalFileContents, results.ToArray(), locationMapping);
            BulkUploadFileAccess.CreateResultsReport(Data.FileName, reportFileContents);

            Logger.LogInformation(ContractRequestDomainEventLoggingId.GeneratedResultsFile, "Results file generated for BatchId {0}", Data.BatchId);
        }

        private void UpdateProcessingTableEntryWithFinalResults()
        {
            var processingRow = AzureTableStore.GetRow<FileWatcherProcessingEntity>(_processingTable, Data.FileName, Data.Timestamp);

            AzureTableStore.DeleteRow(_processingTable, processingRow.PartitionKey, processingRow.RowKey);

            FileWatcherProcessedEntity processedEntity = new FileWatcherProcessedEntity
            {
                PartitionKey = processingRow.PartitionKey,
                RowKey = processingRow.RowKey,
                BatchId = processingRow.BatchId,
                BatchStartedTimestamp = processingRow.BatchStartedTimestamp,
                SyntaxReportTimestamp = processingRow.SyntaxReportTimestamp,
                CompletedTimestamp = DateTime.Now,
                Result = "COMPLETE"
            };

            AzureTableStore.CreateTableIfNotExists(_processedTable);
            AzureTableStore.CreateRow(_processedTable, processedEntity);

            AzureTableStore.DeleteRows(EndpointConfig.BulkImportProcessingTable, Data.BatchId);
            AzureTableStore.DeleteRows(EndpointConfig.BulkImportLocationMappingTable, Data.BatchId);
        }

        public async Task PublishContractRequestEvent(contractRequestType[] contractRequests, dataLoadResults loadResults, IMessageHandlerContext context)
        {
            List<contractRequestType> failedRequests = new List<contractRequestType>();

            IDictionary<string, ExcelLocation> locationMapping = LocationMapper.GenerateExcelLocations(loadResults);

            var processingEntityList = new List<BulkUploadProcessingEntity>();

            foreach (contractRequestType cr in contractRequests)
            {
                BulkUploadProcessingEntity entity = new BulkUploadProcessingEntity
                {
                    PartitionKey = cr.correlationInfo.batchId,
                    RowKey = cr.correlationInfo.correlationId,
                    Complete = false
                };

                processingEntityList.Add(entity);
                LocationMapper.UpdateWithStructuralInformation(locationMapping, cr);

                if (cr.errorInfo != null && cr.errorInfo.Count > 0)
                {
                    Logger.LogInformation(ContractRequestDomainEventLoggingId.ContractHasErrors, "Contract request has errors {0} {1}", cr.correlationInfo.batchId, cr.correlationInfo.correlationId);
                    failedRequests.Add(cr);
                }
                else
                {
                    // need the CRMIntent from the contract not the master contract as this always seems to be new
                    ContractRequestCommandInfo commandInfo = ContractRequestCommandInfoFactory.Create(cr.contract.contracts[0].CRMIntent, cr);
                    if (commandInfo != null)
                    {
                        await context.Send(commandInfo.CommandObject);
                        Logger.LogInformation(commandInfo.LoggingId, commandInfo.InformationText);
                    }
                    else
                    {
                        cr.errorInfo = new List<errorInfoType>
                            {
                                new errorInfoType
                                {
                                    Value = "Unrecognised Intent type"
                                }
                            };

                        failedRequests.Add(cr);
                        break;
                    }
                }
            }

            AddLocationMappingToBulkImportLocationMappingTable(locationMapping);

            AzureTableStore.CreateTableIfNotExists(EndpointConfig.BulkImportProcessingTable);
            AzureTableStore.CreateRows(EndpointConfig.BulkImportProcessingTable, processingEntityList);

            foreach (var failedRequest in failedRequests)
            {
                await context.SendLocal(new ContractRequestProcessedCommand { ContractRequest = failedRequest });
            }
        }

        private void AddLocationMappingToBulkImportLocationMappingTable(IDictionary<string, ExcelLocation> locationMapping)
        {
            // now put the LocationMapping into its own table and remove it from the Saga data as it's only needed right at the end and not per ContractRequestProcessedEvent message
            // and then clear out the Saga data entry

            // we need the table
            AzureTableStore.CreateTableIfNotExists(EndpointConfig.BulkImportLocationMappingTable);

            const int maxLocationMappingSize = 32 * 1024;

            // and then we build up a list of entities each containing a slice of the the serialised IList<ExcelLocation>
            // as the property limit on the azure table store is 64K and with a lot of deliverables in a contract this goes
            // much bigger than that.
            var locationMappingBytes = locationMapping.Values.ToArray().ConvertObjectToByteArray();
            var entities = new List<BulkUploadLocationMappingEntity>();
            int offset = 0;
            while (offset < locationMappingBytes.Length)
            {
                entities.Add(new BulkUploadLocationMappingEntity 
                    {
                        PartitionKey = Data.BatchId,
                        RowKey = offset.ToString(),
                        LocationMapping = 
                            new ArraySegment<byte>(
                                locationMappingBytes, 
                                offset,
                                (locationMappingBytes.Length - offset > maxLocationMappingSize) ? maxLocationMappingSize : locationMappingBytes.Length - offset)
                            .ToArray()
                    });

                // upload in batches so we don't go over the limit and get a 413 error back from the webapi call to Azure.
                if (entities.Count == 10)
                {
                    AzureTableStore.CreateRows(EndpointConfig.BulkImportLocationMappingTable, entities);
                    entities.Clear();
                }

                offset += maxLocationMappingSize;
            }

            if (entities.Count > 0)
            {
                AzureTableStore.CreateRows(EndpointConfig.BulkImportLocationMappingTable, entities);
            }
        }

        private static async Task PublishBulkUploadInProgressEvent((string fundingTypeCode, string fundingPeriodName) fundingInfo, string batchId, IMessageHandlerContext context)
        {
            await context.Publish(new BulkUploadInProgressEvent(fundingInfo.fundingTypeCode, fundingInfo.fundingPeriodName, batchId));
        }
    }
}
