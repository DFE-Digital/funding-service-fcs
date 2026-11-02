namespace CrossDomain.Integration.Common.Tests.Unit
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage.Entities;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage.Repositories;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class AzureDeliverableSettingConfigurationRepositoryTests
    {
        private Mock<IEnvironmentContext> _environmentContextMock;
        private Mock<IAzureTableStore> _azureTableStoreMock;
        private Mock<IStorageObjectSerializer> _storageObjectSerializer;
        private Mock<ILogger> _logger;
        private IPagedStorageRepository<DeliverableSettingConfiguration> _repository;

        [TestInitialize]
        public void TestInitialize()
        {
            _environmentContextMock = new Mock<IEnvironmentContext>();
            _environmentContextMock.SetupGet(m => m.StorageTableSuffix).Returns("DEV");
            _azureTableStoreMock = new Mock<IAzureTableStore>();
            _storageObjectSerializer = new Mock<IStorageObjectSerializer>();
            _logger = new Mock<ILogger>();
            _repository = new AzureDeliverableSettingConfigurationRepository(
                _environmentContextMock.Object,
                _azureTableStoreMock.Object,
                _storageObjectSerializer.Object,
                _logger.Object);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AzureDeliverableSettingConfigurationRepository_Add_ShouldStoreCorrectEntities()
        {
            // act
            _repository.Add(new DeliverableSettingConfiguration());

            // assert
            _azureTableStoreMock.Verify(
                m => m.CreateRow(It.Is<string>(s => s.Equals(_repository.TableName)), It.IsAny<PagedStorageEntity>()),
                Times.Once,
                "Entity was not passed to storage provider.");

            _azureTableStoreMock.Verify(
                m => m.CreateRow(
                        It.Is<string>(s => s.Equals(AzureDeliverableSettingConfigurationRepository.FormatCorrelationTableName(_repository.TableName))),
                        It.IsAny<PagedStorageCorrelationEntity>()),
                Times.Once,
                "Correlation Entity was not passed to storage provider.");
        }

        [TestMethod, TestCategory("UnitTest")]
        [ExpectedException(typeof(ArgumentException))]
        public void AzureDeliverableSettingConfigurationRepository_Add_ShouldThrowArgumentExceptionWhenGivenNull()
        {
            // act
            _repository.Add(null);
        }
        
        [TestMethod, TestCategory("UnitTest")]
        public void AzureDeliverableSettingConfigurationRepository_Reseed_ShouldReseedStorageProviderWithExpectedNumbers()
        {
            const int entityCount = 8632;
            IReadOnlyCollection<PagedStorageCorrelationEntity> storedCorrelationEntities = null;
            IReadOnlyCollection<PagedStorageEntity> storedEntities = null;

            // arrange
            List<DeliverableSettingConfiguration> testEntities =
                Enumerable.Range(1, entityCount)
                .Select(i => new DeliverableSettingConfiguration())
                .ToList();

            _azureTableStoreMock
                .Setup(m => m.CreateRows(It.Is<string>(s => s.Equals(AzureDeliverableSettingConfigurationRepository.FormatCorrelationTableName(_repository.TableName))), It.IsAny<IEnumerable<PagedStorageCorrelationEntity>>()))
                .Callback((string tableName, IEnumerable<PagedStorageCorrelationEntity> correlationEntities) => storedCorrelationEntities = correlationEntities.ToList());

            _azureTableStoreMock
                .Setup(m => m.CreateRows(It.Is<string>(s => s.Equals(_repository.TableName)), It.IsAny<IEnumerable<PagedStorageEntity>>()))
                .Callback((string tableName, IEnumerable<PagedStorageEntity> entities) => storedEntities = entities.ToList());

            // act
            _repository.Reseed(testEntities);

            // assert
            Assert.IsNotNull(storedCorrelationEntities);
            Assert.AreEqual(entityCount, storedCorrelationEntities.Count);

            Assert.IsNotNull(storedEntities);
            Assert.AreEqual(entityCount, storedEntities.Count);
            Assert.AreEqual(10, storedEntities.Count(e => e.PartitionKey == "1"));
            Assert.AreEqual(10, storedEntities.Count(e => e.PartitionKey == "30"));
            Assert.AreEqual(10, storedEntities.Count(e => e.PartitionKey == "155"));
            Assert.AreEqual(10, storedEntities.Count(e => e.PartitionKey == "372"));
            Assert.AreEqual(10, storedEntities.Count(e => e.PartitionKey == "863"));
            Assert.AreEqual(0, storedEntities.Count(e => e.PartitionKey == "864"));
            Assert.AreEqual(2, storedEntities.Count(e => e.PartitionKey == "Latest"));
            Assert.AreEqual(2, storedEntities.Count(e => e.PageNumberOnceCommitted == 864));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AzureDeliverableSettingConfigurationRepository_CalculateReseedPageNumber_ShouldReturnExpectedValue()
        {
            Assert.AreEqual(1, AzureDeliverableSettingConfigurationRepository.CalculateReseedingPageNumber(1));
            Assert.AreEqual(1, AzureDeliverableSettingConfigurationRepository.CalculateReseedingPageNumber(10));
            Assert.AreEqual(2, AzureDeliverableSettingConfigurationRepository.CalculateReseedingPageNumber(11));
            Assert.AreEqual(847, AzureDeliverableSettingConfigurationRepository.CalculateReseedingPageNumber(8468));
            Assert.AreEqual(846, AzureDeliverableSettingConfigurationRepository.CalculateReseedingPageNumber(8460));
            Assert.AreEqual(10, AzureDeliverableSettingConfigurationRepository.CalculateReseedingPageNumber(100));
            Assert.AreEqual(11, AzureDeliverableSettingConfigurationRepository.CalculateReseedingPageNumber(101));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AzureDeliverableSettingConfigurationRepository_CalculateReseedingPartitionKeyForPage_ShouldReturnExpectedValuesWhenEntitiesCountIsNotDivisibleByPageSize()
        {
            Assert.AreEqual("1", AzureDeliverableSettingConfigurationRepository.CalculateReseedingPartitionKeyForPage(1, 8632));
            Assert.AreEqual("303", AzureDeliverableSettingConfigurationRepository.CalculateReseedingPartitionKeyForPage(303, 8632));
            Assert.AreEqual("800", AzureDeliverableSettingConfigurationRepository.CalculateReseedingPartitionKeyForPage(800, 8632));
            Assert.AreEqual("863", AzureDeliverableSettingConfigurationRepository.CalculateReseedingPartitionKeyForPage(863, 8632));
            Assert.AreEqual("Latest", AzureDeliverableSettingConfigurationRepository.CalculateReseedingPartitionKeyForPage(864, 8632));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AzureDeliverableSettingConfigurationRepository_CalculateReseedingPartitionKeyForPage_ShouldReturnExpectedValuesWhenEntitiesCountIsDivisibleByPageSize()
        {
            Assert.AreEqual("1", AzureDeliverableSettingConfigurationRepository.CalculateReseedingPartitionKeyForPage(1, 9600));
            Assert.AreEqual("303", AzureDeliverableSettingConfigurationRepository.CalculateReseedingPartitionKeyForPage(303, 9600));
            Assert.AreEqual("800", AzureDeliverableSettingConfigurationRepository.CalculateReseedingPartitionKeyForPage(800, 9600));
            Assert.AreEqual("863", AzureDeliverableSettingConfigurationRepository.CalculateReseedingPartitionKeyForPage(863, 9600));
            Assert.AreEqual("Latest", AzureDeliverableSettingConfigurationRepository.CalculateReseedingPartitionKeyForPage(960, 9600));
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void AzureDeliverableSettingConfigurationRepository_Clear_ShouldDeleteAllRowsFromUnderlyingTables()
        {
            // arrange
            const int totalRecords = 100;

            AzureTableStore azureTableStore = new AzureTableStore();
            EnvironmentContext environmentContext = new EnvironmentContext();
            string tableName = "DeliverableSettingConfiguration" + environmentContext.StorageTableSuffix;
            string correlationTableName = AzureDeliverableSettingConfigurationRepository.FormatCorrelationTableName(tableName);

            azureTableStore.DeleteAllRows<PagedStorageEntity>(tableName);
            azureTableStore.DeleteAllRows<PagedStorageCorrelationEntity>(correlationTableName);

            AzureDeliverableSettingConfigurationRepository repository = new AzureDeliverableSettingConfigurationRepository(
               environmentContext, azureTableStore, new StorageObjectSerializer(), Mock.Of<ILogger>());

            for (int i = 0; i < totalRecords; i++)
            {
                repository.Add(new DeliverableSettingConfiguration());
            }            

            Assert.AreEqual(totalRecords, azureTableStore.GetRows<PagedStorageEntity>(tableName).Count());
            Assert.AreEqual(totalRecords, azureTableStore.GetRows<PagedStorageCorrelationEntity>(correlationTableName).Count());

            // act
            repository.Clear();

            // assert
            Assert.AreEqual(0, azureTableStore.GetRows<PagedStorageEntity>(tableName).Count());
            Assert.AreEqual(0, azureTableStore.GetRows<PagedStorageCorrelationEntity>(correlationTableName).Count());
        }
    }
}
