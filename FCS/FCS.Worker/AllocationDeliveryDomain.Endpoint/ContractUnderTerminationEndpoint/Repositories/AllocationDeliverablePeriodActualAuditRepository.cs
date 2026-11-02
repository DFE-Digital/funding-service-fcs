namespace AllocationDeliveryDomain.Endpoint.ContractUnderTerminationEndpoint.Repositories
{
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Linq;
    using System.Threading.Tasks;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class AllocationDeliverablePeriodActualAuditRepository: IAllocationDeliverablePeriodActualAuditRepository
    {
        public async Task<IReadOnlyCollection<AllocationDeliverablePeriodActualAudit>> GetLatestCollectionReturn(ConnectionInfo connectionInfo, string allocationNumber)
        {
            using (MonitoringDeliverablesDbContext context = new MonitoringDeliverablesDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                IReadOnlyCollection<AllocationDeliverablePeriodActualAudit> lastCollectionReturnActuals =
                    await context.AllocationDeliverablePeriodActualAudits
                            .Where(aa => aa.ContractAllocationNumber == allocationNumber)
                            .GroupBy(aa => aa.CollectionReturnPeriod)
                            .OrderByDescending(grp => grp.Key)
                            .Take(1)
                            .SelectMany(grp => grp.ToList())
                            .ToListAsync();

                return lastCollectionReturnActuals;
            }
        }
    }
}