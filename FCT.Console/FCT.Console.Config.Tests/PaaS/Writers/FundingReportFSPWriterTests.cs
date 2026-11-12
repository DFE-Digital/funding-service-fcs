namespace FCT.Console.Config.Tests.PaaS.Writers
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using Dapper;
    using ExcelTypes;
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Writers;
    using Synchronizers.Writers.PAAS;

    [TestClass]
    public class FundingReportFSPWriterTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingReportFSPWriter_ShouldUpdate()
        {
            // arrange
            const string fspCode = "TestFSP";
            const string fundingPeriod = "AY2021";
            const int originalOrder = 1;
            const int newOrder = 1;
            const string originalDesc = "D1";
            const string newDesc = "D1";
            RemoveRowsForFsp(fspCode);
            InsertRow(fspCode, originalOrder, fundingPeriod, originalDesc);

            var sheetTypes = new List<FundingReportFSPSheetType>
            {
                new FundingReportFSPSheetType
                {
                    FspCode = fspCode,
                    FundingPeriod = fundingPeriod,
                    Order = newOrder,
                    PolicyStatus = PolicyStatus.Approved,
                    Description = newDesc
                }
            };

            // act
            OperationsFundingReportFSPWriter.WriteToPaaSDatabase(sheetTypes, WriterBehaviour.AddOrUpdate);

            // assert
            var rowsInDb = GetRowsForFspCode(fspCode);
            rowsInDb.Count.Should().Be(1);
            Assert.AreEqual(newOrder, rowsInDb.Single().Order);
            Assert.AreEqual(newDesc, rowsInDb.Single().Description);
        }

        private static void InsertRow(string fspCode, int order, string fundingPeriod, string desc)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["PaymentGenerationDbContext"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                const string sql = @"insert into [Operations].[FundingReportFSP]
                                    ([FspCode]
                                    ,[Order]
                                    ,[FundingPeriod]
                                    ,[Description])
                                values(@FspCode, @Order, @FundingPeriod, @desc)";

                connection.Execute(sql, new { fspCode, order, fundingPeriod, desc });
            }
        }

        private static void RemoveRowsForFsp(string fspCode)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["PaymentGenerationDbContext"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Execute(
                    "Delete from [Operations].[FundingReportFSP] where [FspCode] = @fspCode", new { fspCode });
            }
        }

        private static IReadOnlyCollection<dynamic> GetRowsForFspCode(string fspCode)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["PaymentGenerationDbContext"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                return connection.Query(
                    "Select * from [Operations].[FundingReportFSP] where [FspCode] = @fspCode", new { fspCode }).ToList();
            }
        }
    }
}
