namespace FCT.Console.Config.Tests.PaaS.Writers
{
    using Dapper;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PaymentGenerationDomain.Integration.DataStore;
    using Synchronizers.Writers;
    using Synchronizers.Writers.PAAS;
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;

    [TestClass]
    public class FundingAllocationFundingTypeFundingPeriodConfigWriterTests
    {
        private static readonly string connectionString = PaymentGenerationDbContext.KeyVaultValue;

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationFundingTypeFundingPeriodConfigWriter_ShouldInsert()
        {
            // arrange
            const string fundingTypeCode = "test FundingTypeCode";
            const string fundingPeriod = "test FundingPeriod";
            const string ftpGroupCode = "test FtpGroupCode";
            const string precedingFtpFundingType = "test PrecedingFtpFundingType";
            const string precedingFtpFundingPeriod = "test PrecedingFtpFundingPeriod";
            const bool includeAllContractsOnSummaryOfFunding = true;
            const bool allowNewAmendment = true;

            RemoveRowsWithPrefix(fundingTypeCode, fundingPeriod);

            var rows = Enumerable.Range(1, 2)
                .Select(suffix => new FundingTypePeriodSheetType
                {
                    FundingTypeCode = fundingTypeCode + suffix,
                    FundingPeriod = fundingPeriod + suffix,
                    FtpGroupCode = ftpGroupCode + suffix,
                    PrecedingFtpFundingType = precedingFtpFundingType + suffix,
                    PrecedingFtpFundingPeriod = precedingFtpFundingPeriod + suffix,
                    IncludeAllContractsOnSummaryOfFunding = includeAllContractsOnSummaryOfFunding,
                    AllowNewAmendment = allowNewAmendment,
                    AllAmendmentsRequireSigning = true
                }).ToList();

            // act
            FundingAllocationFundingTypeFundingPeriodConfigWriter.WriteToPaaSDatabase(rows, WriterBehaviour.AddOrUpdate);

            // assert
            var rowsInDb = GetRowsWithPrefix(fundingTypeCode, fundingPeriod);

            Assert.AreEqual(2, rowsInDb.Count, "Incorrect number of rows inserted");

            RemoveRowsWithPrefix(fundingTypeCode, fundingPeriod);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationFundingTypeFundingPeriodConfigWriter_ShouldUpdate()
        {
            // arrange
            const string fundingTypeCode = "test FundingTypeCode";
            const string fundingPeriod = "test FundingPeriodme";
            const string ftpGroupCode = "test FtpGroupCode";
            const string precedingFtpFundingType = "test PrecedingFtpFundingType";
            const string precedingFtpFundingPeriod = "test PrecedingFtpFundingPeriod";
            const bool includeAllContractsOnSummaryOfFunding = true;
            const bool allowNewAmendment = true;

            RemoveRowsWithPrefix(fundingTypeCode, fundingPeriod);

            var rows = Enumerable.Range(1, 2)
                .Select(suffix => new FundingTypePeriodSheetType
                {
                    FundingTypeCode = fundingTypeCode + suffix,
                    FundingPeriod = fundingPeriod + suffix,
                    FtpGroupCode = ftpGroupCode + suffix,
                    PrecedingFtpFundingType = precedingFtpFundingType + suffix,
                    PrecedingFtpFundingPeriod = precedingFtpFundingPeriod + suffix,
                    IncludeAllContractsOnSummaryOfFunding = includeAllContractsOnSummaryOfFunding,
                    AllowNewAmendment = allowNewAmendment,
                    AllAmendmentsRequireSigning =  true
                }).ToList();

            FundingAllocationFundingTypeFundingPeriodConfigWriter.WriteToPaaSDatabase(rows, WriterBehaviour.AddOrUpdate);

            const string precedingFtpGroupCodeText = "UPDATED FtpGroupCode";
            const string precedingFtpFundingTypeUpdateText = "UPDATED PrecedingFtpFundingType";
            const string precedingFtpFundingPeriodUpdateText = "UPDATED PrecedingFtpFundingPeriod";

            var i = 1;
            rows.ForEach((row) =>
            {
                row.FtpGroupCode = precedingFtpGroupCodeText + i;
                row.PrecedingFtpFundingType = precedingFtpFundingTypeUpdateText + i;
                row.PrecedingFtpFundingPeriod = precedingFtpFundingPeriodUpdateText + i;
                row.IncludeAllContractsOnSummaryOfFunding = false;
                row.AllowNewAmendment = false;
                row.AllAmendmentsRequireSigning = false;
                i++;
            });

            // act
            FundingAllocationFundingTypeFundingPeriodConfigWriter.WriteToPaaSDatabase(rows, WriterBehaviour.AddOrUpdate);

            // assert
            i = 1;
            rows.ForEach(row =>
            {
                var (actualFtpGroupCode, actualPrecedingFtpFundingType, actualPrecedingFtpFundingPeriod, 
                        actualIncludeAllContractsOnSummaryOfFunding, actualAllowNewAmendment, actualAllAmendmentsRequireSigning) = 
                    GetUpdatedDataItems(fundingTypeCode + i, fundingPeriod + i);

                Assert.AreEqual(precedingFtpGroupCodeText + i, actualFtpGroupCode, "ftpGroupCode was not updated");
                Assert.AreEqual(precedingFtpFundingTypeUpdateText + i, actualPrecedingFtpFundingType, "precedingFtpFundingType was not updated");
                Assert.AreEqual(precedingFtpFundingPeriodUpdateText + i, actualPrecedingFtpFundingPeriod, "precedingFtpFundingPeriod was not updated");
                Assert.IsFalse(actualIncludeAllContractsOnSummaryOfFunding, "includeAllContractsOnSummaryOfFunding was not updated");
                Assert.IsFalse(actualAllowNewAmendment, "actualAllowNewAmendment was not updated");
                Assert.IsFalse(actualAllAmendmentsRequireSigning, "allAmendmentsRequireSigningUpdateBool was not updated to false");
                i++;
            });

            RemoveRowsWithPrefix(fundingTypeCode, fundingPeriod);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationFundingTypeFundingPeriodConfigWriter_ShouldDelete()
        {
            // arrange
            const string fundingTypeCode = "test FundingTypeCode";
            const string fundingPeriod = "test FundingPeriod";
            const string ftpGroupCode = "test FtpGroupCode";
            const string precedingFtpFundingType = "test PrecedingFtpFundingType";
            const string precedingFtpFundingPeriod = "test PrecedingFtpFundingPeriod";

            RemoveRowsWithPrefix(fundingTypeCode, fundingPeriod);

            var rows = Enumerable.Range(1, 2)
                .Select(suffix => new FundingTypePeriodSheetType
                {
                    FundingTypeCode = fundingTypeCode + suffix,
                    FundingPeriod = fundingPeriod + suffix,
                    FtpGroupCode = ftpGroupCode + suffix,
                    PrecedingFtpFundingType = precedingFtpFundingType + suffix,
                    PrecedingFtpFundingPeriod = precedingFtpFundingPeriod + suffix
                }).ToList();

            FundingAllocationFundingTypeFundingPeriodConfigWriter.WriteToPaaSDatabase(rows, WriterBehaviour.AddOrUpdate);

            rows[0].PolicyStatus = PolicyStatus.Removed;

            // act
            FundingAllocationFundingTypeFundingPeriodConfigWriter.WriteToPaaSDatabase(rows, WriterBehaviour.Delete);

            // assert
            var rowsInDb = GetRowsWithPrefix(fundingTypeCode, fundingPeriod);

            Assert.AreEqual(1, rowsInDb.Count, "Not all Removed rows have been deleted");

            RemoveRowsWithPrefix(fundingTypeCode, fundingPeriod);
        }

        private static void RemoveRowsWithPrefix(string fundingTypeCode, string fundingPeriod)
        {
            using (var connection = new SqlConnection(connectionString))
            {
                connection.Execute(
                    @"DELETE FROM [FundingAllocation].[FundingTypeFundingPeriodConfig]
                         WHERE [FundingTypeCode] LIKE @FundingTypeCode +'%'
                         AND [fundingPeriod] LIKE @fundingPeriod +'%'",
                    new { fundingTypeCode, fundingPeriod });
            }
        }

        private static IReadOnlyCollection<dynamic> GetRowsWithPrefix(string fundingTypeCode, string fundingPeriod)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                return connection.Query(
                      @"SELECT * FROM [FundingAllocation].[FundingTypeFundingPeriodConfig]
                         WHERE [FundingTypeCode] LIKE @FundingTypeCode +'%'
                         AND [fundingPeriod] LIKE @fundingPeriod +'%'",
                      new { fundingTypeCode, fundingPeriod }).ToList();
            }
        }

