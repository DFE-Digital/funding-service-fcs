namespace SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class AllocationUnderTerminationRepository : IAllocationUnderTerminationRepository
    {
        public async Task AddRange(IReadOnlyCollection<AllocationUnderTermination> allocationUnderTerminations, ConnectionInfo connectionInfo)
        {
            using (var context = new MonitoringDeliverablesDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                context.AllocationsUnderTermination.AddRange(allocationUnderTerminations);

                await context.SaveChangesAsync().ConfigureAwait(continueOnCapturedContext: false);
            }
        }

        public async Task RemoveAllocationUnderTerminationsForContract(string contractNumber, ConnectionInfo connectionInfo)
        {
            using (var context = new MonitoringDeliverablesDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                context.AllocationsUnderTermination.RemoveRange(
                    context.AllocationsUnderTermination.Where(a => a.ContractNumber == contractNumber)
                );

                await context.SaveChangesAsync().ConfigureAwait(continueOnCapturedContext: false);
            }
        }
    }
}
