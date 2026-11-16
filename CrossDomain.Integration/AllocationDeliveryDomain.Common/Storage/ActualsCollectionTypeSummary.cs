namespace SFA.FCT.AllocationDeliveryDomain.Common.Storage
{
    // using Microsoft.WindowsAzure.Storage.Table;
    using Azure;
    using Azure.Data.Tables;
    public class ActualsCollectionTypeSummary : ITableEntity, IAzureEntity
    {
        private readonly string _collectionType;
        private readonly string _collectionReturnCode;

        public ActualsCollectionTypeSummary(string collectionType, string collectionReturnCode, int totalRows)
        {
            _collectionType = collectionType;
            _collectionReturnCode = collectionReturnCode;
            TotalRows = totalRows;

            PartitionKey = CollectionType;
            RowKey = CollectionReturnCode;
        }

        public ActualsCollectionTypeSummary()
        {
        }

        public string TableName
        {
            get { return "ActualsCollectionTypeSummary"; }
        }

        public string EntityPartitionKey 
        {
            get { return CollectionType; } 
        }

        public string EntityRowKey
        {
            get { return CollectionReturnCode; } 
        }

        public string CollectionType => _collectionType ?? PartitionKey;

        public string CollectionReturnCode => _collectionReturnCode ?? RowKey;

        public int TotalRows { get; set; }

        public int CurrentNumberOfRows { get; set; }

        public string PartitionKey { get; set; }
        public string RowKey { get; set; }
        public DateTimeOffset? Timestamp { get; set; }
        public ETag ETag { get; set; }
    }
}
