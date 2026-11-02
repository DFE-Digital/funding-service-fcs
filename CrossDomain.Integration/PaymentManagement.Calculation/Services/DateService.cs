namespace PaymentManagement.Calculation.Services
{
    using Dapper;
    using System;
    using System.Configuration;
    using System.Data.SqlClient;

    public class DateService : IDateService
    {
        public DateTime GetCurrentDate()
        {
            var useRealDate = bool.Parse(ConfigurationManager.AppSettings["UseRealDate"]);

            return useRealDate ? DateTime.UtcNow : DateTime.SpecifyKind(GetOverrideDate() ?? DateTime.UtcNow, DateTimeKind.Utc);
        }

        private static DateTime? GetOverrideDate()
        {
            var connectionString = ConfigurationManager.ConnectionStrings["PaymentManagementPolicyContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sqlQuery = @"SELECT SystemOverrideDate FROM OverrideDate.OverrideDate";

                return connection.ExecuteScalar<DateTime?>(sqlQuery);
            }
        }
    }
}