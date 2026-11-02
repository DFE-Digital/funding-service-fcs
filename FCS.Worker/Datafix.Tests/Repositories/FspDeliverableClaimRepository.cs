namespace Datafix.Tests.Repositories
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using Dapper;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;

    public static class FspDeliverableClaimRepository
    {
        public static IReadOnlyCollection<FspDeliverableClaim> GetAllRowsInDb()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
            const string sql = @" select * from [PerformanceManagement].[FspDeliverableClaim]";

            using (var connection = new SqlConnection(connectionString))
            {
                return connection.Query<FspDeliverableClaim>(sql).ToList();
            }
        }

        public static IReadOnlyCollection<ClaimReconciliationDeliverableGroup> GetAllClaimReconciliationDeliverableGroupRowsInDb()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
            const string sql = @" select * from [PerformanceManagement].[ClaimReconciliationDeliverableGroup]";

            using (var connection = new SqlConnection(connectionString))
            {
                return connection.Query<ClaimReconciliationDeliverableGroup>(sql).ToList();
            }
        }
    }
}
