namespace SFA.FCT.PerformanceManagementDomain.FundingClaimImportEndpoint.Services
{
    using System.Collections.Generic;
    using CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim;

    public interface IFundingClaimDebatchService
    {
        IEnumerable<DebatchedFundingClaim> DebatchFundingClaimByAllocationGroup(FundingClaim fundingClaimToDebatch);
    }
}
