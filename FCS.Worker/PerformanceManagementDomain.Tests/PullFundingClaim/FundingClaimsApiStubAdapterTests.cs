namespace PerformanceManagementDomain.Tests.PullFundingClaim
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Azure;
    using Azure.Data.Tables;
    using Newtonsoft.Json;
    using PerformanceManagementDomain.PullFundingClaim.DTOs;
    using PerformanceManagementDomain.PullFundingClaim.Services;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;

    [TestClass]
    public class FundingClaimsApiStubAdapterTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingClaimsApiStubAdapter_ShouldGetFundingClaimCompletedCollections()
        {
            // arrange
            string storageTableSuffix = ConfigurationManager.AppSettings["StorageTableSuffix"];
            var azureTableName = $"FundingClaimApiStub{storageTableSuffix}";
            DeleteRowsFromTable(azureTableName);
            int rowKey = 0;
            CreateRow(azureTableName, new FundingClaimApiDto
            {
                Period = "1718",
                ClaimTypeName = "Final"
            }, ++rowKey);
            CreateRow(azureTableName, new FundingClaimApiDto
            {
                Period = "1718",
                ClaimTypeName = "Final"
            }, ++rowKey);
            CreateRow(azureTableName, new FundingClaimApiDto
            {
                Period = "1819",
                ClaimTypeName = "Final"
            }, ++rowKey);

            FundingClaimsApiStubAdapter adapter = new FundingClaimsApiStubAdapter(new AzureTableStore(), new EnvironmentContext() );
            // act
            IReadOnlyCollection<string> completedCollections = adapter.GetFundingClaimCompletedCollections(new DateTime()).Result;

            // assert
            Assert.AreEqual(2, completedCollections.Count);
            Assert.IsTrue(completedCollections.Contains("1718-Final"), "Should contains 1718-Final");
            Assert.IsTrue(completedCollections.Contains("1819-Final"), "Should contains 1819-Final");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingClaimsApiStubAdapter_ShouldGetCountOfFundingClaimsForCollectionKey()
        {
            // arrange
            string storageTableSuffix = ConfigurationManager.AppSettings["StorageTableSuffix"];
            var azureTableName = $"FundingClaimApiStub{storageTableSuffix}";
            DeleteRowsFromTable(azureTableName);
            int rowKey = 0;
            CreateRow(azureTableName, new FundingClaimApiDto
            {
                Period = "1718",
                ClaimTypeName = "Final"
            }, ++rowKey);
            CreateRow(azureTableName, new FundingClaimApiDto
            {
                Period = "1718",
                ClaimTypeName = "Final"
            }, ++rowKey);
            CreateRow(azureTableName, new FundingClaimApiDto
            {
                Period = "1819",
                ClaimTypeName = "Final"
            }, ++rowKey);

            FundingClaimsApiStubAdapter adapter = new FundingClaimsApiStubAdapter(new AzureTableStore(), new EnvironmentContext());
            // act
            int count = adapter.GetCountOfFundingClaimsForCollectionKey("1718-Final").Result;

            // assert
            Assert.AreEqual(2, count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingClaimsApiStubAdapter_ShouldGetFundingClaimsForCollectionKey()
        {
            // arrange
            string storageTableSuffix = ConfigurationManager.AppSettings["StorageTableSuffix"];
            var azureTableName = $"FundingClaimApiStub{storageTableSuffix}";
            DeleteRowsFromTable(azureTableName);
            int rowKey = 0;
            CreateRow(azureTableName, new FundingClaimApiDto
            {
                Period = "1718",
                ClaimTypeName = "Final",
                FundingClaimId = "FC1",
                Ukprn = "111",
                OrganisationIdentifier = "1111",
                ContractAllocations = new List<ContractAllocationApiDto>
                {
                    new ContractAllocationApiDto
                    {
                        ContractAllocationNumber = "AN1",
                        FundingStreamPeriodCode = "FSP1",
                        MaximumContractValue = 111M,
                        DeliverableCodes = new List<DeliverableCodeApiDto>
                        {
                            new DeliverableCodeApiDto
                            {
                                ActualValue = 1M,
                                ActualVolume = 11,
                                AdjustmentValue = 111M,
                                DeliverableCodeValue = 1111,
                                ForecastValue = 11111M,
                                TotalDelivery = 111111M
                            }
                        }
                    }
                }
            }, ++rowKey);
            CreateRow(azureTableName, new FundingClaimApiDto
            {
                Period = "1718",
                ClaimTypeName = "Final",
                FundingClaimId = "FC2",
                Ukprn = "222",
                OrganisationIdentifier = "2222",
            }, ++rowKey);
            CreateRow(azureTableName, new FundingClaimApiDto
            {
                Period = "1819",
                ClaimTypeName = "Final",
                FundingClaimId = "FC3",
                Ukprn = "333",
                OrganisationIdentifier = "3333",
            }, ++rowKey);

            FundingClaimsApiStubAdapter adapter = new FundingClaimsApiStubAdapter(new AzureTableStore(), new EnvironmentContext());
            // act
            var fundingClaims = adapter.GetFundingClaimsForCollectionKey("1718-Final", int.MaxValue).Result;

            // assert
            Assert.AreEqual(3, fundingClaims.Count, "The count is not correct");
            var fundingClaimFC1 = fundingClaims.Single(f => f.FundingClaimId == "FC1");

            Assert.AreEqual("111", fundingClaimFC1.Ukprn, "The Ukprn is not correct on FC1");
            Assert.AreEqual("Final", fundingClaimFC1.ClaimTypeName, "The ClaimTypeName is not correct on FC1");
            Assert.AreEqual("1111", fundingClaimFC1.OrganisationIdentifier, "The OrganisationIdentifier is not correct on FC1");
            Assert.AreEqual(1, fundingClaimFC1.ContractAllocations.Count, "The number od allocations is not correct on FC1");
            var allocationFc1 = fundingClaimFC1.ContractAllocations.First();
            Assert.AreEqual("AN1", allocationFc1.ContractAllocationNumber, "The ContractAllocationNumber is not correct on FC1");
            Assert.AreEqual("FSP1", allocationFc1.FundingStreamPeriodCode, "The FundingStreamPeriodCode is not correct on FC1");
            Assert.AreEqual(1, allocationFc1.DeliverableCodes.Count, "The number of DeliverableCodes is not correct on FC1");
            var deliverable = allocationFc1.DeliverableCodes.First();
            Assert.AreEqual(1M, deliverable.ActualValue, "The ActualValue is not correct on FC1");
            Assert.AreEqual(11M, deliverable.ActualVolume, "The ActualVolume is not correct on FC1");
            Assert.AreEqual(111M, deliverable.AdjustmentValue, "The AdjustmentValue is not correct on FC1");
            Assert.AreEqual(1111, deliverable.DeliverableCodeValue, "The DeliverableCodeValue is not correct on FC1");
            Assert.AreEqual(11111M, deliverable.ForecastValue, "The ForecastValue is not correct on FC1");
            Assert.AreEqual(111111M, deliverable.TotalDelivery, "The TotalDelivery is not correct on FC1");
        }
        private static void CreateRow(string tableName, FundingClaimApiDto dto, int rowKey)
        {
            var table = GetTable(tableName);

            table.CreateIfNotExists();

            table.UpsertEntity(
                new FundingClaimApiEntity
                {
                    PartitionKey = $"{dto.Period}-{dto.ClaimTypeName}",
                    RowKey = rowKey.ToString(),
                    Json = JsonConvert.SerializeObject(dto)
                },
                TableUpdateMode.Replace);
        }

        private static void DeleteRowsFromTable(string tableName)
        {
            var table = GetTable(tableName);

            table.CreateIfNotExists();

            foreach (var entity in table.Query<FundingClaimApiEntity>())
            {
                table.DeleteEntity(
                    entity.PartitionKey,
                    entity.RowKey);
            }
        }

        private class FundingClaimApiEntity : ITableEntity
        {
            public string PartitionKey { get; set; }

            public string RowKey { get; set; }

            public DateTimeOffset? Timestamp { get; set; }

            public ETag ETag { get; set; }

            public string Json { get; set; }
        }

        private static TableClient GetTable(string tableName)
        {
            string connectionString =
                ConfigurationManager
                    .ConnectionStrings["StorageConnectionString"]
                    .ConnectionString;

            return new TableClient(
                connectionString,
                tableName);
        }


    }
}
