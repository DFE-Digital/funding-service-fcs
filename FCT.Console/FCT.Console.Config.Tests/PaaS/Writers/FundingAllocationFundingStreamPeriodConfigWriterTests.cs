namespace FCT.Console.Config.Tests.PaaS.Writers
{
    using System;
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
    public class FundingAllocationFundingStreamPeriodConfigWriterTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationFundingStreamPeriodConfigWriter_ShouldInsert()
        {
            // arrange
            const string fundingStreamPeriodCode = "test insert fundingStreamPeriodCode";
            const string fundingStreamCode = "test insert fundingStreamCode";
            const string allocationReferencePrefix = "test insert allocationReferencePrefix";
            DateTime startDate = DateTime.Now.Date;
            DateTime endDate = startDate.AddYears(1);
            RemoveRowsWithPrefix(fundingStreamPeriodCode);

            var rows = new List<FundingStreamPeriodSheetType>
            {
                new FundingStreamPeriodSheetType
                {
                    FundingStreamPeriodCode = $"{fundingStreamPeriodCode}1",
                    FundingStreamCode =  $"{fundingStreamCode}1",
                    AllocationReferencePrefix =  $"{allocationReferencePrefix}1",
                    StartDate = startDate,
                    EndDate = endDate
                },
                new FundingStreamPeriodSheetType
                {
                    FundingStreamPeriodCode = $"{fundingStreamPeriodCode}2",
                    FundingStreamCode =  $"{fundingStreamCode}2",
                    AllocationReferencePrefix =  $"{allocationReferencePrefix}2",
                    StartDate = startDate.AddMonths(1),
                    EndDate = endDate.AddMonths(1)
                }
            };
            // act
            FundingAllocationFundingStreamPeriodConfigWriter.WriteToPaaSDatabase(rows, WriterBehaviour.AddOrUpdate);

            // assert
            var rowsInDb = GetRowsWithPrefix(fundingStreamPeriodCode);
            bool allRowsFound = rows.All(inputRow => rowsInDb.Any(r =>
                r.FundingStreamPeriodCode == inputRow.FundingStreamPeriodCode &&
                r.FundingStreamCode == inputRow.FundingStreamCode &&
                r.AllocationReferencePrefix == inputRow.AllocationReferencePrefix &&
                r.StartDate == inputRow.StartDate &&
                r.EndDate == inputRow.EndDate));

            Assert.IsTrue(allRowsFound, "Not all rows have been found");

            RemoveRowsWithPrefix(fundingStreamPeriodCode);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationFundingStreamPeriodConfigWriter_ShouldUpdate()
        {
            // arrange
            const string fundingStreamPeriodCode = "test update fundingStreamPeriodCode";
            const string fundingStreamCode = "test update fundingStreamCode";
            const string allocationReferencePrefix = "test update allocationReferencePrefix";
            DateTime startDate = DateTime.Now.Date;
            DateTime endDate = startDate.AddYears(1);
            DateTime newStartDate = startDate.AddMonths(-1);
            DateTime newEndDate = endDate.AddMonths(-1);
            RemoveRowsWithPrefix(fundingStreamPeriodCode);

            var rows = new List<FundingStreamPeriodSheetType>
            {
                new FundingStreamPeriodSheetType
                {
                    FundingStreamPeriodCode = $"{fundingStreamPeriodCode}1",
                    FundingStreamCode =  $"{fundingStreamCode}1",
                    AllocationReferencePrefix =  $"{allocationReferencePrefix}1",
                    StartDate = startDate,
                    EndDate = endDate
                },
                new FundingStreamPeriodSheetType
                {
                    FundingStreamPeriodCode = $"{fundingStreamPeriodCode}2",
                    FundingStreamCode =  $"{fundingStreamCode}2",
                    AllocationReferencePrefix =  $"{allocationReferencePrefix}2",
                    StartDate = startDate.AddMonths(1),
                    EndDate = endDate.AddMonths(1)
                }
            };
            FundingAllocationFundingStreamPeriodConfigWriter.WriteToPaaSDatabase(rows, WriterBehaviour.AddOrUpdate);
            rows[0].FundingStreamCode = "FundingStreamCode 1 updated";
            rows[0].AllocationReferencePrefix = "AllocationReferencePrefix 1 updated";
            rows[0].StartDate = newStartDate;
            rows[0].EndDate = newEndDate;
            rows[1].FundingStreamCode = "FundingStreamCode 1 updated";
            rows[1].AllocationReferencePrefix = "AllocationReferencePrefix 2 updated";

            // act
            FundingAllocationFundingStreamPeriodConfigWriter.WriteToPaaSDatabase(rows, WriterBehaviour.AddOrUpdate);

            // assert
            var rowsInDb = GetRowsWithPrefix(fundingStreamPeriodCode);
            bool allRowsFound = rows.All(inputRow => rowsInDb.Any(r =>
                r.FundingStreamPeriodCode == inputRow.FundingStreamPeriodCode &&
                r.FundingStreamCode == inputRow.FundingStreamCode &&
                r.AllocationReferencePrefix == inputRow.AllocationReferencePrefix &&
                r.StartDate == inputRow.StartDate &&
                r.EndDate == inputRow.EndDate));

            Assert.IsTrue(allRowsFound, "Not all rows have been found");

            RemoveRowsWithPrefix(fundingStreamPeriodCode);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationFundingStreamPeriodConfigWriter_ShouldDelete()
        {
            // arrange
            const string fundingStreamPeriodCode = "test update fundingStreamPeriodCode";
            const string fundingStreamCode = "test update fundingStreamCode";
            const string allocationReferencePrefix = "test update allocationReferencePrefix";
            RemoveRowsWithPrefix(fundingStreamPeriodCode);
            DateTime startDate = DateTime.Now.Date;
            DateTime endDate = startDate.AddYears(1);
            var rows = new List<FundingStreamPeriodSheetType>
            {
                new FundingStreamPeriodSheetType
                {
                    FundingStreamPeriodCode = $"{fundingStreamPeriodCode}1",
                    FundingStreamCode =  $"{fundingStreamCode}1",
                    AllocationReferencePrefix =  $"{allocationReferencePrefix}1",
                    StartDate = startDate,
                    EndDate = endDate
                },
                new FundingStreamPeriodSheetType
                {
                    FundingStreamPeriodCode = $"{fundingStreamPeriodCode}2",
                    FundingStreamCode =  $"{fundingStreamCode}2",
                    AllocationReferencePrefix =  $"{allocationReferencePrefix}2",
                    StartDate = startDate,
                    EndDate = endDate
                }
            };
            FundingAllocationFundingStreamPeriodConfigWriter.WriteToPaaSDatabase(rows, WriterBehaviour.AddOrUpdate);

            rows[0].PolicyStatus = PolicyStatus.Removed;
            rows[1].PolicyStatus = PolicyStatus.Removed;

            // act
            FundingAllocationFundingStreamPeriodConfigWriter.WriteToPaaSDatabase(rows, WriterBehaviour.Delete);

            // assert
            var rowsInDb = GetRowsWithPrefix(fundingStreamPeriodCode);

            Assert.AreEqual(0, rowsInDb.Count, "Not all rows have been deleted");

            RemoveRowsWithPrefix(fundingStreamPeriodCode);
        }

        private static void RemoveRowsWithPrefix(string fundingStreamPeriodCode)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["PaymentGenerationDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                connection.Execute(@"DELETE FROM [FundingAllocation].[FundingStreamPeriodConfig]
                                   WHERE [FundingStreamPeriodCode] LIKE @FundingStreamPeriodCode +'%'", new {fundingStreamPeriodCode});
            }
        }

        private static IReadOnlyCollection<dynamic> GetRowsWithPrefix(string fundingStreamPeriodCode)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["PaymentGenerationDbContext"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                return connection.Query(@"SELECT * FROM [FundingAllocation].[FundingStreamPeriodConfig]
                                        WHERE [FundingStreamPeriodCode] LIKE @FundingStreamPeriodCode +'%'", new {fundingStreamPeriodCode}).ToList();
            }
        }
    }
}