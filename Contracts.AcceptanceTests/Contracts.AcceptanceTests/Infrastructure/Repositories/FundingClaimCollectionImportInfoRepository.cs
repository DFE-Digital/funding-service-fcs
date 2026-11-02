namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System.Linq;
    using PerformanceManagementDomain.DataStore;

    public static class FundingClaimCollectionImportInfoRepository
    {
        public static int GetTotalRowsToImportForCollection(string periodClaimType)
        {
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                return context.FundingClaimCollectionImportInfos
                    .Single(c => c.PeriodClaimType == periodClaimType)
                    .TotalRowsToImport;
            }
        }
    }
}
