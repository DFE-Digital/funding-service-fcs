namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using System.Reflection.Emit;
    using Dapper;
    using ExcelTypes;
    using Operations.DataStore;
    using Operations.DataStore.Model;

    public class OperationsFundingReportFSPWriter
    {
        public static void WriteToPaaSDatabase(IEnumerable<FundingReportFSPSheetType> rows, WriterBehaviour behaviour)
        {
            // any connection string is fine here
            var connectionString = ConfigurationManager.ConnectionStrings["PaymentGenerationDbContext"].ConnectionString;

            (string fspCode, string fundingPeriod) Order(FundingReportFSPSheetType t) => (t.FspCode, t.FundingPeriod);
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                var rowsInDb = GetRowsFromDb(connection).OrderBy(Order);
                rows = rows.OrderBy(Order).ToList();
                if (rows.SequenceEqual(rowsInDb) == false)
                {
                    rows.Where(so => so.PolicyStatus == PolicyStatus.Approved).ToList().ForEach(row =>
                    {
                        if (IsRowPresent(row.FspCode, row.FundingPeriod, connection))
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

        private static void InsertRow(FundingReportFSPSheetType row, SqlConnection connection)
        {
            using (var context = new OperationsDbContext(connection))
            {
                context.FundingReportFSPs.Add(new FundingReportFSP(row.FspCode, row.Order, row.FundingPeriod, row.Description));
                context.SaveChanges();
            }
        }

        private static void UpdateRow(FundingReportFSPSheetType row, SqlConnection connection)
        {
            using (var context = new OperationsDbContext(connection))
            {
                var result = (from res in context.FundingReportFSPs
                              where res.FspCode == row.FspCode && res.FundingPeriod == row.FundingPeriod
                              select res).ToList();
                if (result.Count > 0)
                {
                    foreach (FundingReportFSP frfsp in result)
                    {
                        frfsp.Order = row.Order;
                        frfsp.Description = row.Description;
                    }
                }
                context.SaveChanges();

            }
        }

        private static IReadOnlyCollection<FundingReportFSPSheetType> GetRowsFromDb(SqlConnection connection)
        {
            using (var context = new OperationsDbContext(connection))
            {
                var result = (from res in context.FundingReportFSPs
                              select new FundingReportFSPSheetType
                              {
                                  FspCode = res.FspCode
                              ,
                                  Order = res.Order
                              ,
                                  FundingPeriod = res.FundingPeriod
                              ,
                                  Description = res.Description
                              }).ToList();
                return result;
            }
        }

        private static bool IsRowPresent(string fspCode, string fundingPeriod, SqlConnection connection)
        {
            using (var context = new OperationsDbContext(connection))
            {
                bool result = (from res in context.FundingReportFSPs
                               where res.FspCode == fspCode && res.FundingPeriod == fundingPeriod
                               select res).ToList().Count() == 1;
                return result;
            }
        }
    }
}
