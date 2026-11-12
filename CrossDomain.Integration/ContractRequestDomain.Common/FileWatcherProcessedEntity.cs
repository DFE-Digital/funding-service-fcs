// FileWatcherProcessedEntity.cs
namespace SFA.FCT.ContractRequestDomain.Common
{
    using System;
    using Azure;
    using Azure.Data.Tables;

    public class FileWatcherProcessedEntity : ITableEntity
    {
        public string PartitionKey { get; set; } = default!;
        public string RowKey { get; set; } = default!;
        public DateTimeOffset? Timestamp { get; set; }
        public ETag ETag { get; set; }

        public string BatchId { get; set; } = string.Empty;
        public DateTime BatchStartedTimestamp { get; set; }
        public DateTime? SyntaxReportTimestamp { get; set; }
        public DateTime? CompletedTimestamp { get; set; }
        public string? Result { get; set; }
    }
}
