namespace Datafix.Tests.Repositories
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using Infrastructure;

    public static class OrganisationRepository
    {
        public static void UpdateOrgName(int ukprn, string name)
        {
            string connectionString =
                ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnectionWithRetry(connectionString))
            {
                const string sql = @"update [Organisation].[Organisation]
                set TradingName = @name
                where Ukprn = @ukprn";

                connection.Execute(sql, param: new
                {
                   ukprn,
                   name
                });
            }
        }

        public static IReadOnlyCollection<int> GetUkprnsInOrgTable()
        {
            string connectionString =
                ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnectionWithRetry(connectionString))
            {
                const string sql = @"select Ukprn from [Organisation].[Organisation]";

                return connection.Query<int>(sql).ToList();
            }
        }
    }
}
