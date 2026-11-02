using System.Collections.Generic;
using System.Data.Entity;
using System.Data.SqlClient;
using System.Linq;
using ContractManagement.DataStore;
using ContractManagement.DataStore.Model;
using ContractManagement.DataStore.Repositories;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using SFA.FCT.CrossDomain.Integration.Entities.Data;

namespace ContractManagementService.Tests.UnitTests.Repositories
{
    [TestClass, TestCategory("UnitTest")]
    public class AtomItemDataStoreRepositoryTests
    {
        [TestMethod]
        public void ApprovedContractAtomItemRepository_Add_PersistsAtomFeedItem()
        {
            var context = CreateContext();
            var item = CreateAtomFeedItem("contract-1");
            var repository = new ApprovedContractAtomItemRepository(context.Context.Object);

            repository.Add(item);

            CollectionAssert.AreEqual(new[] { item }, context.AtomItems);
            context.Context.Verify(db => db.SaveChanges(), Times.Once);
        }

        [TestMethod]
        public void ApprovedContractAtomItemRepository_GetIdentifierForBusinessKey_ReturnsMatchingIdentifier()
        {
            var expectedIdentifier = System.Guid.NewGuid();
            var item = AtomFeedItem.CreateAtomFeedItem(
                "contract data",
                "contract-1",
                AtomItemType.ApprovedContract,
                expectedIdentifier,
                _ => true);
            var context = CreateContext(item);
            var repository = new ApprovedContractAtomItemRepository(context.Context.Object);

            var result = repository.GetIdentifierForBusinessKey("contract-1", AtomItemType.ApprovedContract);

            Assert.AreEqual(expectedIdentifier, result);
            Assert.IsNull(repository.GetIdentifierForBusinessKey("missing", AtomItemType.ApprovedContract));
        }

        [TestMethod]
        public void ApprovalOnwardsContractAtomItemRepository_AddWithDefaultConnection_UsesDefaultContext()
        {
            var context = CreateContext();
            var item = CreateAtomFeedItem("approved-contract-1");
            var repository = new ApprovalOnwardsContractAtomItemRepository(context.Context.Object);

            repository.Add(ConnectionInfo.CreateDefault(), item);

            CollectionAssert.AreEqual(new[] { item }, context.AtomItems);
            context.Context.Verify(db => db.SaveChanges(), Times.Once);
        }

        [TestMethod]
        public void DraftContractAtomItemRepository_Add_PersistsDraftAtomFeedItem()
        {
            var context = CreateContext();
            var item = AtomFeedItem.CreateAtomFeedItem(
                "draft contract",
                "draft-1",
                AtomItemType.DraftContract,
                _ => true);
            var repository = new DraftContractAtomItemRepository(context.Context.Object);

            repository.Add(item);

            CollectionAssert.AreEqual(new[] { item }, context.AtomItems);
            context.Context.Verify(db => db.SaveChanges(), Times.Once);
        }

        [TestMethod]
        public void WithdrawnContractAtomItemRepository_Add_PersistsWithdrawnAtomFeedItem()
        {
            var context = CreateContext();
            var item = AtomFeedItem.CreateAtomFeedItem(
                "withdrawn contract",
                "withdrawn-1",
                AtomItemType.WithdrawnContract,
                _ => true);
            var repository = new WithdrawnContractAtomItemRepository(context.Context.Object);

            repository.Add(item);

            CollectionAssert.AreEqual(new[] { item }, context.AtomItems);
            context.Context.Verify(db => db.SaveChanges(), Times.Once);
        }

        [TestMethod]
        public void AtomItemQueryRepository_GetPreviousPageNumber_ReturnsPreviousPageOrNullAtFirstPage()
        {
            var repository = new ApprovedContractAtomItemRepository(CreateContext().Context.Object);

            Assert.IsNull(repository.GetPreviousPageNumber(0));
            Assert.AreEqual(2, repository.GetPreviousPageNumber(3));
            Assert.AreEqual(10, repository.PageSize);
        }

        [TestMethod]
        public void ValidationLookupDataCache_CachesLookupResult()
        {
            var expected = new[] { "FSP1", "FSP2" };
            var factoryCalls = 0;

            var first = ValidationLookupDataCache.Get(
                ValidationLookupType.FspLegalDeliverable,
                () =>
                {
                    factoryCalls++;
                    return expected;
                });
            var second = ValidationLookupDataCache.Get(
                ValidationLookupType.FspLegalDeliverable,
                () =>
                {
                    factoryCalls++;
                    return new[] { "unexpected" };
                });

            Assert.AreSame(expected, first);
            Assert.AreSame(first, second);
            Assert.AreEqual(1, factoryCalls);
        }

        private static AtomFeedItem CreateAtomFeedItem(string businessKey)
        {
            return AtomFeedItem.CreateAtomFeedItem(
                "contract data",
                businessKey,
                AtomItemType.ApprovedContract,
                _ => true);
        }

        private static MockContext CreateContext(params AtomFeedItem[] items)
        {
            var atomItems = items.ToList();
            var set = new Mock<DbSet<AtomFeedItem>>();
            var query = atomItems.AsQueryable();
            set.As<IQueryable<AtomFeedItem>>().SetupGet(dbSet => dbSet.Provider).Returns(query.Provider);
            set.As<IQueryable<AtomFeedItem>>().SetupGet(dbSet => dbSet.Expression).Returns(query.Expression);
            set.As<IQueryable<AtomFeedItem>>().SetupGet(dbSet => dbSet.ElementType).Returns(query.ElementType);
            set.As<IQueryable<AtomFeedItem>>().Setup(dbSet => dbSet.GetEnumerator()).Returns(() => query.GetEnumerator());
            set.Setup(dbSet => dbSet.Add(It.IsAny<AtomFeedItem>()))
                .Callback<AtomFeedItem>(atomItems.Add)
                .Returns<AtomFeedItem>(addedItem => addedItem);

            var context = new Mock<IContractManagementDbContext>();
            context.SetupGet(db => db.Connection).Returns(new SqlConnection("Server=(local);Database=UnitTests;"));
            context.SetupGet(db => db.AtomFeedItems).Returns(set.Object);
            return new MockContext(context, atomItems);
        }

        private sealed class MockContext(Mock<IContractManagementDbContext> context, List<AtomFeedItem> atomItems)
        {
            public Mock<IContractManagementDbContext> Context { get; } = context;

            public List<AtomFeedItem> AtomItems { get; } = atomItems;
        }
    }
}
