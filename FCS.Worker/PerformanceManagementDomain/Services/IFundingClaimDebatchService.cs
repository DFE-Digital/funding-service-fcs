namespace PerformanceManagementDomain.Services
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim;

    public interface IFundingClaimDebatchService
    {
        Task<IEnumerable<DebatchedFundingClaim>> DebatchFundingClaimByAllocationGroup(FundingClaim fundingClaimToDebatch, ConnectionInfo connectionInfo);
    }
}