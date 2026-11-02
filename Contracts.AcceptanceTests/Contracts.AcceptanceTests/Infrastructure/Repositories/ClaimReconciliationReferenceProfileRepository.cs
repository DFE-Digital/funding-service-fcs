namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System.Collections.Generic;
    using System.Linq;
    using PerformanceManagementDomain.DataStore;
    using PerformanceManagementDomain.DataStore.Models;
    using Extensions;

    public static class ClaimReconciliationReferenceProfileRepository
    {
        public static void AddOrUpdateProfile(string claimReconciliationDeliverableGroupCode, int ukrpn, decimal plannedValue)
        {
            using (var context = new PerformanceManagementDbContext())
            {
                ClaimReconciliationReferenceDataProfile existingProfile = context.ClaimReconciliationReferenceDataProfiles.Find(claimReconciliationDeliverableGroupCode, ukrpn);

                if (existingProfile != null)
                {
                    existingProfile.PlannedValue = plannedValue;
                }
                else
                {
                    context.ClaimReconciliationReferenceDataProfiles.Add(new ClaimReconciliationReferenceDataProfile(
                                        claimReconciliationDeliverableGroupCode, ukrpn, plannedValue));
                }

                context.SaveChanges();
            }
        }

        public static void RemoveByUkprns(IReadOnlyCollection<int> ukprnsToRemove)
        {
            using (var context = new PerformanceManagementDbContext())
            {
                context.ClaimReconciliationReferenceDataProfiles.RemoveWhere(an => ukprnsToRemove.Contains(an.Ukprn));
                context.SaveChanges();
            }
        }
    }
}
