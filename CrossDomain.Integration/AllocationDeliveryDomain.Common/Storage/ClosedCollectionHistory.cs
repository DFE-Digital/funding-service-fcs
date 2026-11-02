namespace SFA.FCT.AllocationDeliveryDomain.Common.Storage
{
    using System;
    using Microsoft.WindowsAzure.Storage.Table;

    public class ClosedCollectionHistory : TableEntity, IAzureEntity
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
    }
}
