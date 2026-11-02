namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using ADMonitoringDomain.DataStore;
    using Extensions;

    public static class AllocationDeliveryEventReceivedRepository
    {
        public static void ClearDownAllocationDeliveryEventReceivedTableForAllocation(string allocationNumber)
        {
            using (var context = new AllocationDeliveryMonitoringDbContext())
            {
                context.AllocationDeliveryEventsReceived.RemoveWhere(ad =>
                ad.AllocationNumber == allocationNumber);
                context.SaveChanges();
            }
        }
    }
}
