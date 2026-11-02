namespace ContractRequestDomain.Cfs.Detail.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using SFA.FCT.ContractRequestDomain.DataStore.Model;

    public static class AllocationNotificationListDeduper
    {
        public static IReadOnlyCollection<AllocationNotification> ToDedupedList(
            this IEnumerable<AllocationNotification> allocationNotifications)
        {
            var allocationNotificationsGroupedByUkprn = allocationNotifications.GroupBy(a => a.Ukprn);

            return allocationNotificationsGroupedByUkprn.Select(g => g.OrderBy(an => an.Id).First()).ToList();
        }
    }
}
