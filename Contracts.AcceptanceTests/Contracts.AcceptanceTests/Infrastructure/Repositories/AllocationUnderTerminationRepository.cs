namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System.Linq;
    using MoreLinq;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;

    public static class AllocationUnderTerminationRepository
    {
        public static void DeleteAllocation(string allocationNumber)
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                context.AllocationsUnderTermination.Where(a => a.ContractAllocationNumber == allocationNumber)
                    .ForEach(a => context.AllocationsUnderTermination.Remove(a));

                context.SaveChanges();
            }
        }
    }
}
