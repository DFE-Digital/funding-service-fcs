namespace SFA.FCT.PerformanceManagementDomain.DataStore.Repositories
{
    using Models;

    public interface IClaimReconciliationAllocationGroupRepository
    {
        ClaimReconciliationAllocationGroup Find(string allocationGroupCode);
    }
}
