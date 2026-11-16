
namespace CrossDomain.Integration.Common.Tests.Integration
{
    using System;
    using System.Configuration;
    using System.Linq;
    using Azure;
    using Azure.Data.Tables;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage.Entities;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage.Repositories;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.Framework.Logging;

    [TestClass]
    public class AzureDeliverableSettingConfigurationRepositoryTests
    {
        private string _tableName;

        // Updated types to the new SDK but kept field names the same:
        private TableServiceClient _tableClient; // was CloudTableClient
        private TableClient _table;               // was CloudTable

        private IPagedStorageRepository<DeliverableSettingConfiguration> _repository;
        private StorageObjectSerializer _storageObjectSerializer;

        [TestInitialize]
        public void TestInitialize()
        {
            _tableName = "TESTDELIVSETTING" + Guid.NewGuid().ToString("N").Substring(0, 4);

            var connectionString = ConfigurationManager
                .ConnectionStrings["StorageConnectionString"]
                .ConnectionString;

            // New SDK clients
            _tableClient = new TableServiceClient(connectionString);
            _table = _tableClient.GetTableClient(_tableName);
            _table.CreateIfNotExists();

            _storageObjectSerializer = new StorageObjectSerializer();

            _repository = new AzureDeliverableSettingConfigurationRepository(
                new EnvironmentContext(),
                new AzureTableStore(),                 // ensure this uses Azure.Data.Tables under the hood
                _storageObjectSerializer,
                new Logger(null))
            {
                TableName = _tableName
            };
        }

        [TestCleanup]
        public void TestCleanup()
        {
            // Delete the main test table
            _table.Delete();

            // Delete the correlation table using the new SDK
            var correlationTableName = AzureDeliverableSettingConfigurationRepository
                .FormatCorrelationTableName(_tableName);

            var correlationTable = _tableClient.GetTableClient(correlationTableName);
            correlationTable.Delete();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void Calling_Add_Should_Append_Entity_To_Table_Storage()
        {
            const string fundingStreamPeriodCode = "FSP-001";
            const int deliverableCode = 1;
            const string settingName = "SETTING-001";
            const string settingValue = "SETTING-VALUE";

            var setting = new DeliverableSettingConfiguration
            {
                FundingStreamPeriodCode = fundingStreamPeriodCode,
                DeliverableCode = deliverableCode,
                SettingValue = new SettingValueType
                {
                    Setting = new SettingType
                    {
                        SettingName = settingName
                    },
                    Value = settingValue
                }
            };

            _repository.Add(setting);

            AssertEntityIsPresentInPartition(
                AzureDeliverableSettingConfigurationRepository.LatestPagePartitionKey,
                fundingStreamPeriodCode,
                deliverableCode,
                settingName,
                settingValue);
        }

        private void AssertEntityIsPresentInPartition(
            string partitionKey, string fundingStreamPeriodCode, int deliverableCode, string settingName, string settingValue)
        {
            // New SDK: build a filter and query strongly-typed entities
            // This safely parameterizes the literal value
            string filter = TableClient.CreateQueryFilter($"PartitionKey eq {partitionKey}");

            // Query<T> returns a pageable collection
            var rows = _table.Query<PagedStorageEntity>(filter);

            var match = rows.SingleOrDefault(r =>
            {
                var setting = _storageObjectSerializer
                    .Deserialize<DeliverableSettingConfiguration>(r.ContentBytes);

                return setting.FundingStreamPeriodCode.Equals(fundingStreamPeriodCode)
                    && setting.DeliverableCode.Equals(deliverableCode)
                    && setting.SettingValue.Setting.SettingName.Equals(settingName)
                    && setting.SettingValue.Value.Equals(settingValue);
            });

            Assert.IsNotNull(match, "Entity was not present in storage");
        }
    }
}
