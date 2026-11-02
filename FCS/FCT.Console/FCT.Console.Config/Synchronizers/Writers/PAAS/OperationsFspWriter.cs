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

    public class OperationsFspWriter
    {
        public static void WriteToPaaSDatabase(IEnumerable<FundingStreamPeriodSheetType> rows, WriterBehaviour behaviour)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["PaymentGenerationDbContext"].ConnectionString;

            if (behaviour == WriterBehaviour.AddOrUpdate)
            {
                string Order(OperationsFsp t) => t.FspCode;
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    var rowsInDb = GetRowsFromDb(connection).OrderBy(Order).ToList();
                    var operationsFspRows = rows.Where(r => r.PolicyStatus == PolicyStatus.Approved)
                        .Select(r => new OperationsFsp(r.FundingStreamPeriodCode, r.PeriodTypeCode))
                        .OrderBy(Order).ToList();

                    if (operationsFspRows.SequenceEqual(rowsInDb) == false)
                    {
                        operationsFspRows.ForEach(row =>
                        {
                            if (IsRowPresent(row.FspCode, connection))
                            {
                                UpdateRow(row.FspCode, row.PeriodTypeCode, connection);
                            }
                            else
                            {
                                InsertRow(row.FspCode, row.PeriodTypeCode, connection);
                            }
                        });
                    }
                }
            }
            else
            {
                var operationsFspRows = rows.Where(r => r.PolicyStatus == PolicyStatus.Removed)
                    .Select(r => new OperationsFsp(r.FundingStreamPeriodCode, r.PeriodTypeCode))
                    .ToList();
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    operationsFspRows.ForEach(r =>
                    {
                        if (IsRowPresent(r.FspCode, connection))
                        {
                            DeleteRow(r.FspCode, connection);
                        }
                    });
                }
            }
            
        }

        private static void InsertRow(string fspCode, string periodTypeCode, SqlConnection connection)
        {           

            using (var context = new OperationsDbContext(connection))
            {
                context.FundingStreamPeriods.Add(new FundingStreamPeriod(fspCode, periodTypeCode));
                context.SaveChanges();
            }

        }

        private static void DeleteRow(string fspCode, SqlConnection connection)
        {          
            using (var context = new OperationsDbContext(connection))
            {
                context.FundingStreamPeriods.Where(fsp => fsp.FundingStreamPeriodCode == fspCode).ToList().ForEach(r => context.FundingStreamPeriods.Remove(r));
                context.SaveChanges();
            }
        }

        private static void UpdateRow(string fspCode, string periodTypeCode, SqlConnection connection)
        {
            using (var context = new OperationsDbContext(connection))
            {
                var result = (from res in context.FundingStreamPeriods
                              where res.FundingStreamPeriodCode == fspCode
                              select res).ToList();
                if (result.Count > 0)
                {
                    foreach (FundingStreamPeriod fsp in result)
                    {
                        fsp.PeriodTypeCode = periodTypeCode;
                    }
                }
                context.SaveChanges();

            }
        }

        private static IReadOnlyCollection<OperationsFsp> GetRowsFromDb(SqlConnection connection)
        {
            using (var context = new OperationsDbContext(connection))
            {
                var result = (from res in context.FundingStreamPeriods
                              select new OperationsFsp
                              {
                                  FspCode = res.FundingStreamPeriodCode
                              ,
                                  PeriodTypeCode = res.PeriodTypeCode
                              }).ToList();
                return result;
            }
        }

        private static bool IsRowPresent(string fspCode, SqlConnection connection)
        {
            using (var context = new OperationsDbContext(connection))
            {
                bool result = (from res in context.FundingStreamPeriods
                               where res.FundingStreamPeriodCode == fspCode
                               select res).ToList().Count() == 1;
                return result;
            }
        }

        private class OperationsFsp
        {
            public OperationsFsp()
            {

            }
            public OperationsFsp(string fspCode, string periodTypeCode)
            {
                FspCode = fspCode;
                PeriodTypeCode = periodTypeCode;
            }

            public string FspCode { get; set; }
            public string PeriodTypeCode { get; set; }

            public override bool Equals(object obj)
            {
                if (obj is OperationsFsp other)
                {
                    return FspCode == other.FspCode &&
                           PeriodTypeCode == other.PeriodTypeCode;
                }

                return false;
            }

            public override int GetHashCode()
            {
                return FspCode.GetHashCode() ^ PeriodTypeCode.GetHashCode();
            }
        }
    }
}
