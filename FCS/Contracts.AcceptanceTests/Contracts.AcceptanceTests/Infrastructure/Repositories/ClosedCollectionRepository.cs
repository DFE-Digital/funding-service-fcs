namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using AllocationDeliveryDomain.Common.DataStore;
    using Dapper;

    public static class ClosedCollectionRepository
    {
        public static void RemoveAll()
        {
            using (MonitoringDeliverablesDbContext context = new MonitoringDeliverablesDbContext())
            {
                context.Database.Connection.ExecuteScalar<int>("dbo.sp_DynamicClearData @table,@schema,@ReqType", new { Table = "ClosedCollection", Schema = "MonitoringDeliverables", ReqType = "Delete" });

            }
        }
    }
}
