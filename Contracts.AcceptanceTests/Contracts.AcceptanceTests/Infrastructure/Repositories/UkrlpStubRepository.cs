namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    //using Microsoft.WindowsAzure.Storage.Table;
    using Azure;
    using Azure.Data.Tables;
    using CrossDomain.Integration.Common.Storage;
    using System;
    using System.Configuration;

    public static class UkrlpStubRepository
    {
        private const string UnSuffixedTableName = "UkrlpStub";
        private const string PartitionKey = "UkrlpStubPartitionKey";
        private static readonly string EnvironmentSuffixedTableName;

        static UkrlpStubRepository()
        {
            EnvironmentSuffixedTableName = $"{UnSuffixedTableName}{ConfigurationManager.AppSettings["StorageTableSuffix"]}";
            AzureTableStore azureTableStore = new AzureTableStore();
            azureTableStore.CreateTableIfNotExists(EnvironmentSuffixedTableName);
        }

        public static void RemoveByUkprn(int ukprn)
        {
            AzureTableStore azureTableStore = new AzureTableStore();

            UkrlpStubEntity row = azureTableStore.GetRow<UkrlpStubEntity>(EnvironmentSuffixedTableName, PartitionKey, ukprn.ToString());
            if (row != null)
            {
                azureTableStore.DeleteRow(EnvironmentSuffixedTableName, PartitionKey, ukprn.ToString());
            }
        }

        public static void Add(
            int ukprn,
            string companyNumber,
            string charityNumber,
            string addressLine1,
            string addressLine2,
            string addressLine3,
            string addressLine4,
            string town,
            string county,
            string postcode)
        {
            AzureTableStore azureTableStore = new AzureTableStore();

            azureTableStore.CreateRow(EnvironmentSuffixedTableName, new UkrlpStubEntity
            {
                PartitionKey = PartitionKey,
                RowKey = ukprn.ToString(),
                Ukprn = ukprn,
                CompanyNumber = companyNumber,
                CharityNumber = charityNumber,
                AddressLine1 = addressLine1,
                AddressLine2 = addressLine2,
                AddressLine3 = addressLine3,
                AddressLine4 = addressLine4,
                Town = town,
                County = county,
                Postcode = postcode
            });
        }

        private class UkrlpStubEntity : ITableEntity
        {

            public string PartitionKey { get; set; }

            public string RowKey { get; set; }

            public DateTimeOffset? Timestamp { get; set; }

            public ETag ETag { get; set; }

            public int Ukprn { get; set; }

            public string CompanyNumber { get; set; }

            public string CharityNumber { get; set; }

            public string AddressLine1 { get; set; }

            public string AddressLine2 { get; set; }

            public string AddressLine3 { get; set; }

            public string AddressLine4 { get; set; }

            public string Town { get; set; }

            public string County { get; set; }

            public string Postcode { get; set; }
        }
    }
}
