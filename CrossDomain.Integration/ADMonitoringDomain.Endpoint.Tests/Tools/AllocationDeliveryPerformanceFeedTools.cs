namespace ADMonitoringDomain.Endpoint.Tests.Tools
{
    using System.Data.SqlClient;
    using System.IO;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using SFA.FCT.AllocationDelivery.DataStore;

    [TestClass]
    public class AllocationDeliveryPerformanceFeedTools
    {
        [TestMethod, TestCategory("Tooling")]
        public void RetrieveAndUnzipAllocationDeliveryPerformanceFeedEvent()
        {
            const string sqlConnectionString = "";
            const string allocationNumber = "LEVY-1018";

            using (var sqlConnection = new SqlConnection(sqlConnectionString))
            using (var allocationDeliveryDbContext = new AllocationDeliveryDbContext(sqlConnection))
            {
                allocationDeliveryDbContext.AllocationDeliveryEntries
                    .Where(adp => adp.AllocationNumber == allocationNumber)
                    .ForEach(adp =>
                    {
                        string fileName = $"{adp.ID}-{adp.AllocationNumber}-v{adp.VersionNumber}.{adp.SubVersionNumber}-{adp.AllocationDeliveryCategory}";
                        string fileContent = adp.GetAllocationDeliveryPerformanceXml();

                        FileInfo fileInfo = new FileInfo($"UnzippedAtomFeedContent\\{fileName}.xml");
                        fileInfo.Directory?.Create();
                        File.WriteAllText(fileInfo.FullName, fileContent);
                    });

            }
        }
    }
}
