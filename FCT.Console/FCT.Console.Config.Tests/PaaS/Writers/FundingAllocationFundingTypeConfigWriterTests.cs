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
    public class FundingAllocationFundingTypeConfigWriterTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationFundingTypeConfigWriter_ShouldInsert()
        {
            // arrange
            const string fundingTypeCode = "test insert fundingTypeCode";
            const string contractReferencePrefix = "test insert contractReferencePrefix";
            RemoveRowsWithPrefix(fundingTypeCode);
            var rows = new List<FundingTypeSheetType>
            {
                new FundingTypeSheetType
                {
                    FundingTypeCode = $"{fundingTypeCode}1",
                    ContractReferencePrefix = $"{contractReferencePrefix}1"
                },
                new FundingTypeSheetType
                {
                    FundingTypeCode = $"{fundingTypeCode}2",
                    ContractReferencePrefix = $"{contractReferencePrefix}2"
                }
            };
            // act
            FundingAllocationFundingTypeConfigWriter.WriteToPaaSDatabase(rows, WriterBehaviour.AddOrUpdate);

            // assert
            var rowsInDb = GetRowsWithPrefix(fundingTypeCode);
            bool allRowsFound = rows.All(inputRow => rowsInDb.Any(r =>
                r.FundingTypeCode == inputRow.FundingTypeCode &&
                r.ContractReferencePrefix == inputRow.ContractReferencePrefix));

            Assert.IsTrue(allRowsFound, "Not all rows have been found");

            RemoveRowsWithPrefix(fundingTypeCode);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationFundingTypeConfigWriter_ShouldUpdate()
        {
            // arrange
            const string fundingTypeCode = "test update fundingTypeCode";
            const string contractReferencePrefix = "test update contractReferencePrefix";
            RemoveRowsWithPrefix(fundingTypeCode);
            var rows = new List<FundingTypeSheetType>
            {
                new FundingTypeSheetType
                {
                    FundingTypeCode = $"{fundingTypeCode}1",
                    ContractReferencePrefix = $"{contractReferencePrefix}1"
                },
                new FundingTypeSheetType
                {
                    FundingTypeCode = $"{fundingTypeCode}2",
                    ContractReferencePrefix = $"{contractReferencePrefix}2"
                }
            };
            FundingAllocationFundingTypeConfigWriter.WriteToPaaSDatabase(rows, WriterBehaviour.AddOrUpdate);
            rows[0].ContractReferencePrefix = "contractReferencePrefix 1 updated";
            rows[1].ContractReferencePrefix = "contractReferencePrefix 2 updated";

            // act
            FundingAllocationFundingTypeConfigWriter.WriteToPaaSDatabase(rows, WriterBehaviour.AddOrUpdate);

            // assert
            var rowsInDb = GetRowsWithPrefix(fundingTypeCode);
            bool allRowsFound = rows.All(inputRow => rowsInDb.Any(r =>
                r.FundingTypeCode == inputRow.FundingTypeCode &&
                r.ContractReferencePrefix == inputRow.ContractReferencePrefix));

            Assert.IsTrue(allRowsFound, "Not all rows have been found");

            RemoveRowsWithPrefix(fundingTypeCode);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationFundingTypeConfigWriter_ShouldDelete()
        {
            // arrange
            const string fundingTypeCode = "test delete fundingTypeCode";
            const string contractReferencePrefix = "test delete contractReferencePrefix";
            RemoveRowsWithPrefix(fundingTypeCode);
            var rows = new List<FundingTypeSheetType>
            {
                new FundingTypeSheetType
                {
                    FundingTypeCode = $"{fundingTypeCode}1",
                    ContractReferencePrefix = $"{contractReferencePrefix}1"
                },
                new FundingTypeSheetType
                {
                    FundingTypeCode = $"{fundingTypeCode}2",
                    ContractReferencePrefix = $"{contractReferencePrefix}2"
                }
            };
            FundingAllocationFundingTypeConfigWriter.WriteToPaaSDatabase(rows, WriterBehaviour.AddOrUpdate);

            rows[0].PolicyStatus = PolicyStatus.Removed;
            rows[1].PolicyStatus = PolicyStatus.Removed;

            // act
            FundingAllocationFundingTypeConfigWriter.WriteToPaaSDatabase(rows, WriterBehaviour.Delete);

            // assert
            var rowsInDb = GetRowsWithPrefix(fundingTypeCode);

            Assert.AreEqual(0, rowsInDb.Count, "Not all rows have been deleted");

            RemoveRowsWithPrefix(fundingTypeCode);
        }

        private static void RemoveRowsWithPrefix(string fundingTypeCode)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["PaymentGenerationDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                connection.Execute(@"DELETE FROM [FundingAllocation].[FundingTypeConfig]
                                   WHERE [FundingTypeCode] LIKE @fundingTypeCode +'%'", new { fundingTypeCode });
            }
        }

        private static IReadOnlyCollection<dynamic> GetRowsWithPrefix(string fundingTypeCode)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["PaymentGenerationDbContext"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                return connection.Query(@"SELECT * FROM [FundingAllocation].[FundingTypeConfig]
                                        WHERE [FundingTypeCode] LIKE @fundingTypeCode +'%'", new {fundingTypeCode}).ToList();
            }
        }
    }
}