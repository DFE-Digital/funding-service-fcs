namespace PerformanceManagement.IntegrationTests.PageObjects
{
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models.Allocation;

    public class PerformanceManagementPageObject
    {
        public void CreateContractAllocationInStorage(ContractAllocation contractAllocation)
        {
            using (var context = new PerformanceManagementDbContext())
            {
                context.ContractAllocations.Add(contractAllocation);
                context.SaveChanges();
            }
        }

        public void DeleteAllocationFromPaaS(string allocationNumber)
        {
            using (var context = new PerformanceManagementDbContext())
            {
                var allocationToDelete = context.ContractAllocations.Find(allocationNumber);

                if (allocationToDelete != null)
                {
                    context.ContractAllocations.Remove(allocationToDelete);
                    context.SaveChanges();
                }
            }
        }

        public void DeleteAllAllocationsFromPaaS()
        {
            using (var context = new PerformanceManagementDbContext())
            { 
                context.Database.CommandTimeout = 300;
                context.Database.ExecuteSqlCommand("Delete from [PerformanceManagement].[ContractAllocation]");
            }
        }
    }
}
