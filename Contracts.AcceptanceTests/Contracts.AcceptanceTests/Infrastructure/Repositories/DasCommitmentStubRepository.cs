namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    //using Microsoft.WindowsAzure.Storage.Table;
    using Azure;
    using Azure.Data.Tables;
    using CrossDomain.Integration.Common.Storage;
    using DAS.Events.Api.Types;
    using Newtonsoft.Json;
    using System;
    using System.Collections.Generic;
    using System.Linq;

    public class DasCommitmentStubRepository
    {
        private static AzureTableStore _tableStore;
        private const string TableName = "DasCommitmentStub";
        private const string PartitonKey = "EventPartitionKey";

        private static string StorageTableSuffix => TestConfiguration.Configuration["StorageTableSuffix"];

        public DasCommitmentStubRepository()
        {
            _tableStore = new AzureTableStore(StorageConnectionStringProvider.Get());
            _tableStore.CreateTableIfNotExists(TableName + StorageTableSuffix);
        }

        public void AddRange(IEnumerable<AgreementEventView> agreements)
        {
            List<DasAgreementEntity> entities = agreements
                .Select(agreementEventView =>
                    new DasAgreementEntity(agreementEventView.Id, JsonConvert.SerializeObject(agreementEventView)))
                    .ToList();

            _tableStore.CreateRows(TableName + StorageTableSuffix, entities);
        }

        public void Clear()
        {
            _tableStore.DeleteRows(TableName + StorageTableSuffix, PartitonKey);
        }

        private class DasAgreementEntity : ITableEntity
        {
            private const string EntityPartitionKey = "EventPartitionKey";

            public DasAgreementEntity()
            {
            }

            public DasAgreementEntity(long id, string agreement)
            {
                PartitionKey = EntityPartitionKey;
                RowKey = id.ToString();
                Agreement = agreement;
            }

            public string Agreement { get; set; }

            public string PartitionKey { get; set; } = string.Empty;

            public string RowKey { get; set; } = string.Empty;

            public DateTimeOffset? Timestamp { get; set; }

            public ETag ETag { get; set; }

        }
    }
}