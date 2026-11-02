namespace Datafix.Tests
{
    using System.Collections.Generic;
    using System.Data.SqlClient;
    using System.Linq;
    using ContractManagement.DataStore;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using SFA.FCT.CrossDomain.Integration.Common;

    [TestClass]
    public class MigrateLegalContractAtomFeedToZippedStorage
    {
        [TestMethod, TestCategory("DataFix_R44")]
        public void MigrateOutstandingAtomItemsToZippedStorage()
        {
            IReadOnlyCollection<int> atomFeedItemIdsToZip = GetAtomFeedItemIdsToZip();

            atomFeedItemIdsToZip
                .Batch(100)
                .ForEach(batchOfIds =>
                {
                    IReadOnlyCollection<AtomFeedItemInfo> atomFeedItems = GetAtomFeedItemsByIds(batchOfIds);
                    atomFeedItems.ForEach(MigrateAtomFeedItemToZippedStorage);
                });

            int unzippedItemCount = GetCountOfUnzippedItems();
            Assert.AreEqual(0, unzippedItemCount, "Unzipped Atom Feed items remain.");
        }

        private static IReadOnlyCollection<int> GetAtomFeedItemIdsToZip()
        {
            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                return context.Database.SqlQuery<int>(
                    "SELECT Id FROM ContractManagement.AtomFeedItem WHERE AtomFeedItemBytes IS NULL ORDER BY Id")
                    .ToList();
            }
        }

        private static IReadOnlyCollection<AtomFeedItemInfo> GetAtomFeedItemsByIds(IEnumerable<int> atomFeedItemIds)
        {
            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                return context.Database.SqlQuery<AtomFeedItemInfo>(
                    $"SELECT Id, AtomFeedItemXml FROM ContractManagement.AtomFeedItem WHERE Id IN ({string.Join(", ", atomFeedItemIds)})")
                    .ToList();
            }
        }

        private static void MigrateAtomFeedItemToZippedStorage(AtomFeedItemInfo atomFeedItem)
        {
            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                context.Database.ExecuteSqlCommand(
                    "UPDATE ContractManagement.AtomFeedItem SET AtomFeedItemBytes = @zippedbytes, AtomFeedItemXml = null WHERE Id = @id",
                    new SqlParameter("@zippedbytes", ZipHelper.ToZippedBytesFromString(atomFeedItem.AtomFeedItemXml)),
                    new SqlParameter("@id", atomFeedItem.Id));
            }
        }

        private static int GetCountOfUnzippedItems()
        {
            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                return context.Database.SqlQuery<int>(
                    "SELECT COUNT(*) FROM ContractManagement.AtomFeedItem WHERE AtomFeedItemBytes IS NULL")
                    .First();
            }
        }


        private class AtomFeedItemInfo
        {
            public int Id { get; set; }

            public string AtomFeedItemXml { get; set; }
        }
    }
}
