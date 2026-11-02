namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System.Collections.Generic;
    using System.Linq;
    using AllocationDeliveryDomain.Common.DataStore;
    using AllocationDeliveryDomain.Common.DataStore.Model;

    public static class ActualsAuditRepository
    {
        public static IReadOnlyCollection<AllocationDeliverablePeriodActualAudit> GetActualAuditsForAllocation(string allocationNumber)
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                return context.AllocationDeliverablePeriodActualAudits
                    .Where(a => a.ContractAllocationNumber == allocationNumber)
                    .ToList();
            }
        }
    }
}
