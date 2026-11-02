namespace Datafix.Tests.Repositories
{
    using System;
    using System.Configuration;
    using System.Data.SqlClient;
    using Dapper;
    using Dtos;
    using Infrastructure;

    public static class CreatedContractRepository
    {
        public static void InsertCreatedContract(ContractInfo contract)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnectionWithRetry(connectionString))
            {
                const string sql = @"INSERT INTO ContractManagement.CreatedContract VALUES (@contractNumber, @version, @subVersion, @createdDate, @amendmentType)";

                connection.Execute(sql, param: contract);
            }
        }

        public static void ClearCreatedContractTable()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnectionWithRetry(connectionString))
            {
                connection.Execute(@"TRUNCATE TABLE ContractManagement.CreatedContract");
            }
        }

        public static DateTime GetLatestCreatedDate(string contractNumber)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
            const string sql = @"select max(createdDate) from [ContractManagement].[CreatedContract]
  where ContractNumber = @contractNumber";

            using (var connection = new SqlConnection(connectionString))
            {
                return connection.ExecuteScalar<DateTime>(sql,
                    new { contractNumber });
            }
        }
    }
}
