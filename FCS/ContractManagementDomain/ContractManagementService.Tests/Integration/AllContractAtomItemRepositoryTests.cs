namespace SFA.FCT.ContractManagementService.Tests.Integration
{
    using System.Linq;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;
    using System;
    using System.Collections.Generic;
    using System.Data.SqlClient;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Repositories;
    using CrossDomain.Integration.Entities.Data;
    using global::ContractManagementService.Tests;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class AllContractAtomItemRepositoryTests
    {
        private IAtomItemQueryRepository _allContractRepository;
        private IAtomItemRepository _commandRepository;
        private ContractManagementDbContext _context = null;

        [TestInitialize]
        public void Initialize()
        {
            _context = GetContractManagementDbContext();
            _context.Database.Log = s => System.Diagnostics.Debug.WriteLine(s);
            _commandRepository = new ApprovalOnwardsContractAtomItemRepository(_context);
            _context.Database.ExecuteSqlCommand("delete from [ContractManagement].[AtomFeedItem]");
            _allContractRepository = new AllContractAtomItemRepository(new SqlConnection(new AppConfiguration()["ConnectionStrings:ContractManagementDbContext"]));
        }

        private ContractManagementDbContext GetContractManagementDbContext()
        {
            return new ContractManagementDbContext(new ConnectionInfo(null, new SqlConnection(new AppConfiguration()["ConnectionStrings:ContractManagementDbContext"])));
        }

        [TestCleanup]
        public void Clearup()
        {
            _context?.Dispose();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AllContractAtomItemRepository_ShouldReturnContractsOnly()
        {
            // arrange
            const int nonContractAtomItemType = 999;
            
            AtomItemType[] contractTypes =
            {
                AtomItemType.DraftContract,
                AtomItemType.WithdrawnContract,
                AtomItemType.ApprovedContract,
                AtomItemType.ContractTerminationDetailsUpdated
            };
//            AtomItemType.ContractTerminationInitiated
            _commandRepository.Add(AtomFeedItem.CreateAtomFeedItem(string.Empty, "Some Key", AtomItemType.ApprovedContract, xml => true));
            _commandRepository.Add(AtomFeedItem.CreateAtomFeedItem(string.Empty, "Some Key1", AtomItemType.DraftContract, xml => true));
            _commandRepository.Add(AtomFeedItem.CreateAtomFeedItem(string.Empty, "Some Key2", AtomItemType.WithdrawnContract, xml => true));
            _commandRepository.Add(AtomFeedItem.CreateAtomFeedItem(string.Empty, "Some Key3", AtomItemType.ContractTerminationDetailsUpdated, xml => true));

            // now add the non contract type
            _context.Database.ExecuteSqlCommand("INSERT INTO [ContractManagement].[AtomFeedItem] Values({0},{1},{2},{3},{4},{5},{6})",
                Guid.NewGuid(), nonContractAtomItemType, "Special Type Key", "xml", DateTime.Now, new byte[0], Guid.Empty);

            // act
            StoragePage<AtomFeedItem> storagePage = _allContractRepository.GetEntitiesForLatestPage();

            // assert
            bool anyNonContractAtomItems = storagePage.Rows.Any(e => !contractTypes.Contains(e.ItemType));
            Assert.IsFalse(anyNonContractAtomItems, "The AllContractAtomItemRepository has returned some non contract atom items");
            Assert.IsTrue(storagePage.Rows[0].Id == storagePage.Rows[1].Id - 1 && storagePage.Rows[1].Id == storagePage.Rows[2].Id - 1, "Ordering of Items is incorrect");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AllContractAtomItemRepository_ShouldGetEntitiesForPage()
        {
            // arrange
            Enumerable.Range(1, 11).ToList().ForEach(i =>
            {
                _commandRepository.Add(AtomFeedItem.CreateAtomFeedItem(string.Empty, $"Some Key{i}", AtomItemType.ApprovedContract, xml => true));
            });

            const int firstPage = 0;

            // act
            StoragePage<AtomFeedItem> storagePage = _allContractRepository.GetEntitiesForPage(firstPage);

            // assert
            Assert.AreEqual(10, storagePage.Rows.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AllContractAtomItemRepository_ShouldGetEntitiesForLatestPage()
        {
            // arrange
            Enumerable.Range(1, 11).ToList().ForEach(i =>
            {
                _commandRepository.Add(AtomFeedItem.CreateAtomFeedItem(string.Empty, $"Some Key{i}", AtomItemType.ApprovedContract, xml => true));
            });

            // act
            StoragePage<AtomFeedItem> storagePage = _allContractRepository.GetEntitiesForLatestPage();

            // assert
            Assert.AreEqual(1, storagePage.Rows.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AllContractAtomItemRepository_GetEntitiesForLatestPage_ShouldGetCorrectNumberOfEntitiesAfterARowIsAdded()
        {
            // arrange
            Enumerable.Range(1, 11).ToList().ForEach(i =>
            {
                _commandRepository.Add(AtomFeedItem.CreateAtomFeedItem(string.Empty, $"Some Key{i}", AtomItemType.ApprovedContract, xml => true));
            });

            var storagePageBeforeAssert = _allContractRepository.GetEntitiesForLatestPage();
            Assert.AreEqual(1, storagePageBeforeAssert.Rows.Count);

            _commandRepository.Add(AtomFeedItem.CreateAtomFeedItem(string.Empty, $"Some Key12", AtomItemType.ApprovedContract, xml => true));
  
            // act
            var storagePage = _allContractRepository.GetEntitiesForLatestPage();

            // assert
            Assert.AreEqual(2, storagePage.Rows.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AllContractAtomItemRepository_ShouldGetNextPageNumber()
        {
            // arrange
            Enumerable.Range(1, 21).ToList().ForEach(i =>
            {
                _commandRepository.Add(AtomFeedItem.CreateAtomFeedItem(string.Empty, $"Some Key{i}", AtomItemType.ApprovedContract, xml => true));
            });
            const int firstPage = 0;

            // act
            int? nextPageNumber = _allContractRepository.GetNextPageNumber(firstPage);

            // assert
            Assert.AreEqual(1, nextPageNumber);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AllContractAtomItemRepository_ShouldReturnExpectedEventsOnly()
        {
            // arrange
            AtomItemType[] validAtomItemTypesForAllContractFeed =
            {
                AtomItemType.DraftContract,
                AtomItemType.WithdrawnContract,
                AtomItemType.ApprovedContract,
                AtomItemType.ClosedContract,
                AtomItemType.ContractTerminationInitiated,
                AtomItemType.CancelledContractTermination,
                AtomItemType.ContractTerminated,
                AtomItemType.ContractTerminationDetailsUpdated,
                AtomItemType.ContractModified,
                AtomItemType.TerminationModificationDetailsUpdated,
                AtomItemType.ContractModificationCancelled
            };

            List<AtomFeedItem> testAtomItems =
                Enumerable.Range(0, Enum.GetNames(typeof(AtomItemType)).Length)
                    .Select(atomItemTypeInt => AtomFeedItem.CreateAtomFeedItem(string.Empty, $"INTEGRATION{atomItemTypeInt}", (AtomItemType)atomItemTypeInt, Guid.NewGuid(), xml => true))
                    .ToList();

            using (var context = GetContractManagementDbContext())
            {
                context.ExecuteSql("TRUNCATE TABLE ContractManagement.AtomFeedItem");
                testAtomItems.ForEach(item => context.AtomFeedItems.Add(item));
                context.SaveChanges();
            }

            using (var context = GetContractManagementDbContext())
            {
                var repository = new AllContractAtomItemRepository(new SqlConnection(new AppConfiguration()["ConnectionStrings:ContractManagementDbContext"]));

                // act
                var feedItems = new List<AtomFeedItem>()
                    .Concat(repository.GetEntitiesForLatestPage().Rows)
                    .Concat(repository.GetEntitiesForPage(0).Rows) // effectively page 1 after mutation at controller level
                    .ToList(); 

                // assert
                validAtomItemTypesForAllContractFeed.ToList().ForEach(validAtomItemType =>
                {
                    AtomFeedItem expectedItem = feedItems.SingleOrDefault(feedItem => feedItem.ItemType == validAtomItemType);
                    Assert.IsNotNull(expectedItem, $"Feed did not contain item for type {validAtomItemType}");
                });
            }
        }
    }
}
