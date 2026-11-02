namespace Datafix.Tests.Repositories
{
    using System;
    using System.Configuration;
    using System.Data.SqlClient;
    using Dapper;

    public static class AllocationDeliverablePeriodActualAuditRepository
    {
        public static void UpdateCollectionReturnPeriod(string collectionReturnCode, int collectionReturnPeriod)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
            const string sql = @"update [MonitoringDeliverables].[AllocationDeliverablePeriodActualAudit]
                                 set CollectionReturnPeriod = @collectionReturnPeriod
                                 where CollectionReturnCode = @collectionReturnCode";

            using (var connection = new SqlConnection(connectionString))
            {
                connection.Execute(sql, new { collectionReturnCode, collectionReturnPeriod }, commandTimeout:(int)TimeSpan.FromMinutes(10).TotalSeconds);
            }
        }
    }
}
