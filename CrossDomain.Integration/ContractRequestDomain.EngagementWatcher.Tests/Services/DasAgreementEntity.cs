
namespace ContractRequestDomain.EngagementWatcher.Tests.Services
{
    using Azure;
    using Azure.Data.Tables;
    using System;

    public class DasAgreementEntity : ITableEntity
    {
        private const string EntityPartitionKey = "EventPartitionKey";

        // Required by ITableEntity
        public string PartitionKey { get; set; } = default!;
        public string RowKey { get; set; } = default!;
        public DateTimeOffset? Timestamp { get; set; }
        public ETag ETag { get; set; }

        // Your properties
        public string Agreement { get; set; } = default!;

        public DasAgreementEntity() { }

        public DasAgreementEntity(long id, string agreement)
        {
            PartitionKey = EntityPartitionKey;
            RowKey = id.ToString();
            Agreement = agreement;
        }
    }
}
