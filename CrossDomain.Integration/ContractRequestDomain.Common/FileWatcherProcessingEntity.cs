
namespace SFA.FCT.ContractRequestDomain.Common
{
    using System;
    using Azure;                 // ETag
    using Azure.Data.Tables;     // ITableEntity

    /// <summary>
    /// This is the entity holding information on the FileWatcher processing table
    /// PartitionKey is filename
    /// RowKey is uploaded timestamp
    /// </summary>
    public class FileWatcherProcessingEntity : ITableEntity
    {
        // --- ITableEntity (required by Azure.Data.Tables) ---
        public string PartitionKey { get; set; } = default!;
        public string RowKey { get; set; } = default!;
        public DateTimeOffset? Timestamp { get; set; }
        public ETag ETag { get; set; }

        // --- Your existing properties ---
        public string BatchId { get; set; } = string.Empty;
        public DateTime BatchStartedTimestamp { get; set; }
        public DateTime? SyntaxReportTimestamp { get; set; }
    }
}
