namespace SFA.FCT.AllocationDeliveryDomain.Common.Storage
{
    using Azure;
    //using Microsoft.WindowsAzure.Storage.Table;

    using Azure.Data.Tables;
    using System;

    public class ClosedCollectionHistory : ITableEntity, IAzureEntity
    {
        public const string StoragePartitionKey = "PK";

        public string CollectionType { get; set; }

        public DateTime LastClosedTime { get; set; }

        public string TableName
        {
            get { return "ClosedCollectionHistory"; }
        }

        public string EntityPartitionKey
        {
            get { return StoragePartitionKey; }
        }

        public string EntityRowKey
        {
            get { return CollectionType; }
        }

        public string PartitionKey { get; set; }
        public string RowKey { get; set; }
        public DateTimeOffset? Timestamp { get; set; }
        public ETag ETag { get; set; }
    }
}
