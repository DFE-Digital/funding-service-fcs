namespace PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories
{
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Linq;
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models.Allocation;
    using AutoMapper;
    using DTOs;

    public class ContractAllocationRepository : IContractAllocationRepository
    {
        public async Task<ContractAllocation> Find(string allocationNumber, ConnectionInfo connectionInfo)
        {
            using (var context = new PerformanceManagementDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                return await context.ContractAllocations
                    .FirstOrDefaultAsync(ca => ca.AllocationNumber == allocationNumber)
                    .ConfigureAwait(continueOnCapturedContext: false);
            }
        }

        public async Task<IReadOnlyCollection<AllocationInfo>> GetAllocationsWithPlannedValue(IReadOnlyCollection<string> allocationNumbers, ConnectionInfo connectionInfo)
        {
            using (var context = new PerformanceManagementDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                var contractAllocations = await context.ContractAllocations.Include(ca => ca.ContractAllocationDeliverables)
                    .Where(ca => allocationNumbers.Contains(ca.AllocationNumber)).ToListAsync();

                return contractAllocations.Select(ca => new AllocationInfo(ca.AllocationNumber, ca.ContractAllocationDeliverables.Sum(d => d.PlannedValue))).ToList();
            }
        }

        public async Task AddOrUpdateAllocation(ContractAllocation contractAllocation, ConnectionInfo connectionInfo)
        {
            using (var context = new PerformanceManagementDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                var dbContractAllocation = await context.ContractAllocations
                    .FirstOrDefaultAsync(ca => ca.AllocationNumber == contractAllocation.AllocationNumber)
                    .ConfigureAwait(continueOnCapturedContext: false);

                if (dbContractAllocation == null)
                {
                    context.ContractAllocations.Add(contractAllocation);
                }
                else
                {
                    Mapper.CreateMap<ContractAllocation, ContractAllocation>();
                    Mapper.Map(contractAllocation,dbContractAllocation);
                }

                await context.SaveChangesAsync().ConfigureAwait(continueOnCapturedContext: false);
            }
        }
    }
}