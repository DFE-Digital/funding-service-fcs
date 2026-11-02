namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using Dapper;
    using System.Configuration;
    using System.Data.SqlClient;
    using Operations.DataStore;

    public class DuplicateContractRepository
    {
        public static bool ThereAreNoDuplicates()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["OperationsDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sql = @"SELECT COUNT(1) FROM [Operations].[DuplicateContract] 
                                      where ContractNumber like '%-110'";

                return connection.ExecuteScalar<int>(sql) == 0;
            }
        }

        public static bool DuplicateContractExists(string contractNumber, int version, int subVersion)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["OperationsDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sql = @"SELECT COUNT(1) FROM [Operations].[DuplicateContract]
                                    WHERE   ContractNumber = @ContractNumber
                                    AND     Version = @Version
                                    AND     SubVersion = @SubVersion";

                return connection.ExecuteScalar<int>(sql, new { contractNumber, version, subVersion }) == 1;
            }
        }

        public static void ClearDownDuplicateContractTable()
        {
            using (var context = new OperationsDbContext())
            {
                context.Database.Connection.ExecuteScalar<int>("dbo.sp_DynamicClearData @table,@schema,@ReqType", new { Table = "DuplicateContract", Schema = "Operations", ReqType = "Delete" });
            }
        }
    }
}