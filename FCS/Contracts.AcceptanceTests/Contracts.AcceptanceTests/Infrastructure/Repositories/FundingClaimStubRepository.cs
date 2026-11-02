namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System.Configuration;
    using CrossDomain.Integration.Common.Storage;
    using Microsoft.WindowsAzure.Storage.Table;

    public static class FundingClaimStubRepository
    {
        private static readonly IAzureTableStore _azureTableStore = new AzureTableStore();
        private static readonly string _tableName = $"FundingClaimStub{ConfigurationManager.AppSettings["StorageTableSuffix"]}";
        private static int _nextRowKey = 1;

        static FundingClaimStubRepository()
        {
            _azureTableStore.CreateTableIfNotExists(_tableName);
        }

        public static void Add(string period, string claimType, string xml)
        {
            _azureTableStore.CreateRow(_tableName, new FundingClaimEntity(xml, period, claimType, _nextRowKey++));
        }

        public static void DeleteAllRows()
        {
            _azureTableStore.DeleteAllRows<FundingClaimEntity>(_tableName);
        }

        private class FundingClaimEntity : TableEntity
        {
            public FundingClaimEntity()
            {
            }

            public FundingClaimEntity(string fundingClaimXml, string period, string claimType, int rowKey)
            {
                PartitionKey = CreatePartitionKey(period, claimType);
                RowKey = rowKey.ToString("D8");
                FundingClaimXml = fundingClaimXml;
            }

            public string FundingClaimXml { get; set; }

            private static string CreatePartitionKey(string period, string claimType)
            {
                return $"{period}-{claimType}";
            }
        }
    }
}
