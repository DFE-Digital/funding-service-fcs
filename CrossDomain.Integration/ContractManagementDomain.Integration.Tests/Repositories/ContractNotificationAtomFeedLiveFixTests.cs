namespace SFA.FCT.ContractManagementDomain.Integration.Tests.Repositories
{
    using System.Collections.Generic;
    using System.Data.SqlClient;
    using System.Linq;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using CrossDomain.Integration.Common.Serializers;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using CorporateSchema = CrossDomain.Integration.Entities.CorporateSchema.Contract;

    [TestClass]
    public class ContractNotificationAtomFeedLiveFixTests
    {
        private const string DatabaseConnectionString = "";
        private const int ExpectedEsfAtomFeedItemCount = 125;

        /// <remarks>
        /// IMPORTANT: This fix is predicated on the scenario that only null Learning Rate Premium
        /// values are present in CRM and should therefore be represented as decimal 1 in the Atom Feed.
        /// </remarks>
        [TestMethod, TestCategory("DataFix_LiveFix")]
        public void ContractManagementDbContext_ShouldUpdateAllEsfAllocationsInAtomFeedWithLearningRatePremiumOfDecimalOne()
        {
            // fix
            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                context.Database.Connection.ConnectionString = DatabaseConnectionString;

                List<AtomFeedItem> esfAtomFeedItems = context.AtomFeedItems
                    .Where(a => a.BusinessKey.StartsWith("ESIF-"))
                    .ToList();

                Assert.AreEqual(ExpectedEsfAtomFeedItemCount, esfAtomFeedItems.Count, "Did not select expected number of items before update.");

                int rowsUpdatedCount = 0;

                esfAtomFeedItems
                    .ForEach(atomFeedItem =>
                    {
                        CorporateSchema.contract masterContract = atomFeedItem.AtomFeedItemXml.DeserializeXml<CorporateSchema.contract>();
                        CorporateSchema.contractAllocationsContractAllocation esfAllocation = 
                            masterContract.contracts.Single().contractAllocations.Single(a => a.contractAllocationNumber.StartsWith("ESF-"));

                        // manipulate the deserialized instance to mimic the original when re-serialized
                        masterContract.period = null;
                        masterContract.contractStatus = null;

                        // the datafix itself
                        esfAllocation.ProcurementAttrs.LearningRatePremium = 1m;

                        string revisedXml = masterContract.SerializeToXml();
                        rowsUpdatedCount += context.Database.ExecuteSqlCommand(
                            "UPDATE ContractManagement.AtomFeedItem SET AtomFeedItemXml = @revisedXml WHERE Id = @atomFeedItemId",
                            new SqlParameter("@revisedXml", revisedXml),
                            new SqlParameter("@atomFeedItemId", atomFeedItem.Id));
                    });

                Assert.AreEqual(ExpectedEsfAtomFeedItemCount, rowsUpdatedCount, "Did not update expected number of items.");
            }

            // assert rows are now correct
            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                context.Database.Connection.ConnectionString = DatabaseConnectionString;

                List<AtomFeedItem> esfAtomFeedItems = context.AtomFeedItems
                    .Where(a => a.BusinessKey.StartsWith("ESIF-"))
                    .ToList();

                Assert.AreEqual(ExpectedEsfAtomFeedItemCount, esfAtomFeedItems.Count, "Did not select expected number of items after update.");

                esfAtomFeedItems
                    .ForEach(atomFeedItem =>
                    {
                        CorporateSchema.contract masterContract = atomFeedItem.AtomFeedItemXml.DeserializeXml<CorporateSchema.contract>();
                        CorporateSchema.contractAllocationsContractAllocation esfAllocation =
                            masterContract.contracts.Single().contractAllocations.Single(a => a.contractAllocationNumber.StartsWith("ESF-"));

                        Assert.AreEqual(1m, esfAllocation.ProcurementAttrs.LearningRatePremium);
                    });

            }
        }
    }
}
