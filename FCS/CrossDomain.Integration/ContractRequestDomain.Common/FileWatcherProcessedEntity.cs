namespace SFA.FCT.ContractRequestDomain.Common
{
    using System;
    using Microsoft.WindowsAzure.Storage.Table;

    public class FileWatcherProcessedEntity : TableEntity
    {
        public string BatchId { get; set; }

        public DateTime BatchStartedTimestamp { get; set; }

        public DateTime? SyntaxReportTimestamp { get; set; }

        public DateTime? CompletedTimestamp { get; set; }

        public string Result { get; set; }
    }
}
