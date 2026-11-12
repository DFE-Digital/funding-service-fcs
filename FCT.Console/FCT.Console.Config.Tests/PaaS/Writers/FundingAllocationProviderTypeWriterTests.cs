namespace FCT.Console.Config.Tests.PaaS.Writers
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using Dapper;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Writers;
    using Synchronizers.Writers.PAAS;

    [TestClass]
    public class FundingAllocationProviderTypeWriterTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationProviderType_ShouldInsert()
        {
            // arrange
            const string providerType = "test pt";
            RemoveRowsForProviderType(providerType);
            List<AllocationProviderTypeSheet> insertRows = new List<AllocationProviderTypeSheet>
            {
                new AllocationProviderTypeSheet
                {
                    ProviderType = providerType,
                    ProviderCategory = "some cat 1",
                    ProviderSubType = "some st1"
                },
                new AllocationProviderTypeSheet
                {
                    ProviderType = providerType,
                    ProviderCategory = "some cat 2",
                    ProviderSubType = "some st2"
                }
            };

            // act
            FundingAllocationProviderTypeWriter.WriteToPaaSDatabase(insertRows, WriterBehaviour.AddOrUpdate);

            // assert
            var rowsRetrieved = GetRowsForProvideType(providerType);
            
            bool allRowsFound = insertRows.All(insertRow => rowsRetrieved.Any(r =>
                r.Type == insertRow.ProviderType &&
                r.Subtype == insertRow.ProviderSubType &&
                r.Category == insertRow.ProviderCategory));
            Assert.IsTrue(allRowsFound, "Not all rows have been inserted");

            RemoveRowsForProviderType(providerType);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationProviderType_ShouldUpdate()
        {
            // arrange
            const string providerType = "test pt";
            RemoveRowsForProviderType(providerType);
            List<AllocationProviderTypeSheet> insertRows = new List<AllocationProviderTypeSheet>
            {
                new AllocationProviderTypeSheet
                {
                    ProviderType = providerType,
                    ProviderCategory = "some cat 1",
                    ProviderSubType = "some st1"
                },
                new AllocationProviderTypeSheet
                {
                    ProviderType = providerType,
                    ProviderCategory = "some cat 2",
                    ProviderSubType = "some st2"
                }
            };

            List<AllocationProviderTypeSheet> updateRows = new List<AllocationProviderTypeSheet>
            {
                new AllocationProviderTypeSheet
                {
                    ProviderType = providerType,
                    ProviderCategory = "some cat 1",
                    ProviderSubType = "some st3"
                },
                new AllocationProviderTypeSheet
                {
                    ProviderType = providerType,
                    ProviderCategory = "some cat 2",
                    ProviderSubType = "some st4"
                }
            };
            FundingAllocationProviderTypeWriter.WriteToPaaSDatabase(insertRows, WriterBehaviour.AddOrUpdate);

            // act
            FundingAllocationProviderTypeWriter.WriteToPaaSDatabase(updateRows, WriterBehaviour.AddOrUpdate);

            // assert
            var rowsRetrieved = GetRowsForProvideType(providerType);
            bool allRowsFound = updateRows.All(updateRow => rowsRetrieved.Any(r =>
                r.Type == updateRow.ProviderType &&
                r.Subtype == updateRow.ProviderSubType &&
                r.Category == updateRow.ProviderCategory));
            Assert.IsTrue(allRowsFound, "Not all rows have been updated");

            RemoveRowsForProviderType(providerType);
        }

        private static void RemoveRowsForProviderType(string providerType)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["PaymentGenerationDbContext"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Execute(
                    "Delete from [FundingAllocation].[ProviderTypeConfig] where [Type] = @providerType", new { providerType });
            }
        }

        private static IReadOnlyCollection<dynamic> GetRowsForProvideType(string providerType)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["PaymentGenerationDbContext"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                return connection.Query(
                    "Select * from [FundingAllocation].[ProviderTypeConfig] where [Type] = @providerType", new { providerType }).ToList();
            }
        }
    }
}
