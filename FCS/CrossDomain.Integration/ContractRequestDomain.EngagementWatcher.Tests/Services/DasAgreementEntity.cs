namespace ContractRequestDomain.EngagementWatcher.Tests.Services
{
    using Microsoft.WindowsAzure.Storage.Table;

    public class DasAgreementEntity : TableEntity
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