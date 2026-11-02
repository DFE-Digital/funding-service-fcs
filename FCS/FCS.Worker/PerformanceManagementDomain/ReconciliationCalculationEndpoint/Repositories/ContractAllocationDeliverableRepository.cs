namespace PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories
{
    using System.Data.Entity;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using System.Linq;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using System.Collections.Generic;
    using System.Threading.Tasks;

    public class ContractAllocationDeliverableRepository : IContractAllocationDeliverableRepository
    {
        public async Task<IReadOnlyCollection<ContractAllocationDeliverable>> FindByAllocationNumber(string contractAllocationNumber, ConnectionInfo connectionInfo)
        {
            using (var context = new PerformanceManagementDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                return await context.ContractAllocationDeliverables.Where(
                    ad => ad.ContractAllocationNumber == contractAllocationNumber).ToListAsync().ConfigureAwait(continueOnCapturedContext: false);
            }
        }

        public async Task StoreContractAllocationDeliverables(IReadOnlyCollection<ContractAllocationDeliverable> contractAllocationDeliverables, ConnectionInfo connectionInfo)
        {
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                await UpSertContractAllocationDeliverables(contractAllocationDeliverables, context)
                    .ConfigureAwait(continueOnCapturedContext: false);

                // now remove any deliverables that are not passed in
                string allocationNumber = contractAllocationDeliverables.FirstOrDefault()?.ContractAllocationNumber;
                if (allocationNumber != null)
                {
                    IReadOnlyCollection<int> newDeliverableCodes =
                        contractAllocationDeliverables.Select(newD => newD.DeliverableCode).ToList();

                    // find deliverables that do not have one of these codes
                    var deliverablesToRemove = await context.ContractAllocationDeliverables.Where(
                            d => d.ContractAllocationNumber == allocationNumber)
                        .Where(
                            existingD =>
                                !newDeliverableCodes
                                    .Contains(existingD.DeliverableCode)).ToListAsync();

                    deliverablesToRemove.ForEach(d => context.ContractAllocationDeliverables.Remove(d));
                }

                await context.SaveChangesAsync().ConfigureAwait(continueOnCapturedContext: false);
            }
        }

        private async Task UpSertContractAllocationDeliverables(
            IReadOnlyCollection<ContractAllocationDeliverable> contractAllocationDeliverables, PerformanceManagementDbContext context)
        {
            foreach (var deliverable in contractAllocationDeliverables)
            {
                var existingDeliverable = await context.ContractAllocationDeliverables.FirstOrDefaultAsync(cad =>
                    cad.ContractAllocationNumber == deliverable.ContractAllocationNumber &&
                    cad.DeliverableCode == deliverable.DeliverableCode).ConfigureAwait(continueOnCapturedContext: false);

                if (existingDeliverable != null)
                {
                    existingDeliverable.PlannedValue = deliverable.PlannedValue;
                }
                else
                {
                    context.ContractAllocationDeliverables.Add(deliverable);
                }
            }
        }
    }
}