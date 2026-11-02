namespace Datafix.Tests.Repositories
{
    using System.Configuration;
    using System.Data.SqlClient;
    using Dapper;

    public class AllocationDeliverablePeriodRepository
    {
        public static void RemoveRowsForAllocation(
            string allocationNumber)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
            const string sql = @" Delete from [MonitoringDeliverables].[AllocationDeliverablePeriod]
                                where [ContractAllocationNumber] = @allocationNumber";

            using (var connection = new SqlConnection(connectionString))
            {
                connection.Execute(sql,
                    new { allocationNumber});
            }
        }
    }
}
