namespace AllocationDeliveryDomain.Endpoint.Repositories
{
    using System;
    using System.Collections.Concurrent;
    using System.Linq;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class AllocationsUnderTerminationQueryRepository : IAllocationsUnderTerminationQueryRepository
    {
        private readonly ConcurrentDictionary<string, AllocationUnderTermination> _entities = new ConcurrentDictionary<string, AllocationUnderTermination>();

        public DateTime? GetTerminationDate(string allocationNumber, ConnectionInfo connectionInfo)
        {
            AllocationUnderTermination allocationUnderTermination = _entities.GetOrAdd(allocationNumber, _ => GetEntityFromDatabase(allocationNumber, connectionInfo));

            return allocationUnderTermination?.TerminationDate;
        }

        private AllocationUnderTermination GetEntityFromDatabase(string allocationNumber, ConnectionInfo connectionInfo)
        {
            using (var context = new MonitoringDeliverablesDbContext(connectionInfo))
            {
                return context.AllocationsUnderTermination
                    .SingleOrDefault(a => a.ContractAllocationNumber == allocationNumber);
            }
        }
    }
}