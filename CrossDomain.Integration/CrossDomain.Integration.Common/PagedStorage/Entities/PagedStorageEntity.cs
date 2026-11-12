namespace SFA.FCT.CrossDomain.Integration.Common.PagedStorage.Entities
{
    //using Azure;
    //using Microsoft.WindowsAzure.Storage.Table;

    //public class PagedStorageEntity : TableEntity
    //{
    //    public byte[] ContentBytes { get; set; }

    //    public int PageNumberOnceCommitted { get; set; }
    //}

    
    using Azure;
    using Azure.Data.Tables;

public class PagedStorageEntity : ITableEntity
    {
        public string PartitionKey { get; set; }
        public string RowKey { get; set; }
        public DateTimeOffset? Timestamp { get; set; }
        public ETag ETag { get; set; }

        public byte[] ContentBytes { get; set; }
        public int PageNumberOnceCommitted { get; set; }
    }

}