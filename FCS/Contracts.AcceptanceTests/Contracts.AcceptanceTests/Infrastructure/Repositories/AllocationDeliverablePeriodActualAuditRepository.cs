namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using AllocationDeliveryDomain.Common.DataStore;
    using Extensions;

    public static class AllocationDeliverablePeriodActualAuditRepository
    {
        public static void DeleteAllocationDeliverablePeriodActualAudits(int ukprn)
        {
            using (MonitoringDeliverablesDbContext context = new MonitoringDeliverablesDbContext())
            {
                context.AllocationDeliverablePeriodActualAudits.RemoveWhere(a =>
                    a.Ukprn == ukprn.ToString());
                context.SaveChanges();
            }
        }
    }
}
