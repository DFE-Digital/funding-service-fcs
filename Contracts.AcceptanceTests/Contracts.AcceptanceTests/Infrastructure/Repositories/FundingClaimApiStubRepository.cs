namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using Azure;
    using Azure.Data.Tables;
    using CrossDomain.Integration.Common.Storage;
    using global::PerformanceManagementDomain.PullFundingClaim.DTOs;
   // using Microsoft.WindowsAzure.Storage.Table;
    using Newtonsoft.Json;
    using System;
    using System.Configuration;

    public static class FundingClaimApiStubRepository
    {
        private static readonly IAzureTableStore AzureTableStore = new AzureTableStore();
        private static readonly string TableName = $"FundingClaimApiStub{ConfigurationManager.AppSettings["StorageTableSuffix"]}";
        private static int _nextRowKey = 1;

        static FundingClaimApiStubRepository()
        {
            AzureTableStore.CreateTableIfNotExists(TableName);
        }

        public static void Add(FundingClaimApiDto fundingClaim)
        {
            AzureTableStore.CreateRow(TableName, new FundingClaimApiEntity
            {
                PartitionKey = $"{fundingClaim.Period}-{ToTitleCaseWithoutSpace(fundingClaim.ClaimTypeName)}",
                RowKey = (_nextRowKey++).ToString("D8"),
                Json = JsonConvert.SerializeObject(fundingClaim)
            });
        }

        public static void DeleteAllRows()
        {
            AzureTableStore.DeleteAllRows<FundingClaimApiEntity>(TableName);
        }

        private class FundingClaimApiEntity : ITableEntity
        {

            public string PartitionKey { get; set; }

            public string RowKey { get; set; }

            public DateTimeOffset? Timestamp { get; set; }

            public ETag ETag
            {
                get; set;
            }

            public string Json { get; set; }
        }

        public static string ToTitleCaseWithoutSpace(this string str)
        {
            var tokens = str.Split();
            for (var i = 0; i < tokens.Length; i++)
            {
                var token = tokens[i];
                tokens[i] = token.Substring(0, 1).ToUpper() + token.Substring(1).ToLower();
            }

            return string.Join(string.Empty, tokens);
        }
    }
}
