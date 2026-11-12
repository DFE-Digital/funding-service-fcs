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
    public class FundingAllocationAllocationFundingStreamConfigWriterTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationAllocationFundingStreamConfigWriter_ShouldInsert()
        {
            // arrange
            const string allocationFundingStreamCode = "test allocationFundingStreamCode";
            const string allocationPeriodId = "test allocationPeriodId";
            RemoveRowsWithPrefix(allocationFundingStreamCode, allocationPeriodId);
            var rows = new List<AllocationFundingStreamSheetType>
            {
                new AllocationFundingStreamSheetType
                {
                    AllocationFundingStreamCode = allocationFundingStreamCode + "1",
                    AllocationPeriodId = allocationPeriodId + "1",
                    FundingTypeCode = "EDSK",
                    FundingPeriodCode = "AY2021",
                    FSPGroupCode = "16-19ED2021"
                },
                new AllocationFundingStreamSheetType
                {
                    AllocationFundingStreamCode = allocationFundingStreamCode + "2",
                    AllocationPeriodId = allocationPeriodId + "2",
                    FundingTypeCode = "EDSK",
                    FundingPeriodCode = "AY2021",
                    FSPGroupCode = "NLG2021"
                }
            };

            // act
            FundingAllocationAllocationFundingStreamConfigWriter.WriteToPaaSDatabase(rows, WriterBehaviour.AddOrUpdate);

            // assert
            var rowsInDb = GetRowsWithPrefix(allocationFundingStreamCode, allocationPeriodId);

            Assert.AreEqual(2, rowsInDb.Count, "Incorrect number of rows inserted");

            RemoveRowsWithPrefix(allocationFundingStreamCode, allocationPeriodId);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationAllocationFundingStreamConfigWriter_ShouldUpdate()
        {
            // arrange
            const string allocationFundingStreamCode = "test allocationFundingStreamCode";
            const string allocationPeriodId = "test allocationPeriodId";
            RemoveRowsWithPrefix(allocationFundingStreamCode, allocationPeriodId);

            var rows = new List<AllocationFundingStreamSheetType>
            {
                new AllocationFundingStreamSheetType
                {
                    AllocationFundingStreamCode = allocationFundingStreamCode + "1",
                    AllocationPeriodId = allocationPeriodId + "1",
                    FundingTypeCode = "EDSK",
                    FundingPeriodCode = "AY2021",
                    FSPGroupCode = "16-19ED2021"
                },
                new AllocationFundingStreamSheetType
                {
                    AllocationFundingStreamCode = allocationFundingStreamCode + "2",
                    AllocationPeriodId = allocationPeriodId + "2",
                    FundingTypeCode = "EDSK",
                    FundingPeriodCode = "AY2021",
                    FSPGroupCode = "NLG2021"
                }
            };

            FundingAllocationAllocationFundingStreamConfigWriter.WriteToPaaSDatabase(rows, WriterBehaviour.AddOrUpdate);
            const string fundingTypeCodeUpdateText = "FundingTypeCode updated";
            const string fundingPeriodCodeUpdateText = "FundingPeriodCode updated";
            const string fspGroupCodeUpdateText = "FSPGroupCode updated";

            rows[0].FundingTypeCode = fundingTypeCodeUpdateText + "1";
            rows[0].FundingPeriodCode = fundingPeriodCodeUpdateText + "1";
            rows[0].FSPGroupCode = fspGroupCodeUpdateText + "1";

            rows[1].FundingTypeCode = fundingTypeCodeUpdateText + "2";
            rows[1].FundingPeriodCode = fundingPeriodCodeUpdateText + "2";
            rows[1].FSPGroupCode = fspGroupCodeUpdateText + "2";

            // act
            FundingAllocationAllocationFundingStreamConfigWriter.WriteToPaaSDatabase(rows, WriterBehaviour.AddOrUpdate);

            // assert
            var rowsInDb = GetRowsWithPrefix(allocationFundingStreamCode, allocationPeriodId);

            bool allRowsFound = rows.All(inputRow => rowsInDb.Any(r =>
                r.AllocationFundingStreamCode == inputRow.AllocationFundingStreamCode &&
                r.AllocationPeriodId == inputRow.AllocationPeriodId &&
                r.FundingTypeCode == inputRow.FundingTypeCode &&
                r.FundingPeriodCode == inputRow.FundingPeriodCode &&
                r.FSPGroupCode == inputRow.FSPGroupCode));

            Assert.IsTrue(allRowsFound, "Row(s) were not updated");

            RemoveRowsWithPrefix(allocationFundingStreamCode, allocationPeriodId);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationAllocationFundingStreamConfigWriter_ShouldDelete()
        {
            // arrange
            const string allocationFundingStreamCode = "test allocationFundingStreamCode";
            const string allocationPeriodId = "test allocationPeriodId";
            RemoveRowsWithPrefix(allocationFundingStreamCode, allocationPeriodId);

            var rows = new List<AllocationFundingStreamSheetType>
            {
                new AllocationFundingStreamSheetType
                {
                    AllocationFundingStreamCode = allocationFundingStreamCode + "1",
                    AllocationPeriodId = allocationPeriodId + "1",
                    FundingTypeCode = "EDSK",
                    FundingPeriodCode = "AY2021",
                    FSPGroupCode = "16-19ED2021"
                },
                new AllocationFundingStreamSheetType
                {
                    AllocationFundingStreamCode = allocationFundingStreamCode + "2",
                    AllocationPeriodId = allocationPeriodId + "2",
                    FundingTypeCode = "EDSK",
                    FundingPeriodCode = "AY2021",
                    FSPGroupCode = "NLG2021"
                }
            };

            FundingAllocationAllocationFundingStreamConfigWriter.WriteToPaaSDatabase(rows, WriterBehaviour.AddOrUpdate);

            rows[0].PolicyStatus = PolicyStatus.Removed;
            rows[1].PolicyStatus = PolicyStatus.Removed;

            // act
            FundingAllocationAllocationFundingStreamConfigWriter.WriteToPaaSDatabase(rows, WriterBehaviour.Delete);

            // assert
            var rowsInDb = GetRowsWithPrefix(allocationFundingStreamCode, allocationPeriodId);

            Assert.AreEqual(0, rowsInDb.Count, "Not all rows have been deleted");

            RemoveRowsWithPrefix(allocationFundingStreamCode, allocationPeriodId);
        }

        private static void RemoveRowsWithPrefix(string allocationFundingStreamCode, string allocationPeriodId)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["PaymentGenerationDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                connection.Execute(
                    @"DELETE FROM [FundingAllocation].[AllocationFundingStreamConfig]
                         WHERE [AllocationFundingStreamCode] LIKE @AllocationFundingStreamCode +'%'
                         AND [AllocationPeriodId] LIKE @AllocationPeriodId  +'%'", new { allocationFundingStreamCode , allocationPeriodId});
            }
        }

        private static IReadOnlyCollection<dynamic> GetRowsWithPrefix(string allocationFundingStreamCode, string allocationPeriodId)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["PaymentGenerationDbContext"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                return connection.Query(
                    @"SELECT * FROM [FundingAllocation].[AllocationFundingStreamConfig]
                         WHERE [AllocationFundingStreamCode] LIKE @AllocationFundingStreamCode +'%'
                         AND [AllocationPeriodId] LIKE @AllocationPeriodId  +'%'", new { allocationFundingStreamCode, allocationPeriodId }).ToList();
            }
        }
    }
}