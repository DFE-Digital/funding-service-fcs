namespace ContractManagementService.DTOs
{
    using System;
    using Azure;
    using Azure.Data.Tables;


    public class PagedStorageEntity : ITableEntity
    {
        public byte[] ContentBytes { get; set; }

        public int PageNumberOnceCommitted { get; set; }
        public string PartitionKey { get; set; }
        public string RowKey { get; set; }
        public DateTimeOffset? Timestamp { get; set; }
        public ETag ETag { get; set; }
    }
}
