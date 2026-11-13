// BulkUploadLocationMappingEntity.cs
namespace SFA.FCT.ContractRequestDomain.Common
{
    using System;
    using Azure;
    using Azure.Data.Tables;

    public class BulkUploadLocationMappingEntity : ITableEntity
    {
        public string PartitionKey { get; set; } = default!;
        public string RowKey { get; set; } = default!;
        public DateTimeOffset? Timestamp { get; set; }
        public ETag ETag { get; set; }

        // You already slice the byte[] into safe chunks in the handler
        public byte[] LocationMapping { get; set; } = Array.Empty<byte>();
    }
}
