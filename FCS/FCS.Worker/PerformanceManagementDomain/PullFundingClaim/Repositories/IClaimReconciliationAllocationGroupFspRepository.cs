namespace PerformanceManagementDomain.PullFundingClaim.Repositories
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IClaimReconciliationAllocationGroupFspRepository
    {
        Task<IReadOnlyCollection<string>> GetValidFundingStreamPeriodCodes(ConnectionInfo connectionInfo);
    }
}
