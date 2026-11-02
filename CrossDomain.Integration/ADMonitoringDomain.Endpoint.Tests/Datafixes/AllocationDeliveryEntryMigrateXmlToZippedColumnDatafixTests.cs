namespace ADMonitoringDomain.Endpoint.Tests.Datafixes
{
    using System.Collections.Generic;
    using System.Data.SqlClient;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using SFA.FCT.AllocationDelivery.DataStore;
    using SFA.FCT.CrossDomain.Integration.Common;
    using ZipHelper = SFA.FCT.CrossDomain.Integration.Common.ZipHelper;

    [TestClass]
    public class AllocationDeliveryEntryMigrateXmlToZippedColumnDatafixTests
    {
        [TestMethod, TestCategory("DataFix_R25")]
        public void AllocationDeliveryEntry_ShouldMigrateRemainingXmlToZippedColumn()
        {
            IReadOnlyCollection<AllocationDeliveryEntrySummary> allocationDeliveryEntrySummaries = AllocationDeliveryEntryRepository.GetRowsWhereZipColumnIsNotSet();
            allocationDeliveryEntrySummaries.ForEach(ade => AllocationDeliveryEntryRepository.UpdateAllocationDeliveryEntrySummary(ade.Id, ZipHelper.ToZippedBytesFromString(ade.CorporateAllocationDeliveryXml)));

            Assert.AreEqual(0, AllocationDeliveryEntryRepository.GetTotalNumberOfRowsWhereZipColumnIsNotSet(), "Unexpected number of unzipped rows remaining in ADP Feed table after datafix.");
        }

        internal class AllocationDeliveryEntrySummary
        {
            public int Id { get; set; }

            public string CorporateAllocationDeliveryXml { get; set; }
        }

        private static class AllocationDeliveryEntryRepository
        {
            public static IReadOnlyCollection<AllocationDeliveryEntrySummary> GetRowsWhereZipColumnIsNotSet()
            {
                using (var context = new AllocationDeliveryDbContext())
                {
                    return context.Database.SqlQuery<AllocationDeliveryEntrySummary>(
                        "select ID, [CorporateAllocationDeliveryXml] from [AllocationDelivery].[AllocationDeliveryEntry] where [CorporateAllocationDeliveryBytes] is null")
                        .ToList();
                }
            }

            public static void UpdateAllocationDeliveryEntrySummary(int id, byte[] zippedBytes)
            {
                using (var context = new AllocationDeliveryDbContext())
                {
                    context.Database.ExecuteSqlCommand(
                        "update [AllocationDelivery].[AllocationDeliveryEntry] set [CorporateAllocationDeliveryBytes] = @Zippedbytes, [CorporateAllocationDeliveryXml] = null " +
                        "where ID = @ID",
                        new SqlParameter("@Zippedbytes", zippedBytes),
                        new SqlParameter("@ID", id));
                }
            }

            public static int GetTotalNumberOfRowsWhereZipColumnIsNotSet()
            {
                using (var context = new AllocationDeliveryDbContext())
                {
                    return context.Database.SqlQuery<int>(
                        "select count(1) from [AllocationDelivery].[AllocationDeliveryEntry] where [CorporateAllocationDeliveryBytes] is null").ToList().First();
                }
            }
        }
    }
}
