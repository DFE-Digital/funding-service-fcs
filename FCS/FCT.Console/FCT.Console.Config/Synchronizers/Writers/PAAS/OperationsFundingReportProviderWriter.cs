namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using Dapper;
    using ExcelTypes;
    using Operations.DataStore;
    using Operations.DataStore.Model;

    public class OperationsFundingReportProviderWriter
    {
        public static void WriteToPaaSDatabase(IEnumerable<FundingReportProviderSheetType> rows, WriterBehaviour behaviour)
        {
            // any connection string is fine here
            var connectionString = ConfigurationManager.ConnectionStrings["PaymentGenerationDbContext"].ConnectionString;

            int Order(FundingReportProviderSheetType t) => t.Ukprn;
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

        private static void InsertRow(FundingReportProviderSheetType row, SqlConnection connection)
        {
            using (var context = new OperationsDbContext(connection))
            {
                context.FundingReportProviders.Add(new FundingReportProvider(row.Ukprn, row.FundingPeriod, row.Type, row.Period));
                context.SaveChanges();
            }
        }

        private static void UpdateRow(FundingReportProviderSheetType row, SqlConnection connection)
        {
            using (var context = new OperationsDbContext(connection))
            {
                var result = (from res in context.FundingReportProviders
                              where res.Ukprn == row.Ukprn && res.FundingPeriod == row.FundingPeriod
                              select res).ToList();
                if (result.Count > 0)
                {
                    foreach (FundingReportProvider frp in result)
                    {
                        frp.Type = row.Type;
                        frp.Period = row.Period;
                    }
                }
                context.SaveChanges();

            }
        }

        private static IReadOnlyCollection<FundingReportProviderSheetType> GetRowsFromDb(SqlConnection connection)
        {
            using (var context = new OperationsDbContext(connection))
            {
                var result = (from res in context.FundingReportProviders
                              select new FundingReportProviderSheetType
                              {
                                  Ukprn = res.Ukprn
                              ,
                                  FundingPeriod = res.FundingPeriod
                              ,
                                  Type = res.Type
                              ,
                                  Period = res.Period
                              }).ToList();
                return result;
            }
        }

        private static bool IsRowPresent(int ukprn, string fundingPeriod, SqlConnection connection)
        {
            using (var context = new OperationsDbContext(connection))
            {
                bool result = (from res in context.FundingReportProviders
                               where res.Ukprn == ukprn && res.FundingPeriod == fundingPeriod
                               select res).ToList().Count() == 1;
                return result;
            }
        }
    }
}
