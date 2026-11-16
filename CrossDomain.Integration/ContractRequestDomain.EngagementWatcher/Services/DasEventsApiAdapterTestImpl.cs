
namespace SFA.FCT.ContractRequestDomain.EngagementWatcher.Services
{
    using Azure;                  // <-- ETag lives here
    using Azure.Data.Tables;      // <-- ITableEntity lives here
    using ContractManagement.DataStore.Model;
    using Dtos;
    using Newtonsoft.Json;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using System;
    using System.Collections.Generic;
    using System.Linq;

    // IMPORTANT:
    // - Ensure you REMOVE the legacy line:
    //   using Microsoft.WindowsAzure.Storage.Table;
    // - Your project must reference the Azure.Data.Tables package.

    public class DasEventsApiAdapterTestImpl : IDasEventsApiAdapter
    {
        private readonly IAzureTableStore _tableStore;
        private readonly IEnvironmentContext _environmentContext;

        private const string TableName = "DasCommitmentStub";
        private const string PartitionKey = "EventPartitionKey";

        public DasEventsApiAdapterTestImpl(IAzureTableStore tableStore, IEnvironmentContext environmentContext)
        {
            _tableStore = tableStore;
            _environmentContext = environmentContext;
            _tableStore.CreateTableIfNotExists(TableName + _environmentContext.StorageTableSuffix);
        }

        public string BaseUrl => "Test Stub";

        public IReadOnlyCollection<EngagementEvent> GetEngagementEventsAfterId(long fromEventId, int pageSize)
        {
            const int pageNumber = 1;
            var table = TableName + _environmentContext.StorageTableSuffix;

            var records = _tableStore
                .GetRows<DasAgreementEntity>(table, PartitionKey) // T must implement Azure.Data.Tables.ITableEntity
                .OrderBy(a =>
                {
                    // Defensive parse: RowKey must be numeric for your ordering/filtering logic
                    return int.TryParse(a.RowKey, out var n) ? n : int.MaxValue;
                })
                .SkipWhile(i =>
                {
                    return int.TryParse(i.RowKey, out var n) && n < fromEventId;
                })
                .Skip((pageNumber - 1) * pageSize)
                .Take(pageSize)
                .ToList();

            var views = records
                .Select(r => JsonConvert.DeserializeObject<AgreementEventView>(r.Agreement))
                .Where(v => v != null)
                .ToList();

            return views
                .Select(e => new EngagementEvent(e.Id, e.Event, e.ProviderId))
                .ToList();
        }

        /// <summary>
        /// Implements Azure.Data.Tables.ITableEntity explicitly.
        /// Do NOT derive from TableEntity (it's sealed in the new SDK).
        /// </summary>
        private class DasAgreementEntity : ITableEntity
        {
            // Required by ITableEntity
            public string PartitionKey { get; set; } = default!;
            public string RowKey { get; set; } = default!;
            public DateTimeOffset? Timestamp { get; set; }
            public ETag ETag { get; set; }

            // Your payload column
            public string Agreement { get; set; } = string.Empty;
        }
    }
}
