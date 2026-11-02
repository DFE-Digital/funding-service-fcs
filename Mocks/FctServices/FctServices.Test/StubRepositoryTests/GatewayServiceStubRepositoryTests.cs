namespace FctServices.Test.StubRepositoryTests
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using ServiceImplementation.GatewayService;
    using Storage;

    [TestClass]
    public class GatewayServiceStubRepositoryTests
    {
        private const string UnSuffixedTableName = "GatewayServiceStub";
        private const string PartitionKey = "GatewayServiceStubPartitionKey";
        private GatewayServiceStubRepository _stubRepository;
        private IAzureTableStore _azureTableStore;

        [TestInitialize]
        public void TestInitialize()
        {
            _azureTableStore = new AzureTableStore();
            _stubRepository = new GatewayServiceStubRepository(_azureTableStore);
            TestCleanup();
        }

        [TestCleanup]
        public void TestCleanup()
        {
            _azureTableStore.DeleteRows($"{UnSuffixedTableName}{ConfigurationManager.AppSettings["StorageTableSuffix"]}", PartitionKey);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void GatewayServiceStubRepository_Add_ShouldAddEntityToRepository()
        {
            // act
            _stubRepository.Add(new GatewayServiceStubEntity
            {
                Ukprn = "12345",
                Status = "ACTIVE"
            });

            // assert
            GatewayServiceStubEntity retrievedEntity = _stubRepository.FindByUkprn("12345");
            Assert.AreEqual("12345", retrievedEntity.Ukprn, "Unexpected UKPRN returned from repository.");
            Assert.AreEqual("ACTIVE", retrievedEntity.Status, "Unexpected Status returned from repository.");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void GatewayServiceStubRepository_Update_ShouldUpdateExistingEntityInRepository()
        {
            // act
            _stubRepository.Add(new GatewayServiceStubEntity
            {
                Ukprn = "23456",
                Status = "ACTIVE"
            });

            GatewayServiceStubEntity storedEntity = _stubRepository.FindByUkprn("23456");

            storedEntity.Status = "DISSOLVED";
            _stubRepository.Update(storedEntity);

            // assert
            GatewayServiceStubEntity retrievedEntity = _stubRepository.FindByUkprn("23456");
            Assert.AreEqual("23456", retrievedEntity.Ukprn, "Unexpected UKPRN returned from repository.");
            Assert.AreEqual("DISSOLVED", retrievedEntity.Status, "Unexpected Status returned from repository.");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void GatewayServiceStubRepository_GetAll_ShouldRetrieveAllEntitiesFromRepository()
        {
            // arrange
            _stubRepository.Add(new GatewayServiceStubEntity { Ukprn = "12345", Status = "ACTIVE" });
            _stubRepository.Add(new GatewayServiceStubEntity { Ukprn = "23456", Status = "INACTIVE" });
            _stubRepository.Add(new GatewayServiceStubEntity { Ukprn = "34567", Status = "INLIQUIDATION" });

            // act
            IReadOnlyCollection<GatewayServiceStubEntity> retrievedEntities = _stubRepository.GetAll();

            // assert
            Assert.AreEqual(3, retrievedEntities.Count(), "Unexpected number of entities returned from repository.");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void GatewayServiceStubRepository_Clear_ShouldRemoveAllEntitiesFromRepository()
        {
            // arrange
            _stubRepository.Add(new GatewayServiceStubEntity { Ukprn = "12345", Status = "ACTIVE" });
            _stubRepository.Add(new GatewayServiceStubEntity { Ukprn = "23456", Status = "INACTIVE" });
            _stubRepository.Add(new GatewayServiceStubEntity { Ukprn = "34567", Status = "INLIQUIDATION" });

            // act
            _stubRepository.Clear();

            // assert
            IReadOnlyCollection<GatewayServiceStubEntity> retrievedEntities = _stubRepository.GetAll();
            Assert.AreEqual(0, retrievedEntities.Count(), "Unexpected number of entities returned from repository.");
        }


        [TestMethod, TestCategory("IntegrationTest")]
        public void GatewayServiceStubRepository_FindByUkprn_ShouldReturnCorrectEntity()
        {
            // arrange
            _stubRepository.Add(new GatewayServiceStubEntity { Ukprn = "12345", Status = "ACTIVE" });
            _stubRepository.Add(new GatewayServiceStubEntity { Ukprn = "23456", Status = "INACTIVE" });
            _stubRepository.Add(new GatewayServiceStubEntity { Ukprn = "34567", Status = "INLIQUIDATION" });

            // act
            GatewayServiceStubEntity entity = _stubRepository.FindByUkprn("23456");

            // assert
            Assert.IsNotNull(entity, "Returned entity was null.");
            Assert.AreEqual("23456", entity.Ukprn, "Incorrect UKPRN returned from repository.");
            Assert.AreEqual("INACTIVE", entity.Status, "Incorrect Status returned from repository.");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void GatewayServiceStubRepository_FindByUkprn_ShouldReturnNullWhenNoMatchingEntity()
        {
            // arrange
            _stubRepository.Add(new GatewayServiceStubEntity { Ukprn = "12345", Status = "ACTIVE" });
            _stubRepository.Add(new GatewayServiceStubEntity { Ukprn = "23456", Status = "INACTIVE" });
            _stubRepository.Add(new GatewayServiceStubEntity { Ukprn = "34567", Status = "INLIQUIDATION" });

            // act
            GatewayServiceStubEntity entity = _stubRepository.FindByUkprn("45678");

            // assert
            Assert.IsNull(entity, "Returned entity was not null.");
        }
    }
}