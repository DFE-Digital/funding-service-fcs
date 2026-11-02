namespace ContractRequestDomain.EngagementWatcher.Services
{
    using ContractManagement.DataStore.Model;
    using System.Collections.Generic;
    using System.Linq;
    using Newtonsoft.Json;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;
    using Microsoft.WindowsAzure.Storage.Table;
    using Dtos;

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

            var apprenticeshipEventViews = 
                _tableStore.GetRows<DasAgreementEntity>(TableName + _environmentContext.StorageTableSuffix, PartitionKey)
                .OrderBy(a => int.Parse(a.RowKey))
                .SkipWhile(i => int.Parse(i.RowKey) < fromEventId)
                .Skip((pageNumber - 1) * pageSize)
                .Take(pageSize)
                .Select(r => JsonConvert.DeserializeObject<AgreementEventView>(r.Agreement))
                .ToList();

            return apprenticeshipEventViews.Select(e => new EngagementEvent(e.Id, e.Event, e.ProviderId)).ToList();
        }

        private class DasAgreementEntity : TableEntity
        {
            public DasAgreementEntity()
            {
            }

            public string Agreement { get; set; }
        }
    }
}