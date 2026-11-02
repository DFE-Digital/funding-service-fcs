namespace CrossDomain.Integration.Common.Tests.Integration
{
    using System;
    using System.Configuration;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.WindowsAzure.Storage;
    using Microsoft.WindowsAzure.Storage.Table;
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
        private CloudTableClient _tableClient;
        private CloudTable _table;
        private IPagedStorageRepository<DeliverableSettingConfiguration> _repository;
        private StorageObjectSerializer _storageObjectSerializer;

        [TestInitialize]
        public void TestInitialize()
        {
            _tableName = "TESTDELIVSETTING" + Guid.NewGuid().ToString("N").Substring(0, 4);
            var storageAccount = CloudStorageAccount.Parse(ConfigurationManager.ConnectionStrings["StorageConnectionString"].ConnectionString);
            _tableClient = storageAccount.CreateCloudTableClient();
            _table = _tableClient.GetTableReference(_tableName);
            _table.CreateIfNotExists();

            _storageObjectSerializer = new StorageObjectSerializer();
            _repository = new AzureDeliverableSettingConfigurationRepository(
                new EnvironmentContext(), new AzureTableStore(), _storageObjectSerializer, new Logger(null))
            {
                TableName = _tableName
            };
        }

        [TestCleanup]
        public void TestCleanup()
        {
            _table.Delete();
            var correlationTable = _tableClient.GetTableReference(AzureDeliverableSettingConfigurationRepository.FormatCorrelationTableName(_tableName));
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
            var query = new TableQuery<PagedStorageEntity>().Where(TableQuery.GenerateFilterCondition("PartitionKey", QueryComparisons.Equal, partitionKey));
            var rows = _table.ExecuteQuery(query);

            Assert.IsNotNull(rows.SingleOrDefault(r =>
            {
                var setting = _storageObjectSerializer.Deserialize<DeliverableSettingConfiguration>(r.ContentBytes);
                return
                    setting.FundingStreamPeriodCode.Equals(fundingStreamPeriodCode)
                    && setting.DeliverableCode.Equals(deliverableCode)
                    && setting.SettingValue.Setting.SettingName.Equals(settingName)
                    && setting.SettingValue.Value.Equals(settingValue);
            }), "Entity was not present in storage");
        }
    }
}
