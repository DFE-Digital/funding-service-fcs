namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System.Collections.Generic;
    using System.Linq;
    using AllocationDeliveryDomain.Common.DataStore;
    using AllocationDeliveryDomain.Common.DataStore.Model;
    using Dapper;

    public static class SummarisedActualRepository
    {
        public static void RemoveAll()
        {
            using (MonitoringDeliverablesDbContext context = new MonitoringDeliverablesDbContext())
            {
                context.Database.Connection.ExecuteScalar<int>("dbo.sp_DynamicClearData @table,@schema,@ReqType", new { Table = "SummarisedActual", Schema = "MonitoringDeliverables", ReqType = "Delete" });

            }
        }

        public static IReadOnlyCollection<SummarisedActual> GetAll()
        {
            using (MonitoringDeliverablesDbContext context = new MonitoringDeliverablesDbContext())
            {
                return context.SummarisedActuals.ToList();
            }
        }
    }
}