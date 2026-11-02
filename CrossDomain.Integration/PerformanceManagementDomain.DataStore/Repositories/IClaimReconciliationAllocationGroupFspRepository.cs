namespace SFA.FCT.PerformanceManagementDomain.DataStore.Repositories
{
    using Models;

    public interface IClaimReconciliationAllocationGroupFspRepository
    {
        ClaimReconciliationAllocationGroupFsp GetClaimAllocationGroupForFundingStreamPeriod(string fundingStreamPeriod);
        bool IsFundingStreamPeriodValid(string fundingStreamPeriod);
    }
}
