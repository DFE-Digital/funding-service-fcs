namespace FCT.Operations.Common.Tests.Tools
{
    using System.Data.SqlClient;
    using System.IO;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using SFA.FCT.AllocationDelivery.DataStore;
    using SFA.FCT.AllocationDelivery.DataStore.Model;

    [TestClass]
    public class AllocationDeliveryPerformanceAtomFeedRetrievalTools
    {
        private const string SqlConnectionString = "<CONNECTION STRING>";

        [TestMethod]
        public void RetrieveAdpFeedItemXmlAndWriteToDisk()
        {
            int[] databaseIds = {182973, 253567};

            using (AllocationDeliveryDbContext allocationDeliveryDbContext = new AllocationDeliveryDbContext(new SqlConnection(SqlConnectionString)))
            {
                databaseIds.ForEach(id =>
                {
                    AllocationDeliveryEntry atomFeedItem = allocationDeliveryDbContext.AllocationDeliveryEntries.Single(ade => ade.ID == id);
                    FileInfo fileInfo = new FileInfo($@"Extracts\\{atomFeedItem.AllocationNumber}-v{atomFeedItem.VersionNumber}.{atomFeedItem.SubVersionNumber}-{atomFeedItem.AllocationDeliveryCategory}.xml");
                    fileInfo.Directory.Create();
                    File.WriteAllText(fileInfo.FullName, atomFeedItem.GetAllocationDeliveryPerformanceXml());
                });
            }
        }
    }
}
