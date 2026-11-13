namespace SFA.FCT.ContractRequestDomain.Common
{
    // using Microsoft.WindowsAzure.Storage.Table;

    using Azure;
    using Azure.Data.Tables;
    using System;

    /// <summary>
    /// Partition key is the batch id
    /// Row key is the correlation id
    /// </summary>
    public class BulkUploadProcessingEntity : ITableEntity
    {

        public string PartitionKey { get; set; } = default!;
        public string RowKey { get; set; } = default!;
        public DateTimeOffset? Timestamp { get; set; }
        public ETag ETag { get; set; }

        // your existing properties:
        public bool Complete { get; set; }
        public byte[] ContractRequestResult { get; set; } = Array.Empty<byte>();
        public string BatchId { get; set; } = string.Empty;
        public DateTime BatchStartedTimestamp { get; set; }
        public DateTime? SyntaxReportTimestamp { get; set; }
        public DateTime? CompletedTimestamp { get; set; }
        public string? Result { get; set; }

    }
}
