
namespace AllocationDeliveryDomain.Endpoint.Tests.Integration
{
    using System;
    using Azure;
    using Azure.Data.Tables;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;

    /// <summary>
    /// Azure.Data.Tables-compatible entity for the "group" aggregate row.
    /// PartitionKey: CollectionType
    /// RowKey:       CollectionReturnCode
    /// RowCount:     Aggregated count for that (PK,RK)
    /// </summary>
    internal class ReportedActualGroup : ITableEntity, IAzureEntity
    {
        // --- ITableEntity (required by Azure.Data.Tables) ---
        public string PartitionKey { get; set; } = default!;
        public string RowKey { get; set; } = default!;
        public DateTimeOffset? Timestamp { get; set; }
        public ETag ETag { get; set; }

        // --- Your domain-specific members ---
        public int RowCount { get; set; }

        // --- IAzureEntity (kept for compatibility with your abstraction) ---
        public string TableName => "ReportedActualGroupStub";

        /// <summary>
        /// Bridge property to keep existing IAzureEntity callers working.
        /// Maps directly to PartitionKey.
        /// </summary>
        public string EntityPartitionKey
        {
            get => PartitionKey;
            set => PartitionKey = value;
        }

        /// <summary>
        /// Bridge property to keep existing IAzureEntity callers working.
        /// Traditionally you returned RowCount padded here; however, your calling code
        /// uses (CollectionType, CollectionReturnCode) as the (PK,RK), and uses RowCount
        /// as a payload. So we surface the actual RowKey.
        /// </summary>
        public string EntityRowKey => RowKey;
    }
}
