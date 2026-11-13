namespace ADMonitoringDomain.Endpoint.Repositories
{
    extern alias Entities;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class AllocationDeliverablePeriodActualAuditRepository : IAllocationDeliverablePeriodActualAuditRepository
    {
        public IReadOnlyCollection<AllocationDeliverablePeriodActualAudit> GetLatestCollectionReturn(string allocationNumber, ConnectionInfo connectionInfo)
        {
            using (var context = new MonitoringDeliverablesDbContext(connectionInfo))
            {
                IReadOnlyCollection<AllocationDeliverablePeriodActualAudit> lastCollectionReturnActuals =
                    context.AllocationDeliverablePeriodActualAudits
                        .Where(aa => aa.ContractAllocationNumber == allocationNumber)
                        .GroupBy(aa => aa.CollectionReturnPeriod)
                        .OrderByDescending(grp => grp.Key)
                        .Take(1)
                        .SelectMany(grp => grp.ToList())
                        .ToList();

                DateTime? terminationDate =
                    context.AllocationsUnderTermination
                        .SingleOrDefault(a => a.ContractAllocationNumber == allocationNumber)
                        ?.TerminationDate;

                if (terminationDate.HasValue)
                {
                    lastCollectionReturnActuals = lastCollectionReturnActuals
                        .Where(aa => IsPeriodPriorToTermination(aa.Period, terminationDate.Value))
                        .ToList();
                }

                return lastCollectionReturnActuals;
            }
        }

        private static bool IsPeriodPriorToTermination(string period, DateTime terminationDate)
        {
            int actualPeriod = int.Parse(period);
            int terminationPeriod = int.Parse(terminationDate.ToString("yyyyMM"));

            return actualPeriod <= terminationPeriod;
        }
    }
}
