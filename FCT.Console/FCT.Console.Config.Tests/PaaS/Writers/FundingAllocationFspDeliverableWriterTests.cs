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
    public class FundingAllocationFspDeliverableConfigWriterTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationFspDeliverableConfigWriter_ShouldInsert()
        {
            // arrange
            const string fspCode = "test fsp1";
            RemoveRowsForFsp(fspCode);
            List<FundingStreamPeriodDeliverablesSheetType> rows = new List<FundingStreamPeriodDeliverablesSheetType>
            {
                new FundingStreamPeriodDeliverablesSheetType
                {
                    FundingStreamPeriodCode = fspCode,
                    DeliverableCode = 123,
                    DeliverableName = "123",
                    DisplayOrder = 1
                },
                new FundingStreamPeriodDeliverablesSheetType
                {
                    FundingStreamPeriodCode = fspCode,
                    DeliverableCode = 124,
                    DeliverableName = "124",
                    DisplayOrder = 2
                }
            };
            // act
            FundingAllocationFspDeliverableConfigWriter.WriteToPaaSDatabase(rows, WriterBehaviour.AddOrUpdate);
            
            // assert
            var rowsInDb = GetRowsForFsp(fspCode);
            bool allRowsFound = rows.All(inputRow => rowsInDb.Any(r =>
                r.FspCode == inputRow.FspCode &&
                r.DeliverableCode == inputRow.DeliverableCode &&
                r.DeliverableName == inputRow.DeliverableName &&
                r.DisplayOrder == inputRow.DisplayOrder));

            Assert.IsTrue(allRowsFound, "Not all rows have been found");

            RemoveRowsForFsp(fspCode);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationFspDeliverableConfigWriter_ShouldUpdate()
        {
            // arrange
            const string fspCode = "test fsp1";
            RemoveRowsForFsp(fspCode);
            var rows = new List<FundingStreamPeriodDeliverablesSheetType>
            {
                new FundingStreamPeriodDeliverablesSheetType
                {
                    FundingStreamPeriodCode = fspCode,
                    DeliverableCode = 123,
                    DeliverableName = "123",
                    DisplayOrder = 1
                },
                new FundingStreamPeriodDeliverablesSheetType
                {
                    FundingStreamPeriodCode = fspCode,
                    DeliverableCode = 124,
                    DeliverableName = "124",
                    DisplayOrder = 2
                }
            };
            FundingAllocationFspDeliverableConfigWriter.WriteToPaaSDatabase(rows, WriterBehaviour.AddOrUpdate);
            rows[0].DeliverableName = "new d1";
            rows[1].DeliverableName = "new d2";
            rows[0].DisplayOrder = 900;
            rows[1].DisplayOrder = 901;

            // act
            FundingAllocationFspDeliverableConfigWriter.WriteToPaaSDatabase(rows, WriterBehaviour.AddOrUpdate);

            // assert
            var rowsInDb = GetRowsForFsp(fspCode);
            bool allRowsFound = rows.All(inputRow => rowsInDb.Any(r =>
                r.FspCode == inputRow.FspCode &&
                r.DeliverableCode == inputRow.DeliverableCode &&
                r.DeliverableName == inputRow.DeliverableName &&
                r.DisplayOrder == inputRow.DisplayOrder));

            Assert.IsTrue(allRowsFound, "Not all rows have been found");

            RemoveRowsForFsp(fspCode);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationFspDeliverableConfigWriter_ShouldDelete()
        {
            // arrange
            const string fspCode = "test fsp1";
            RemoveRowsForFsp(fspCode);
            var rows = new List<FundingStreamPeriodDeliverablesSheetType>
            {
                new FundingStreamPeriodDeliverablesSheetType
                {
                    FundingStreamPeriodCode = fspCode,
                    DeliverableCode = 123,
                    DeliverableName = "123",
                },
                new FundingStreamPeriodDeliverablesSheetType
                {
                    FundingStreamPeriodCode = fspCode,
                    DeliverableCode = 124,
                    DeliverableName = "124",
                }
            };
            FundingAllocationFspDeliverableConfigWriter.WriteToPaaSDatabase(rows, WriterBehaviour.AddOrUpdate);

            rows[0].PolicyStatus = PolicyStatus.Removed;
            rows[1].PolicyStatus = PolicyStatus.Removed;

            // act
            FundingAllocationFspDeliverableConfigWriter.WriteToPaaSDatabase(rows, WriterBehaviour.Delete);

            // assert
            var rowsInDb = GetRowsForFsp(fspCode);

            Assert.AreEqual(0, rowsInDb.Count, "Not all rows have been deleted");

            RemoveRowsForFsp(fspCode);
        }

        private static void RemoveRowsForFsp(string fspCode)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["PaymentGenerationDbContext"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Execute(
                    "Delete from [FundingAllocation].[FspDeliverableConfig] where [FspCode] = @fspCode", new { fspCode });
            }
        }

        private static IReadOnlyCollection<dynamic> GetRowsForFsp(string fsp)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["PaymentGenerationDbContext"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                return connection.Query(
                    "Select * from [FundingAllocation].[FspDeliverableConfig] where [FspCode] = @fsp", new { fsp }).ToList();
            }
        }
    }
}
