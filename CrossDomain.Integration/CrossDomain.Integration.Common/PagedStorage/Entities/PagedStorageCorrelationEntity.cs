namespace SFA.FCT.CrossDomain.Integration.Common.PagedStorage.Entities
{
    //using Microsoft.WindowsAzure.Storage.Table;

    using Azure;
    using Azure.Data.Tables;


    public class PagedStorageCorrelationEntity : ITableEntity
    {
        public string PartitionKey { get; set; }
        public string RowKey { get; set; }
        public DateTimeOffset? Timestamp { get; set; }
        public ETag ETag { get; set; }

        // Add any custom properties you need
        public string CorrelationId { get; set; }

    }
}