namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System.Linq;
    using Extensions;
    using PerformanceManagementDomain.DataStore.Models;
    using PerformanceManagementDomain.DataStore;

    public class ClaimReconciliationReferenceDataReconProfilingRepository
    {
        public static void Add(int ukprn, string fundingPeriod)
        {
            using (var context = new PerformanceManagementDbContext())
            {
                var existingProfile = context.ClaimReconciliationReferenceDataReconProfilings.SingleOrDefault(crrdrp =>
                    crrdrp.Ukprn == ukprn && crrdrp.FundingPeriod == fundingPeriod);

                if (existingProfile == null)
                {
                    context.ClaimReconciliationReferenceDataReconProfilings.Add(new ClaimReconciliationReferenceDataReconProfiling(fundingPeriod, ukprn));
                }

                context.SaveChanges();
            }
        }

        public static void Remove(int ukprn, string fundingPeriod)
        {
            using (var context = new PerformanceManagementDbContext())
            {
                context.ClaimReconciliationReferenceDataReconProfilings.RemoveWhere(crrdrp =>
                    crrdrp.Ukprn == ukprn && crrdrp.FundingPeriod == fundingPeriod);
                context.SaveChanges();
            }
        }
    }
}