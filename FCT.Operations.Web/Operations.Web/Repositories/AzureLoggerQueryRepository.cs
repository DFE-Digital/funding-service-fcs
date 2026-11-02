namespace Operations.Web.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Configuration;
    using System.Threading.Tasks;
    using Dtos;
    using Microsoft.WindowsAzure.Storage;
    using Microsoft.WindowsAzure.Storage.Table;

    public class AzureLoggerQueryRepository : IAzureLoggerQueryRepository
    {
        public async Task<IReadOnlyCollection<StorageLogEntry>[]> GetLogEntriesBetweenDates(
            DateTime startDateTime,
            DateTime endDateTime)
        {
            var storageConnectionString =
                ConfigurationManager.ConnectionStrings["StorageConnectionString"].ConnectionString;

            var cloudTable = GetCloudTable(storageConnectionString);

            var fromPartitionKey = "0" + startDateTime.Ticks;

            var toPartitionKey = "0" + endDateTime.Ticks;

            string deploymentIds = ConfigurationManager.AppSettings["CloudDeploymentIds"];

            string[] deploymentIdArray = deploymentIds.Split(',').Select(s => s.Trim()).ToArray();

            List<Task<IReadOnlyCollection<StorageLogEntry>>> queryTasks = deploymentIdArray
                .Select(deploymentId => ExecuteQuery(cloudTable, fromPartitionKey, toPartitionKey, deploymentId))
                .ToList();

            return await Task.WhenAll(queryTasks);
        }

        private CloudTable GetCloudTable(string storageConnectionString)
        {
            var storageAccount = CloudStorageAccount.Parse(storageConnectionString);

            var cloudTableClient = storageAccount.CreateCloudTableClient();

            return cloudTableClient.GetTableReference("WADLogsTable");
        }

        private TableQuery<GenericTableEntity> GetTableQuery(string partitionKeyStart, string partitionKeyEnd,
            string deploymentId, bool isFirstTimeCalled)
        {
            TableQuery<GenericTableEntity> rangeQuery = new TableQuery<GenericTableEntity>()
                .Where(
                    TableQuery.CombineFilters(
                        TableQuery.CombineFilters(
                            TableQuery.GenerateFilterCondition(
                                "PartitionKey",
                                isFirstTimeCalled ? QueryComparisons.GreaterThanOrEqual : QueryComparisons.GreaterThan,
                                partitionKeyStart),
                            TableOperators.And,
                            TableQuery.GenerateFilterCondition("PartitionKey", QueryComparisons.LessThanOrEqual,
                                partitionKeyEnd)
                            ),
                        TableOperators.And,
                        TableQuery.GenerateFilterCondition("DeploymentId", QueryComparisons.Equal, deploymentId)
                        ));

            return rangeQuery;
        }

        private async Task<IReadOnlyCollection<StorageLogEntry>> ExecuteQuery(CloudTable table, string partitionKeyStart,
            string partitionKeyEnd, string deploymentId)
        {
            TableContinuationToken continuationToken = null;
            List<StorageLogEntry> logEntries = new List<StorageLogEntry>();

            do
            {
                TableQuery<GenericTableEntity> tableQuery = GetTableQuery(partitionKeyStart, partitionKeyEnd,
                    deploymentId, continuationToken == null);

                TableQuerySegment<GenericTableEntity> segmentResults =
                    await table.ExecuteQuerySegmentedAsync(tableQuery, continuationToken);
                continuationToken = segmentResults.ContinuationToken;

                logEntries.AddRange(segmentResults.Select(TransformEntityToLogEntry).ToList());

            } while (continuationToken != null);

            return logEntries;
        }

        public StorageLogEntry TransformEntityToLogEntry(GenericTableEntity genericTableEntity)
        {
            string message;

            var rawMessage = genericTableEntity.Properties["Message"].StringValue;
            if (rawMessage.StartsWith("EventName=\"MessageEvent\""))
            {
                message = rawMessage.Substring(33);
            }
            else if (rawMessage.StartsWith("EventName=\"FormattedMessageEvent\""))
            {
                message = rawMessage.Substring(51);
            }
            else if (rawMessage.StartsWith("EventName=\"DirectWrite\""))
            {
                message = rawMessage.Substring(32);
            }
            else
            {
                message = rawMessage;
            }

            var traceSourceStart = message.LastIndexOf("TraceSource=\"");
            if (traceSourceStart > -1)
            {
                message = message.Substring(0, traceSourceStart - 1);
            }

            var eventId = genericTableEntity.Properties["EventId"].Int32Value.Value;
            var roleInstanceString = genericTableEntity.Properties["RoleInstance"].StringValue;
            var dateOccurred = message.Substring(1, 23);

            return new StorageLogEntry(eventId,
                dateOccurred,
                message,
                int.Parse(roleInstanceString.Last().ToString()));
        }


        public class GenericTableEntity : ITableEntity
        {
            public string ETag { get; set; }
            public string PartitionKey { get; set; }
            public string RowKey { get; set; }
            public DateTimeOffset Timestamp { get; set; }
            public IDictionary<string, EntityProperty> Properties { get; set; }

            public void ReadEntity(IDictionary<string, EntityProperty> properties, OperationContext operationContext)
            {
                Properties = properties;
            }

            public IDictionary<string, EntityProperty> WriteEntity(OperationContext operationContext)
            {
                return Properties;
            }
        }
    }

    public interface IAzureLoggerQueryRepository
    {
        Task<IReadOnlyCollection<StorageLogEntry>[]> GetLogEntriesBetweenDates(
            DateTime startDateTime,
            DateTime endDateTime);
    }
}