namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Common.PagedStorage;
    using CrossDomain.Integration.Common.Storage;
    using DAS.Events.Api.Types;
    using Microsoft.WindowsAzure.Storage.Table;
    using Newtonsoft.Json;

    public class DasCommitmentStubRepository
    {
        private static AzureTableStore _tableStore;
        private static EnvironmentContext _environmentContext;
        private const string TableName = "DasCommitmentStub";
        private const string PartitonKey = "EventPartitionKey";

        public DasCommitmentStubRepository()
        {
            _environmentContext = new EnvironmentContext();
            _tableStore = new AzureTableStore();
            _tableStore.CreateTableIfNotExists(TableName + _environmentContext.StorageTableSuffix);
        }

        public void AddRange(IEnumerable<AgreementEventView> agreements)
        {
            List<DasAgreementEntity> entities = agreements
                .Select(agreementEventView =>
                    new DasAgreementEntity(agreementEventView.Id, JsonConvert.SerializeObject(agreementEventView)))
                    .ToList();

            _tableStore.CreateRows(TableName + _environmentContext.StorageTableSuffix, entities);
        }

        public void Clear()
        {
            _tableStore.DeleteRows(TableName + _environmentContext.StorageTableSuffix, PartitonKey);
        }

        private class DasAgreementEntity : TableEntity
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
        }
    }
}