        private static Tuple<string, string, string, bool, bool, bool?> GetUpdatedDataItems(string fundingTypeCode, string fundingPeriod)
        {
            using (var connection = new SqlConnection(connectionString))
            {
                var sql = @"SELECT FtpGroupCode, PrecedingFtpFundingType, PrecedingFtpFundingPeriod, 
                                   IncludeAllContractsOnSummaryOfFunding, AllowNewAmendment, allAmendmentsRequireSigning
                         FROM [FundingAllocation].[FundingTypeFundingPeriodConfig]
                         WHERE [FundingTypeCode] = @FundingTypeCode
                         AND [fundingPeriod] = @fundingPeriod";
                
                var (ftpGroupCode, precedingFtpFundingType, precedingFtpFundingPeriod, 
                     includeAllContractsOnSummaryOfFunding, allowNewAmendment, allAmendmentsRequireSigning) =
                    connection.QuerySingle<(string FtpGroupCode, string PrecedingFtpFundingType, string PrecedingFtpFundingPeriod, 
                                            bool IncludeAllContractsOnSummaryOfFunding, bool AllowNewAmendment, bool? allAmendmentsRequireSigning)>
                    (sql, new { fundingTypeCode, fundingPeriod });

                return new Tuple<string, string, string, bool, bool, bool?>
                    (ftpGroupCode, precedingFtpFundingType, precedingFtpFundingPeriod, includeAllContractsOnSummaryOfFunding, allowNewAmendment, allAmendmentsRequireSigning);
            }
        }
    }
}