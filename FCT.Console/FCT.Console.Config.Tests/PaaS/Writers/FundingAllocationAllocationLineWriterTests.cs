namespace FCT.Console.Config.Tests.PaaS.Writers
{
    using System.Collections;
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
    public class FundingAllocationAllocationLineWriterTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationAllocationLineWriter_ShouldInsert()
        {
            // arrange
            const string testFundingStream = "Test Fs";
            const string testFundingStreamPeriod = "Test Fsp";

            RemoveAllocationLineConfigRowsForFundingStream(testFundingStream);
            RemoveFspDeliverableRowsForFsp(testFundingStreamPeriod);
            InsertFspDeliverableConfigRow(testFundingStreamPeriod, 1);
            InsertFspDeliverableConfigRow(testFundingStreamPeriod, 2);

            var inputRows = new List<AllocationLinesSheet>
            {
                new AllocationLinesSheet
                {
                    AllocationFundingStreamCode = testFundingStream,
                    AllocationPeriodId = "pId",
                    AllocationFundingLineCode = "lineCode",
                    ProviderCategory = "pc1",
                    FspCode = testFundingStreamPeriod,
                    DeliverableCode = 1
                },
                new AllocationLinesSheet
                {
                    AllocationFundingStreamCode = testFundingStream,
                    AllocationPeriodId = "pId2",
                    AllocationFundingLineCode = "lineCode2",
                    ProviderCategory = "pc2",
                    FspCode = testFundingStreamPeriod,
                    DeliverableCode = 2
                }
            };

            // act
            FundingAllocationAllocationLineWriter.WriteToPaaSDatabase(rows: inputRows, behaviour: WriterBehaviour.AddOrUpdate);

            // assert
            var rows = GetRowsForFundingStream(testFundingStream);
            bool allRowsFound = inputRows.All(inputRow => rows.Any(r =>
                r.FundingStreamCode == inputRow.AllocationFundingStreamCode &&
                r.PeriodId == inputRow.AllocationPeriodId && 
                r.FundingLineCode == inputRow.AllocationFundingLineCode &&
                r.ProviderCategory == inputRow.ProviderCategory &&
                r.FspCode == inputRow.FspCode &&
                r.DeliverableCode == inputRow.DeliverableCode));

            Assert.IsTrue(allRowsFound, "Not all rows have been found");

            RemoveAllocationLineConfigRowsForFundingStream(testFundingStream);
            RemoveFspDeliverableRowsForFsp(testFundingStreamPeriod);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationAllocationLineWriter_ShouldUpdate()
        {
            // arrange
            const string testFundingStream = "Test Fsp";

            RemoveAllocationLineConfigRowsForFundingStream(testFundingStream);
            RemoveFspDeliverableRowsForFsp("fsp1");
            RemoveFspDeliverableRowsForFsp("fsp2");
            RemoveFspDeliverableRowsForFsp("fsp3");
            RemoveFspDeliverableRowsForFsp("fsp4");
            InsertFspDeliverableConfigRow("fsp1", 1);
            InsertFspDeliverableConfigRow("fsp1", 2);
            InsertFspDeliverableConfigRow("fsp3", 4);
            InsertFspDeliverableConfigRow("fsp4", 8);

            var insertRows = new List<AllocationLinesSheet>
            {
                new AllocationLinesSheet
                {
                    AllocationFundingStreamCode = testFundingStream,
                    AllocationPeriodId = "pId",
                    AllocationFundingLineCode = "lineCode",
                    ProviderCategory = "pc1",
                    FspCode = "fsp1",
                    DeliverableCode = 1
                },
                new AllocationLinesSheet
                {
                    AllocationFundingStreamCode = testFundingStream,
                    AllocationPeriodId = "pId2",
                    AllocationFundingLineCode = "lineCode2",
                    ProviderCategory = "pc2",
                    FspCode = "fsp1",
                    DeliverableCode = 2
                }
            };

            var updateRows = new List<AllocationLinesSheet>
            {
                new AllocationLinesSheet
                {
                    AllocationFundingStreamCode = testFundingStream,
                    AllocationPeriodId = "pId",
                    AllocationFundingLineCode = "lineCode",
                    ProviderCategory = "pc1",
                    FspCode = "fsp3",
                    DeliverableCode = 4
                },
                new AllocationLinesSheet
                {
                    AllocationFundingStreamCode = testFundingStream,
                    AllocationPeriodId = "pId2",
                    AllocationFundingLineCode = "lineCode2",
                    ProviderCategory = "pc2",
                    FspCode = "fsp4",
                    DeliverableCode = 8
                }
            };
            FundingAllocationAllocationLineWriter.WriteToPaaSDatabase(rows: insertRows, behaviour: WriterBehaviour.AddOrUpdate);

            // act
            FundingAllocationAllocationLineWriter.WriteToPaaSDatabase(rows: updateRows, behaviour: WriterBehaviour.AddOrUpdate);

            // assert
            var rows = GetRowsForFundingStream(testFundingStream);
            bool allRowsFound = updateRows.All(inputRow => rows.Any(r =>
                r.FundingStreamCode == inputRow.AllocationFundingStreamCode &&
                r.PeriodId == inputRow.AllocationPeriodId &&
                r.FundingLineCode == inputRow.AllocationFundingLineCode &&
                r.ProviderCategory == inputRow.ProviderCategory &&
                r.FspCode == inputRow.FspCode &&
                r.DeliverableCode == inputRow.DeliverableCode));

            Assert.IsTrue(allRowsFound, "Not all rows have been found");

            RemoveAllocationLineConfigRowsForFundingStream(testFundingStream);
            RemoveFspDeliverableRowsForFsp("fsp1");
            RemoveFspDeliverableRowsForFsp("fsp2");
            RemoveFspDeliverableRowsForFsp("fsp3");
            RemoveFspDeliverableRowsForFsp("fsp4");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationAllocationLineWriter_ShouldDelete()
        {
            // arrange
            const string testFundingStream = "Test Fs";
            const string testFundingStreamPeriod = "Test Fsp";

            RemoveAllocationLineConfigRowsForFundingStream(testFundingStream);
            RemoveFspDeliverableRowsForFsp(testFundingStreamPeriod);
            InsertFspDeliverableConfigRow(testFundingStreamPeriod, 1);
            InsertFspDeliverableConfigRow(testFundingStreamPeriod, 2);

            var inputRows = new List<AllocationLinesSheet>
            {
                new AllocationLinesSheet
                {
                    AllocationFundingStreamCode = testFundingStream,
                    AllocationPeriodId = "pId",
                    AllocationFundingLineCode = "lineCode",
                    ProviderCategory = "pc1",
                    FspCode = testFundingStreamPeriod,
                    DeliverableCode = 1
                },
                new AllocationLinesSheet
                {
                    AllocationFundingStreamCode = testFundingStream,
                    AllocationPeriodId = "pId2",
                    AllocationFundingLineCode = "lineCode2",
                    ProviderCategory = "pc2",
                    FspCode = testFundingStreamPeriod,
                    DeliverableCode = 2
                }
            };
            FundingAllocationAllocationLineWriter.WriteToPaaSDatabase(inputRows, WriterBehaviour.AddOrUpdate);

            inputRows[0].PolicyStatus = PolicyStatus.Removed;
            inputRows[1].PolicyStatus = PolicyStatus.Removed;


            // act
            FundingAllocationAllocationLineWriter.WriteToPaaSDatabase(rows: inputRows, behaviour: WriterBehaviour.Delete);

            // assert
            var rows = GetRowsForFundingStream(testFundingStream);
            Assert.AreEqual(0, rows.Count, "Not all rows have been deleted");

            RemoveAllocationLineConfigRowsForFundingStream(testFundingStream);
            RemoveFspDeliverableRowsForFsp(testFundingStreamPeriod);
        }

        private static void RemoveAllocationLineConfigRowsForFundingStream(string fs)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["PaymentGenerationDbContext"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Execute(
                    "Delete from [FundingAllocation].[AllocationLineConfig] where [FundingStreamCode] = @fs", new {fs});
            }
        }

        private static void RemoveFspDeliverableRowsForFsp(string fsp)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["PaymentGenerationDbContext"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Execute(
                    "Delete from [FundingAllocation].[FspDeliverableConfig] where [FspCode] = @fsp", new { fsp });
            }
        }

        private static void InsertFspDeliverableConfigRow(string fsp, int deliverableCode)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["PaymentGenerationDbContext"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Execute(
                    "insert into [FundingAllocation].[FspDeliverableConfig] ([FspCode], [DeliverableCode], [DeliverableName]) values (@fsp, @deliverableCode, 'Test')", new { fsp, deliverableCode });
            }
        }

        private static IReadOnlyCollection<dynamic> GetRowsForFundingStream(string fs)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["PaymentGenerationDbContext"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                return connection.Query(
                    "Select * from [FundingAllocation].[AllocationLineConfig] where [FundingStreamCode] = @fs", new { fs }).ToList();
            }
        }
    }
}
