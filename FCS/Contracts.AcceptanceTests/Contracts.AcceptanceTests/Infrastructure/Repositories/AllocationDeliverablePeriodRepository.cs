namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using AllocationDeliveryDomain.Common.DataStore;
    using Extensions;

    public static class AllocationDeliverablePeriodRepository
    {
        public static void DeleteAllocationDeliverablePeriods(string allocationNumber, int deliverableCode)
        {
            using (MonitoringDeliverablesDbContext context = new MonitoringDeliverablesDbContext())
            {
                context.AllocationDeliverablePeriods.RemoveWhere(adp =>
                    adp.ContractAllocationNumber == allocationNumber && adp.DeliverableCode == deliverableCode);
                context.SaveChanges();
            }
        }
    }
}