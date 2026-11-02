namespace FCT.Console.Config.Tests.PaaS.Writers
{
    using Dapper;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PaymentGenerationDomain.Integration.DataStore;
    using Synchronizers.Writers;
    using Synchronizers.Writers.PAAS;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;

    [TestClass]
    public class FundingAllocationCfsCodesToContractTypeConfigWriterTests
    {
        private static readonly string connectionString = PaymentGenerationDbContext.KeyVaultValue;

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationCfsCodesToContractTypeConfigWriterWriter_ShouldInsert()
        {
            // arrange
            const string fundingTypeCode = "test FundingTypeCode";
            const string fundingPeriodCode = "test FundingPeriodCode";
            const string providerCategory = "test ProviderCategory";
            const string contractType = "test ContractType";

            RemoveRowsWithPrefix(fundingTypeCode, fundingPeriodCode, providerCategory);

            var rows = new List<CfsCodesToContractTypeSheetType>
            {
                new CfsCodesToContractTypeSheetType
                {
                    FundingTypeCode = fundingTypeCode + "1",
                    FundingPeriodCode = fundingPeriodCode + "1",
                    ProviderCategory = providerCategory + "1",
                    ContractType = contractType + "1"
                },
                new CfsCodesToContractTypeSheetType
                {
                    FundingTypeCode = fundingTypeCode + "2",
                    FundingPeriodCode = fundingPeriodCode + "2",
                    ProviderCategory = providerCategory + "2",
                    ContractType = contractType + "2"
                }
            };

            // act
            FundingAllocationCfsCodesToContractTypeConfigWriter.WriteToPaaSDatabase(rows, WriterBehaviour.AddOrUpdate);

            // assert
            var rowsInDb = GetRowsWithPrefix(fundingTypeCode, fundingPeriodCode, providerCategory);

            Assert.AreEqual(2, rowsInDb.Count, "Incorrect number of rows inserted");

            RemoveRowsWithPrefix(fundingTypeCode, fundingPeriodCode, providerCategory);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationCfsCodesToContractTypeConfigWriterWriter_ShouldUpdate()
        {
            // arrange
            const string fundingTypeCode = "test FundingTypeCode";
            const string fundingPeriodCode = "test FundingPeriodCode";
            const string providerCategory = "test ProviderCategory";
            const string contractType = "test ContractType";

            RemoveRowsWithPrefix(fundingTypeCode, fundingPeriodCode, providerCategory);

            var rows = new List<CfsCodesToContractTypeSheetType>
            {
                new CfsCodesToContractTypeSheetType
                {
                    FundingTypeCode = fundingTypeCode + "1",
                    FundingPeriodCode = fundingPeriodCode + "1",
                    ProviderCategory = providerCategory + "1",
                    ContractType = contractType + "1"
                },
                new CfsCodesToContractTypeSheetType
                {
                    FundingTypeCode = fundingTypeCode + "2",
                    FundingPeriodCode = fundingPeriodCode + "2",
                    ProviderCategory = providerCategory + "2",
                    ContractType = contractType + "2"
                }
            };

            FundingAllocationCfsCodesToContractTypeConfigWriter.WriteToPaaSDatabase(rows, WriterBehaviour.AddOrUpdate);

            const string contractTypeUpdateText = "ContractType updated";
            rows[0].ContractType = contractTypeUpdateText + "1";
            rows[1].ContractType = contractTypeUpdateText + "2";

            // act
            FundingAllocationCfsCodesToContractTypeConfigWriter.WriteToPaaSDatabase(rows, WriterBehaviour.AddOrUpdate);

            // assert
            var rowsInDb = GetRowsWithPrefix(fundingTypeCode, fundingPeriodCode, providerCategory);

            bool allRowsFound = rows.All(inputRow => rowsInDb.Any(r =>
                r.FundingTypeCode == inputRow.FundingTypeCode &&
                r.FundingPeriodCode == inputRow.FundingPeriodCode &&
                r.ProviderCategory == inputRow.ProviderCategory &&
                r.ContractType == inputRow.ContractType));

            Assert.IsTrue(allRowsFound, "Row(s) were not updated");

            RemoveRowsWithPrefix(fundingTypeCode, fundingPeriodCode, providerCategory);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationCfsCodesToContractTypeConfigWriterWriter_ShouldDelete()
        {
            // arrange
            const string fundingTypeCode = "test FundingTypeCode";
            const string fundingPeriodCode = "test FundingPeriodCode";
            const string providerCategory = "test ProviderCategory";
            const string contractType = "test ContractType";

            RemoveRowsWithPrefix(fundingTypeCode, fundingPeriodCode, providerCategory);

            var rows = new List<CfsCodesToContractTypeSheetType>
            {
                new CfsCodesToContractTypeSheetType
                {
                    FundingTypeCode = fundingTypeCode + "1",
                    FundingPeriodCode = fundingPeriodCode + "1",
                    ProviderCategory = providerCategory + "1",
                    ContractType = contractType + "1"
                },
                new CfsCodesToContractTypeSheetType
                {
                    FundingTypeCode = fundingTypeCode + "2",
                    FundingPeriodCode = fundingPeriodCode + "2",
                    ProviderCategory = providerCategory + "2",
                    ContractType = contractType + "2"
                },
                new CfsCodesToContractTypeSheetType
                {
                    FundingTypeCode = fundingTypeCode + "3",
                    FundingPeriodCode = fundingPeriodCode + "3",
                    ProviderCategory = providerCategory + "3",
                    ContractType = contractType + "3"
                }
            };

            FundingAllocationCfsCodesToContractTypeConfigWriter.WriteToPaaSDatabase(rows, WriterBehaviour.AddOrUpdate);

            rows[0].PolicyStatus = PolicyStatus.Removed;
            rows[1].PolicyStatus = PolicyStatus.Removed;

            // act
            FundingAllocationCfsCodesToContractTypeConfigWriter.WriteToPaaSDatabase(rows, WriterBehaviour.Delete);

            // assert
            var rowsInDb = GetRowsWithPrefix(fundingTypeCode, fundingPeriodCode, providerCategory);

            Assert.AreEqual(1, rowsInDb.Count, "Not all Removed rows have been deleted");

            RemoveRowsWithPrefix(fundingTypeCode, fundingPeriodCode, providerCategory);
        }

        private static void RemoveRowsWithPrefix(string fundingTypeCode, string fundingPeriodCode, string providerCategory)
        {
            using (var connection = new SqlConnection(connectionString))
            {
                connection.Execute(
                    @"DELETE FROM [FundingAllocation].[CfsCodesToContractTypeConfig]
                         WHERE [FundingTypeCode] LIKE @FundingTypeCode +'%'
                         AND [FundingPeriodCode] LIKE @FundingPeriodCode +'%'
                         AND [ProviderCategory] Like @ProviderCategory +'%'", 
                    new { fundingTypeCode, fundingPeriodCode, providerCategory });
            }
        }

        private static IReadOnlyCollection<dynamic> GetRowsWithPrefix(string fundingTypeCode, string fundingPeriodCode, string providerCategory)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            { return connection.Query(
                    @"SELECT * FROM [FundingAllocation].[CfsCodesToContractTypeConfig]
                         WHERE [FundingTypeCode] LIKE @FundingTypeCode +'%'
                         AND [FundingPeriodCode] LIKE @FundingPeriodCode +'%'
                         AND [ProviderCategory] Like @ProviderCategory +'%'",
                    new { fundingTypeCode, fundingPeriodCode, providerCategory }).ToList();
            }
        }
    }
}