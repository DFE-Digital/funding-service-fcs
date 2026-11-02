namespace ContractManagementService.Tests.Repositories
{
    using ContractManagementService.Repositories;
    using DTOs;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using System.Collections.Generic;
    using System.Linq;
    using FluentAssertions;

    [TestClass]
    public class AzureTableStorageRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void AzureTableStorageRepository_ShouldCreateRows()
        {
            // arrange
            const string partitionKey = "-100";
            AzureTableStorageRepository repository = new AzureTableStorageRepository(new AppConfiguration());
            repository.DeleteAllRowsInPartition<PagedStorageEntity>(GetTableName(), partitionKey)
                .Wait();

            var rows = new List<PagedStorageEntity>
            {
                new PagedStorageEntity
                {
                    PartitionKey = partitionKey,
                    RowKey = "SomeRowKey"
                }
            };

            // act
            repository.CreateRows(GetTableName(), rows).Wait();

            // assert
            rows = repository.GetRows<PagedStorageEntity>(GetTableName(), partitionKey).Result.ToList();

            rows.Count.Should().Be(1);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AzureTableStorageRepository_ShouldGetRows()
        {
            AzureTableStorageRepository repository = new AzureTableStorageRepository(new AppConfiguration());
          
            // act
            var rows = repository.GetRows<PagedStorageEntity>(GetTableName(), "1").Result;

            // assert
            rows.Count().Should().Be(10);
        }

        private string GetTableName()
        {
            return $"DeliverableSettingConfiguration{new AppConfiguration()["StorageTableSuffix"]}";
        }
    }
}
