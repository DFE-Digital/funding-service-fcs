namespace SFA.FCT.PerformanceManagementDomain.FundingClaimImportEndpoint.Services
{
    public interface IFundingClaimAllocationFilter
    {
        void RemoveInvalidAllocations(CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim.CorporateSchema._3_0.FundingClaim fundingClaim);
    }
}