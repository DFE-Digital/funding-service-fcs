namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using Dapper;
    using ExcelTypes;

    public class OperationsLaFundingReportProviderWriter
    {
        public static void WriteToPaaSDatabase(IEnumerable<LaFundingReportProviderSheetType> rows, WriterBehaviour behaviour)
        {
            // any connection string is fine here
            var connectionString = ConfigurationManager.ConnectionStrings["PaymentGenerationDbContext"].ConnectionString;

            int Order(LaFundingReportProviderSheetType t) => t.Ukprn;
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                var rowsInDb = GetRowsFromDb(connection).OrderBy(Order).ToList();
                rows = rows.OrderBy(Order).ToList();
                if (rows.SequenceEqual(rowsInDb) == false)
                {
                    rows.Where(so => so.PolicyStatus == PolicyStatus.Approved).ToList().ForEach(row =>
                    {
                        if (IsRowPresent(row.Ukprn, row.FundingPeriod, connection))
                        {
                            UpdateRow(row, connection);
                        }
                        else
                        {
                            InsertRow(row, connection);
                        }
                    });
                }
            }
        }

        private static void InsertRow(LaFundingReportProviderSheetType row, SqlConnection connection)
        {
            const string sql = @"insert into [Operations].[LaFundingReportProvider]
                                    ([Ukprn]
                                    ,[FundingPeriod]
                                    ,[Type]
                                    ,[Period])
                                values(@Ukprn, @FundingPeriod, @Type, @Period)";

            connection.Execute(sql, row);
        }

        private static void UpdateRow(LaFundingReportProviderSheetType row, SqlConnection connection)
        {
            const string sql = @"update [Operations].[LaFundingReportProvider] set 
                                    [Type] = @Type,
                                    [Period] = @Period
                                where
                                    [Ukprn] = @Ukprn
                                and [FundingPeriod] = @FundingPeriod";

            connection.Execute(sql, row);
        }

        private static IReadOnlyCollection<LaFundingReportProviderSheetType> GetRowsFromDb(SqlConnection connection)
        {
            const string sql = @"select [Ukprn]
                                       ,[FundingPeriod]
                                       ,[Type]
                                       ,[Period]
                                from [Operations].[LaFundingReportProvider]";

            return connection.Query<LaFundingReportProviderSheetType>(sql).ToList();
        }

        private static bool IsRowPresent(int ukprn, string fundingPeriod, SqlConnection connection)
        {
            const string sql = @"select count(1) 
                                 from [Operations].[LaFundingReportProvider]
                                 where [Ukprn] = @ukprn
                                 and [FundingPeriod] = @fundingPeriod";

            return connection.ExecuteScalar<int>(sql, new { ukprn, fundingPeriod }) == 1;
        }
    }
}
