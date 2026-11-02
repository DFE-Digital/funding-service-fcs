namespace FctServices.Deds
{
    using System.Collections.Generic;
    using Entities;

    public interface IFundingClaimRepository
    {
        List<FundingClaim> GetRows(int pageNumber, int pageSize, string period, string claimType);

        int GetTotal(string period, string claimType);

        List<string> GetCompletedClaimTypePeriods();
    }
}
