namespace SFA.FCT.PerformanceManagementDomain.DataStore.Repositories
{
    using System.Collections.Generic;
    using Models;
    using DtoFundingClaim = CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim.FundingClaim;

    public interface IFundingClaimRepository
    {
        DtoFundingClaim GetFundingClaimByNaturalKey(FundingClaimNaturalKey naturalKey);

        List<DtoFundingClaim> RetrieveAllFundingClaimsForPeriodAndClaimType(string period, string claimTypeName);

        void AddFundingClaims(List<FundingClaim> dataStoreFundingClaims);

        int GetCountOfFundingClaimsForCollection(string period, string claimTypeName);
    }
}
