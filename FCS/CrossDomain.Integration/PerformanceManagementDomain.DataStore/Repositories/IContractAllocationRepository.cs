namespace SFA.FCT.PerformanceManagementDomain.DataStore.Repositories
{
    using Models.Allocation;

    public interface IContractAllocationRepository
    {
        ContractAllocation Find(string allocationNumber);

        void AddEntity(ContractAllocation entity);

        void AddOrUpdateEntity(ContractAllocation entity);

        int SaveChanges();

        decimal? GetPlannedValueForAllocation(string allocationNumber);
    }
}
