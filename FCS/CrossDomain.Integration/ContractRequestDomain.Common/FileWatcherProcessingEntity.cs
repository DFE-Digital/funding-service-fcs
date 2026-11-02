namespace SFA.FCT.ContractRequestDomain.Common
{
    using System;
    using Microsoft.WindowsAzure.Storage.Table;

    /// <summary>
    /// This is the entity holding information on the FileWatcher processing table
    /// PartitionKey is filename
    /// RowKey is uploaded timestamp
    /// </summary>
    public class FileWatcherProcessingEntity : TableEntity
    {
        public string BatchId { get; set; }

        public DateTime BatchStartedTimestamp { get; set; }

        public DateTime? SyntaxReportTimestamp { get; set; }
    }
}
