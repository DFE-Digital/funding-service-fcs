namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System.Data.Entity;
    using System.Linq;
    using Castle.Core.Internal;
    using PerformanceManagementDomain.DataStore;

    public static class FundingClaimRepository
    {
        public static bool IsFundingClaimAllocationPresent(int ukprn, string period, string claimType, string allocationNumber)
        {
            using (var context = new PerformanceManagementDbContext())
            {
                var matchingFundingClaim = context.FundingClaims
                    .Where(fc => fc.Ukprn == ukprn && fc.Period == period && fc.ClaimTypeName == claimType)
                    .Include(fc => fc.Allocations).FirstOrDefault();

                return matchingFundingClaim != null &&
                       matchingFundingClaim.Allocations.Any(a => a.ContractAllocationNumber == allocationNumber);
            }
        }

        public static int GetFundingClaimCountForCollection(string period, string claimTypeName)
        {
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                return context.FundingClaims.Count(fc => fc.Period == period && fc.ClaimTypeName == claimTypeName);
            }
        }

        public static void RemoveAllRowsFromFundingClaimTable()
        {
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                context.FundingClaims.ToList().ForEach(fc => context.FundingClaims.Remove(fc));

                context.SaveChanges();
            }
        }
    }
}
