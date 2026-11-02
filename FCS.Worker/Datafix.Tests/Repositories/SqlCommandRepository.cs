namespace Datafix.Tests.Repositories
{
    using System.Configuration;
    using System.Data.SqlClient;
    using Dapper;

    public static class SqlCommandRepository
    {
        public static void ExecuteSql(string sql, object parameters = null)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                connection.Execute(sql: sql, param: parameters);
            }
        }
    }
}
