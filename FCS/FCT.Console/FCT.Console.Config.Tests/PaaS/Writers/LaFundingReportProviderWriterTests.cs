namespace FCT.Console.Config.Tests.PaaS.Writers
{
    using Dapper;
    using ExcelTypes;
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PaymentGenerationDomain.Integration.DataStore;
    using Synchronizers.Writers;
    using Synchronizers.Writers.PAAS;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;

    [TestClass]
    public class LaFundingReportProviderWriterTests
    {
        private static readonly string connectionString = PaymentGenerationDbContext.KeyVaultValue;

        [TestMethod, TestCategory("IntegrationTest")]
        public void LaFundingReportProviderWriter_ShouldUpdate()
        {
            // arrange
            const int ukprn = 12345555;
            const string fundingPeriod = "AY2021";
            const string originalType = "T1";
            const string newType = "T2";
            const int newPeriod = 2122;
            RemoveRowsForUkprn(ukprn);
            InsertRow(ukprn, fundingPeriod, originalType, 2021);

            IReadOnlyCollection<LaFundingReportProviderSheetType> sheetTypes = new List<LaFundingReportProviderSheetType>
            {
                new LaFundingReportProviderSheetType
                {
                    Type = newType,
                    FundingPeriod = fundingPeriod,
                    Period = newPeriod,
                    PolicyStatus = PolicyStatus.Approved,
                    Ukprn = ukprn
                }
            };

            // act
            OperationsLaFundingReportProviderWriter.WriteToPaaSDatabase(sheetTypes, WriterBehaviour.AddOrUpdate);
            
            // assert
            var rowsInDb = GetRowsForUkprn(ukprn);
            rowsInDb.Count.Should().Be(1);
            Assert.AreEqual(newType, rowsInDb.Single().Type);
            Assert.AreEqual(newPeriod, rowsInDb.Single().Period);
        }

        private static void InsertRow(int ukprn, string fundingPeriod, string type, int period )
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                const string sql = @"insert into [Operations].[LaFundingReportProvider]
                                    ([Ukprn]
                                    ,[FundingPeriod]
                                    ,[Type]
                                    ,[Period])
                                values(@Ukprn, @FundingPeriod, @Type, @Period)";

                connection.Execute(sql, new {ukprn, fundingPeriod, type, period});
            }
        }

        private static void RemoveRowsForUkprn(int ukprn)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Execute(
                    "Delete from [Operations].[LaFundingReportProvider] where [Ukprn] = @ukprn", new { ukprn });
            }
        }

        private static IReadOnlyCollection<dynamic> GetRowsForUkprn(int ukprn)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                return connection.Query(
                    "Select * from [Operations].[LaFundingReportProvider] where [Ukprn] = @ukprn", new { ukprn }).ToList();
            }
        }
    }
}
