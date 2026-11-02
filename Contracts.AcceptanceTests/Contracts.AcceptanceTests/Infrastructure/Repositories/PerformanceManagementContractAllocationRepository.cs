namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System.Data.Entity;
    using System.Linq;
    using Extensions;
    using PerformanceManagementDomain.DataStore;
    using PerformanceManagementDomain.DataStore.Models.Allocation;

    public static class PerformanceManagementContractAllocationRepository
    {
        public static ContractAllocation Find(string allocationRef)
        {
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                return context.ContractAllocations
                    .Include(ca => ca.ContractAllocationDeliverables)
                    .SingleOrDefault(ca => ca.AllocationNumber == allocationRef);
            }
        }

        public static void DeleteByUkprn(int ukprn)
        {
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                context.ContractAllocations.RemoveWhere(ca => ca.Contractor.UKPRN == ukprn);
                context.SaveChanges();
            }
        }

        public static void UpsertAllocation(ContractAllocation contractAllocation)
        {
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                var allocationInDb = context.ContractAllocations.Find(contractAllocation.AllocationNumber);
                if (allocationInDb == null)
                {
                    context.ContractAllocations.Add(contractAllocation);

                    context.SaveChanges();
                }
            }
        }
    }
}
