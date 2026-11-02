namespace SFA.FCT.ContractManagementService.Tests.Integration
{
    using System.Data.SqlClient;
    using System.Linq;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Repositories;
    using global::ContractManagementService.Tests;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    

    [TestClass]
    public class AllContractAtomItemRepositoryTechnicalExploration
    {
        private IAtomItemQueryRepository _allContractRepository;
        private IAtomItemRepository _commandRepository;
        private readonly ContractManagementDbContext _context = new ContractManagementDbContext();

        [TestInitialize]
        public void Initialize()
        {
            _context.Database.Log = s => System.Diagnostics.Debug.WriteLine(s);
            _allContractRepository = new AllContractAtomItemRepository(new SqlConnection(new AppConfiguration()["ConnectionStrings:ContractManagementDbContext"]));
            _commandRepository = new ApprovalOnwardsContractAtomItemRepository(_context);
            _context.Database.ExecuteSqlCommand("delete from [ContractManagement].[AtomFeedItem]");
        }

        [TestCleanup]
        public void Clearup()
        {
            _context?.Dispose();
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void AllContractAtomItemRepository_GetEntitiesForLatestPage_ShouldReturnCachedStoragePage()
        {
            // arrange
            Enumerable.Range(1, 11).ToList().ForEach(i =>
            {
                _commandRepository.Add(AtomFeedItem.CreateAtomFeedItem(string.Empty, $"Some Key{i}", AtomItemType.ApprovedContract, xml => true));
            });

            var storagePageBeforeAssert = _allContractRepository.GetEntitiesForLatestPage();
            Assert.AreEqual(1, storagePageBeforeAssert.Rows.Count);

            // act & assert
            var storagePage = _allContractRepository.GetEntitiesForLatestPage();
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void AllContractAtomItemRepository_GetEntitiesForLatestPage_ShouldCallTheMethodWithinAllContractAtomItemRepository()
        {
            // arrange
            Enumerable.Range(1, 11).ToList().ForEach(i =>
            {
                _commandRepository.Add(AtomFeedItem.CreateAtomFeedItem(string.Empty, $"Some Key{i}", AtomItemType.ApprovedContract, xml => true));
            });

            // act & assert
            var storagePage = _allContractRepository.GetEntitiesForLatestPage();
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void AllContractAtomItemRepository_GetEntitiesForLatestPage_ShouldNotErrorWhenTableIsEmpty()
        {
            // arrange, act & assert
            var storagePage = _allContractRepository.GetEntitiesForLatestPage();
        }

    }
}