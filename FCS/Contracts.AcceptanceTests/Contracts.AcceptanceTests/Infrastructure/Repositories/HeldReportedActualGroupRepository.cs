namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System.Linq;
    using MoreLinq;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;

    public static class HeldReportedActualGroupRepository
    {
        public static void RemoveRowsForOrgId(string orgId)
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                context.HeldReportedActualGroups.Where(h => h.OrganisationIdentifier == orgId)
                    .ForEach(h => context.HeldReportedActualGroups.Remove(h));

                context.SaveChanges();
            }
        }

        public static int GetCountOfProcessedRows(string orgId, string fundingStreamPeriodCode, string collectionReturnCode)
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                return context.HeldReportedActualGroups.Count(h => h.OrganisationIdentifier == orgId && h.FundingStreamPeriodCode == fundingStreamPeriodCode &&
                                                                   h.CollectionReturnCode == collectionReturnCode && h.ProcessedDate != null);
            }
        }

        public static int GetCountOfUnprocessedRows(string orgId, string fundingStreamPeriodCode, string collectionReturnCode)
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                return context.HeldReportedActualGroups.Count(h => h.OrganisationIdentifier == orgId && h.FundingStreamPeriodCode == fundingStreamPeriodCode &&
                                                                   h.CollectionReturnCode == collectionReturnCode && h.ProcessedDate == null);
            }
        }
    }
}
