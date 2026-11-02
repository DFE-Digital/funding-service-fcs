namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System.Configuration;
    using System.Data.SqlClient;
    using Dapper;

    public class FundingAllocationReleaseGroupRepository
    {
        public static int GetNextReleaseGroupGroupId()
        {
            var connectionString = ConfigurationManager.ConnectionStrings["PerformanceManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sql = "SELECT NEXT VALUE FOR [FundingAllocation].[ReleaseGroupGroupId_seq]";

                return connection.ExecuteScalar<int>(sql);
            }
        }
    }
}