namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System.Linq;
    using MoreLinq;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;

    public static class InvalidAllocationRepository
    {
        public static void DeleteInvalidAllocation(string allocationNumber)
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                context.InactiveAllocations.Where(a => a.ContractAllocationNumber == allocationNumber)
                    .ForEach(a => context.InactiveAllocations.Remove(a));

                context.SaveChanges();
            }
        }

        public static void DeleteAllInvalidAllocations()
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                context.InactiveAllocations
                    .ForEach(a => context.InactiveAllocations.Remove(a));

                context.SaveChanges();
            }
        }
    }
}
